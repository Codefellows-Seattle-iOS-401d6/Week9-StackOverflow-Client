//
//  JSONParser.h
//  NewProject
//
//  Created by Jessica Malesh on 8/2/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Question.h"

@interface JSONParser : NSObject

+ (NSArray *)questionResulrsFromJSON: (NSDictionary *)jsonData;
+ (User *)userFromJSON:(NSDictionary *)userData;

@end
