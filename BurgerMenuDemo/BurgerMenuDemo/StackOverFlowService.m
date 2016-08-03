//
//  StackOverFlowService.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/2/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "StackOverFlowService.h"
#import "JSONParser.h"
@import AFNetworking;

NSString const *clientKey = @"2F2rBNIHgTeeBu1T9Ek3qA((";
NSString const *kSearchBaseURL = @"https://api.stackexchange.com/2.2/search?";
NSString const *kUsersBaseURL = @"https://api.stackexchange.com/2.2/users?";

@implementation StackOverFlowService

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler: (questionFetchCompletion)completionHandler{
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
        NSString *accessToken = [defaults objectForKey:@"token"];
    
        NSString *searchURLString = [NSString stringWithFormat:@"%@order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", kSearchBaseURL, searchTerm, clientKey, accessToken];
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            NSLog(@"%@",responseObject);
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

+(void)usersForSearchTerm:(NSString *)searchTerm completionHandler: (usersFetchCompletion) completionhandler{
    
    NSString *accessToken = @"";
    
    NSString *searchURLString = [NSString
                                 stringWithFormat:@"%@order=asc&sort=name&inname=%@&site=stackapps&key=%@&access_token=%@", kUsersBaseURL,searchTerm,clientKey,accessToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *results = [JSONParser usersFromJSON:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionhandler(results, nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionhandler(nil, error);
        });
    }];
}

@end
