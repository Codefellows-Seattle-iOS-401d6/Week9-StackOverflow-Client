//
//  StackOverflowService.h
//  StackOverflowClient
//
//  Created by Sung Kim on 8/2/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);

typedef void(^userFetchCompletion)(User *user, NSError *error);

@interface StackOverflowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;
+ (void)usersForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;
@end
