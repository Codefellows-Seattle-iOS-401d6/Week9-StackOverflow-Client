//
//  JSONParser.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/2/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser
+(NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
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


+(NSArray *)usersFromJSON:(NSDictionary *)userData{
    NSMutableArray *users = [[NSMutableArray alloc]init];
    
    NSArray *items = userData[@"items"];
    for (NSDictionary *item in items) {
        User *user = [[User alloc]init];



//        @property (strong, nonatomic) NSString *title;
//        @property (strong, nonatomic) UIImage *profileImage;
//        @property (strong, nonatomic) NSString *userClass;
//        
        user.userName = item[@"display_name"];
        user.profileImageURL = item[@"profile_image"];
//        user.profileImageURL = item[@""];
//        user.userClass = item[@""];
//        user.title = ;
//        user.profileImage = ;
        [users addObject:user];
        
    }
    
    
    return users;
    
}

@end
