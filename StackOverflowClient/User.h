//
//  User.h
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/2/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

@import UIKit;

@interface User : NSObject

@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)NSString *profileImageURL;
@property (strong, nonatomic)UIImage *profileImage;

@end
