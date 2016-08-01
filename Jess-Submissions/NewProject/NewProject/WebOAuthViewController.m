//
//  WebOAuthViewController.m
//  NewProject
//
//  Created by Jessica Malesh on 8/1/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>


NSString const *kBaseURL = @"httsp://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7593";

@interface WebOAuthViewController () <WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id%@redirect_uri=%@", kBaseURL, kClientID, kRedirectURI];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    ///we need to save to keycahin
    
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        
        NSString *fullTokenParamater = components.firstObject;
        NSString *token = [fullTokenParamater componentsSeparatedByString:@"="].lastObject;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:token forKey:@"token"];
        
        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
