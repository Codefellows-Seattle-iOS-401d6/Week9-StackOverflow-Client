//
//  JSONParser.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/2/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+(NSArray *) questionResultsFromJSON:(NSDictionary *)JSONData {
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    NSArray *items = JSONData[@"items"];
    
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

+(NSArray *) usersFromJSON:(NSDictionary *)userData {
    NSMutableArray *users = [[NSMutableArray alloc]init];
    NSArray *items = userData[@"items"];
    
    for (NSDictionary *item in items) {
        User *user = [[User alloc]init];
        user.name = item[@"display_name"];
        user.profileImageURL = item[@"profile_image"];
        
        [users addObject:user];
    }

    return users;
}

//+(User *) userFromJSON:(NSDictionary *)userData {
//    NSArray *userArray = userData[@"items"];
//    NSDictionary *userInfo = userArray.firstObject;
//    User *user = [[User alloc ]init];
//    user.name = userInfo[@"display_name"];
//    user.profileImageURL = userInfo[@"profile_image"];
//    return user;
//}

@end
