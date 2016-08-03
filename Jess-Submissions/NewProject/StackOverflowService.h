//
//  StackOverflowService.h
//  NewProject
//
//  Created by Jessica Malesh on 8/2/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);


@interface StackOverflowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler;

@end
