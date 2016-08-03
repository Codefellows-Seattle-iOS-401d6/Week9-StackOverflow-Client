//
//  JSONParser.h
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "User.h"

@interface JSONParser : NSObject

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData;

+(NSArray *)userFromJSON:(NSDictionary *)userData;

@end
