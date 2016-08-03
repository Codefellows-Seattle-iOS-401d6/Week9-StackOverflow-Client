//
//  StackOverflowService.m
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/2/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import "StackOverflowService.h"
#import "JSONParser.h"
#import "WebOAuthViewController.h"
@import AFNetworking;

NSString const *clientKey = @"Qoq2hTkEJGUz6KcDDdpAKQ((";

@implementation StackOverflowService

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [WebOAuthViewController accessToken];
    
    
    NSString *searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity*intitle=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    
    
    //network call
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *results = [JSONParser questionResultsFromJSON:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results, nil);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, error);
        });
        
    }];
}

+(void)usersForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [WebOAuthViewController accessToken];
    
    NSString *searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/users?order=desc&sort=reputation*inname=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *results = [JSONParser usersFromJSON:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results, nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, error);
        });
    }];
}

@end
