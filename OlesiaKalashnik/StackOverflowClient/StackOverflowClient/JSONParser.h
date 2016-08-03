//
//  JSONParser.h
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/2/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "User.h"

@interface JSONParser : NSObject

+(NSArray *) questionResultsFromJSON:(NSDictionary *)JSONData;
+(NSArray *) usersFromJSON:(NSDictionary *)userData;

@end
