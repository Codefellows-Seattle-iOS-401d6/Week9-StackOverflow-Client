//
//  StackOverFlowService.m
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "StackOverFlowService.h"
#import "WebOAuthViewController.h"
#import "JSONParser.h"
@import AFNetworking;

NSString const *clientKey = @"W522juA*qpaUCea0cVXS6A((";

@implementation StackOverFlowService


+ (void)questionsForSearchTerm:(NSString *)searchTerm searchCategory:(NSString *)searchCategory completionHandler:(questionFetchCompletion)completion{
    
    NSString *accessToken = [WebOAuthViewController accessToken];
    NSString *searchURLString = [[NSString alloc]init];
    if ([searchCategory  isEqual: @"User"]) {
        searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/users?pagesize=30&order=desc&sort=reputation&inname=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    } else if ([searchCategory  isEqual: @"Questions"]) {
        searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    } else {
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([searchCategory isEqualToString:@"Questions"]) {
            NSArray *results = [JSONParser questionResultsFromJSON:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results, nil);
            });
        } else {
            NSArray *results = [JSONParser userFromJSON:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results, nil);
            });
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
}

@end
