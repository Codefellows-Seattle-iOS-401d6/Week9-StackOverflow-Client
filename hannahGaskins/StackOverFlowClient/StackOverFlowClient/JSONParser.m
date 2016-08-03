//
//  JSONParser.m
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/2/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData
{
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    
    NSArray *items = jsonData[@"items"];
    
    for (NSDictionary *item in items) {
        Question *question = [[Question alloc]init];
        question.title = item[@"title"];
        NSDictionary *owner = item[@"owner"];
        question.profileName = owner[@"display_name"];
        question.imageURL = owner[@"profile_image"];
        
        [questions addObject:question];
    }
    
    return questions;
    
}

+(User *)userFromJSON:(NSDictionary *)userData
{
    NSArray *userArray = userData[@"items"];
    
    NSDictionary *userInfo = userArray.firstObject;
    
    User *user = [[User alloc]init];
    user.username = userInfo[@"display_name"];
    user.profileImage = userInfo[@"profile_image"];
    
    return user;
}

@end
