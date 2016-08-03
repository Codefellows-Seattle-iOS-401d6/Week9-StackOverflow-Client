//
//  StackOverflowService.h
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/2/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);
typedef void(^usersFetchCompletion) (NSArray *results, NSError *error);

@interface StackOverflowService : NSObject

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;
+(void)usersForSearchTerm:(NSString *)searchTerm completionHandler:(usersFetchCompletion)completionHandler;


@end
