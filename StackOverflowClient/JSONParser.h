//
//  JSONParser.h
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/2/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "User.h"

@interface JSONParser : NSObject

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;
+(User *)userFromJSON:(NSDictionary *)userData;
+(NSArray *)usersFromJSON:(NSDictionary *)userData;

@end
