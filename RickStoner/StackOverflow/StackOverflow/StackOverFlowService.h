//
//  StackOverFlowService.h
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef void(^questionFetchCompletion)(NSArray *results, NSError *error);

@interface StackOverFlowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searchTerm searchCategory:(NSString *)searchCategory completionHandler:(questionFetchCompletion)completion;



@end
