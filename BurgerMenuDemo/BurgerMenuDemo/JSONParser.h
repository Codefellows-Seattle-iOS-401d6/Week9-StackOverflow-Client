//
//  JSONParser.h
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/2/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Question.h"



@interface JSONParser : NSObject

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;
+(NSArray *)usersFromJSON:(NSDictionary *)userData;

@end
