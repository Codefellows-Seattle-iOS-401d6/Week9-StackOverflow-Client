//
//  WebOAuthViewController.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>
#import <Security/Security.h>


NSString *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString *kRedirectURL = @"https://stackexchange.com/oauth/login_success";
NSString *kClientID = @"7598";

@interface WebOAuthViewController () <WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kBaseURL, kClientID, kRedirectURL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSLog(@"%@", components);
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
        
        //save token to keychain
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
        
        if(SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL) == noErr)
        {
            NSLog(@"The Token Already Exists");
            
        }else
        {
            query[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding]; //encode token
            
            OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
            NSLog(@"Error Code: %d", (int)sts);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (NSString *)getToken {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    
    //Check if token already exists.
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    NSLog(@"Error Code: %d", (int)sts);
    
    if(sts == noErr)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *tkn = resultDict[(__bridge id)kSecValueData];
        NSString *token = [[NSString alloc] initWithData:tkn encoding:NSUTF8StringEncoding];
        return token;
        
    } else {
        //Error
        NSDictionary *userInfo = @{@"Description" : @"Access Token does not exist."};
        NSError *myError = [NSError errorWithDomain:@"MyDomain" code:101 userInfo:userInfo];
        NSLog(@"%@", [myError.userInfo objectForKey:@"Description"]);
        
        return nil;
    }
    
}

@end
