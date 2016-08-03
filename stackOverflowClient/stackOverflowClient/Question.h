//
//  Question.h
//  stackOverflowClient
//
//  Created by Erin Roby on 8/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *profileName;
@property(strong, nonatomic)NSString *imageURL;

@end
