//
//  StackOverflowService.m
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/2/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import "StackOverflowService.h"
#import "JSONParser.h"

@import AFNetworking;

NSString const *clientKey = @"";

@implementation StackOverflowService

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;
{
    // TODO REFERENCE ACCESS TOKEN TO MAKE REQUESTS W
    NSString *accessToken;
    // TODO
    NSString *searchURLString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=dec&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //comeback to this
        NSLog(@"%@",responseObject);
        NSArray *results = [JSONParser questionResultsFromJSON:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results, nil);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}


@end
