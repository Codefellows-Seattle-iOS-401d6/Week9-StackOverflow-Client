//
//  StackOverflowService.m
//  StackOverflowClient
//
//  Created by Sung Kim on 8/2/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import "StackOverflowService.h"
#import "WebOAuthViewController.h"
#import "JSONParser.h"
@import AFNetworking;

NSString const *clientKey = @"DUzBgM5XUxTE0yw9XbKKdw((";
NSString const *kSearchBaseURL = @"https://api.stackexchange.com/2.2/search";
NSString const *kUserSearchBaseURL = @"https://api.stackexchange.com/2.2/users";

@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [WebOAuthViewController accessToken];
    
    NSString *searchURLString = [NSString stringWithFormat:@"%@?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", kSearchBaseURL, searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@", responseObject);
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

+ (void)usersForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [WebOAuthViewController accessToken];
    
    NSString *searchURLString = [NSString stringWithFormat:@"%@?order=desc&sort=reputation&inname=%@&site=stackoverflow&key=%@&access_token=%@", kUserSearchBaseURL, searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
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
