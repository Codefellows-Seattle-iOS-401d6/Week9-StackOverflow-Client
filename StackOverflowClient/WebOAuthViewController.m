//
//  WebOAuthViewController.m
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/1/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7597";

@interface WebOAuthViewController () <WKNavigationDelegate>


@end

@implementation WebOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kBaseURL, kClientID, kRedirectURI];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"])
    {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"=" ].lastObject;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //update this to keychain
        
        [defaults setObject:token forKey:@"token"];
        
        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
