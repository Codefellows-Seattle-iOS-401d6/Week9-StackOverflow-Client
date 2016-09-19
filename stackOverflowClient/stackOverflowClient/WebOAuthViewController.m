//
//  WebOAuthViewController.m
//  stackOverflowClient
//
//  Created by Erin Roby on 8/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientId =@"7594";

@interface WebOAuthViewController () <WKNavigationDelegate>

@end

@implementation WebOAuthViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kBaseURL, kClientId, kRedirectURI];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    [self customError];
}

-(NSError *)customError {
    NSString *domain = @"This is my custom error domain";
    NSInteger code = 401;
    NSDictionary *userInfo = @{@"Description" : @"Not Found."};
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
}

// Homework with keychain changes here:
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:@"token"];
        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end









