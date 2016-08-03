//
//  JSONParser.m
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "JSONParser.h"


@implementation JSONParser

+ (NSArray *)questionResultsFromJSON:(NSDictionary *)jsonData {
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

+ (NSArray *)userFromJSON:(NSDictionary *)userData {
    NSMutableArray *users = [[NSMutableArray alloc]init];
    NSArray *userArray = userData[@"items"];
    for (NSDictionary *userDict in userArray) {
        User *user = [[User alloc]init];
        user.userName = userDict[@"display_name"];
        user.profileImageURL = userDict[@"profile_image"];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: userDict[@"profile_image"]]];
        user.profileImage = [UIImage imageWithData: imageData];
        
        [users addObject:user];
    }
    return users;
}

@end
