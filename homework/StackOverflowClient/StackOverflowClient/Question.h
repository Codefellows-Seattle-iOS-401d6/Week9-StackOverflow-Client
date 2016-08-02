//
//  Question.h
//  StackOverflowClient
//
//  Created by Sung Kim on 8/2/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *profileName;
@property (strong, nonatomic)NSString *imageURL;

@end
