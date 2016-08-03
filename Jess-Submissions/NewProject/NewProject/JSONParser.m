//
//  JSONParser.m
//  NewProject
//
//  Created by Jessica Malesh on 8/2/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"
#import "Question.h"

@implementation JSONParser


+ (NSArray *)questionResulrsFromJSON: (NSDictionary *)jsonData
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


+ (User *)userFromJSON:(NSDictionary *)userData
{
    NSArray *userArray = userData[@"items"];
    
    NSDictionary *userInfo = userArray.firstObject;
    
    User *user = [[User alloc]init];
    user.username = userInfo[@"display_name"];
    user.profileImageURL = userInfo[@"profile_image"];
    
    
    return user;
}


@end
