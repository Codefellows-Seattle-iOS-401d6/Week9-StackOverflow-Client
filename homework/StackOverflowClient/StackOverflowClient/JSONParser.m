//
//  JSONParser.m
//  StackOverflowClient
//
//  Created by Sung Kim on 8/2/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData
{
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    
    NSArray *items = jsonData[@"items"];
    
    for (NSDictionary *item in items) {
        Question *question = [[Question alloc]init];
        question.title = item[@"title"];
        
        //nested dictionary inside each item dictionary
        NSDictionary *owner = item[@"owner"];
        
        question.profileName = owner[@"display_name"];
        question.imageURL = owner[@"profile_image"];
        
        [questions addObject:question];
    }
    return questions;
}

+ (User *)userFromJSON:(NSDictionary *)userData
{
    NSArray *userArray = userData[@"items"];
    
    NSDictionary *userInfo = userArray.firstObject;
    
    User *user = [[User alloc]init];
    
    user.userName = userInfo[@"display_name"];
    user.profileImageURL = userInfo[@"profile_image"];

    return user;
}

+ (NSArray *)usersFromJSON:(NSDictionary *)userData
{
    NSMutableArray *users = [[NSMutableArray alloc]init];
    
    NSArray *items = userData[@"items"];
    
    for (NSDictionary *item in items) {
        User *user = [[User alloc]init];
        
        user.userName = item[@"display_name"];
        user.profileImageURL = item[@"profile_image"];
        
        [users addObject:user];
    }
    return users;
}

@end
