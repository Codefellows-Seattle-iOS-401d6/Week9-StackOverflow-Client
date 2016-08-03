//
//  User.h
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/2/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

@import UIKit;

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) UIImage *profileImage;

@end
