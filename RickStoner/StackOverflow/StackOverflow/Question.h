//
//  Question.h
//  StackOverflow
//
//  Created by Rick  on 8/2/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
// title profileName,
@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *profileName;
@property(strong, nonatomic)NSString *imageURL;

@end
