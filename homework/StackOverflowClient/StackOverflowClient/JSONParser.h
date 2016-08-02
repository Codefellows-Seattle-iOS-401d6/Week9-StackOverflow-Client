//
//  JSONParser.h
//  StackOverflowClient
//
//  Created by Sung Kim on 8/2/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Question.h"

@interface JSONParser : NSObject

+ (NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;
+ (User *)userFromJSON:(NSDictionary *)userData;
+ (NSArray *)usersFromJSON:(NSDictionary *)userData;

@end
