//
//  User.h
//  stackOverflowClient
//
//  Created by Erin Roby on 8/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

@import UIKit;
@interface User : NSObject

@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *profileImageURL;
@property(strong, nonatomic)UIImage *profileImage;

@end
