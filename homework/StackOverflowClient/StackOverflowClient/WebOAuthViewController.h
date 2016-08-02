//
//  WebOAuthViewController.h
//  StackOverflowClient
//
//  Created by Sung Kim on 8/1/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebOAuthViewController : UIViewController

+ (NSMutableDictionary *)keychainQuery:(NSString *)query;
+ (NSString *)accessToken;

@end
