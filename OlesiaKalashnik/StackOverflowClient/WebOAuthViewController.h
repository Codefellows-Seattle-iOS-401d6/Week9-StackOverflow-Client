//
//  WebOAuthViewController.h
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

@interface WebOAuthViewController : ViewController

-(NSString *) getToken;

@end
