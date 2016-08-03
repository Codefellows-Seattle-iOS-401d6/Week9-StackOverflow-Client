//
//  StackOverflowService.h
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/2/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);

@interface StackOverflowService : NSObject

+(void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;

+(void)usersForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;

@end
