//
//  StackOverflowService.m
//  NewProject
//
//  Created by Jessica Malesh on 8/2/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import "StackOverflowService.h"
#import "WebOAuthViewController.h"
#import "JSONParser.h"
@import AFNetworking;

NSString const *clientKey = @"8lPpZYa6XOWnxFJe6W8N*g((";
NSString const *kSearchBaseURL = @"https://api.stackexchange.com/2.2/search";
NSString const *kUserSearchBaseURL = @"https://api.stackexchange.com/2.2/users";



@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [WebOAuthViewController getToken];
    
    NSString *searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *results = [JSONParser questionResulrsFromJSON:responseObject];
        
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
    NSString *accessToken = [WebOAuthViewController getToken];
    
    NSString *searchURLString = [NSString stringWithFormat:@"%@?order=desc&sort=reputation&inname=%@&site=stackoverflow&key=%@&access_token=%@", kUserSearchBaseURL, searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *results = [JSONParser userFromJSON:responseObject];
        
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
