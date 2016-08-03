//
//  JSONParser.h
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/2/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "User.h"

@interface JSONParser : NSObject

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;

+(User *)userFromJSON:(NSDictionary *)userData;

@end
