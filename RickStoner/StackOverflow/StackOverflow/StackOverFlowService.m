//
//  StackOverFlowService.m
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "StackOverFlowService.h"
#import "WebOAuthViewController.h"
@import AFNetworking;

NSString const *clientKey = @"W522juA*qpaUCea0cVXS6A((";

@implementation StackOverFlowService


+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completion {
    
    NSString *accessToken = [WebOAuthViewController accessToken];
    NSString *searchURLString = [NSString stringWithFormat:@"htps://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
