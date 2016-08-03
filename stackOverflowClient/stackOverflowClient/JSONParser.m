//
//  JSONParser.m
//  stackOverflowClient
//
//  Created by Erin Roby on 8/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData {
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    NSArray *items = jsonData[@"items"];
    
    for (NSDictionary *item in items) {
        Question *question = [[Question alloc]init];
        question.title = item[@"title"];
        NSDictionary *owner = item[@"owner"];
        
        question.profileName = owner[@"display_name"];
        question.imageURL = owner[@"profile_name"];
        [questions addObject:question];
    }
    
    return questions;
}

+(NSArray *)usersFromJSON:(NSDictionary *)userData {
    NSMutableArray *usersArray = [[NSMutableArray alloc]init];
    NSArray *items = userData[@"items"];
    
    for (NSDictionary *item in items) {
        User *user = [[User alloc]init];
        
        user.username = item[@"display_name"];
        user.profileImageURL = item[@"profile_image"];
        
        [usersArray addObject:user];
    }
    
    return usersArray;
}

@end
