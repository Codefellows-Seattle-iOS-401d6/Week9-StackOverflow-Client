//
//  StackOverFlowService.h
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/2/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);
typedef void(^usersFetchCompletion)(NSArray *results, NSError *error);

@interface StackOverFlowService : NSObject

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler: (questionFetchCompletion)completionHandler;
+(void)usersForSearchTerm:(NSString *)searchTerm completionHandler: (usersFetchCompletion) completionhandler;

@end
