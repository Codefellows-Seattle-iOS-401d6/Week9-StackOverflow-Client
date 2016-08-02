//
//  WebOAuthViewController.h
//  StackOverflow
//
//  Created by Rick  on 8/1/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebOAuthViewController : UIViewController

+ (NSString *)accessToken;
+ (NSMutableDictionary *)keyChainQuery:(NSString *)query;

@end
