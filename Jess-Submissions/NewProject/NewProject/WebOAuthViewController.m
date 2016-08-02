//
//  WebOAuthViewController.m
//  NewProject
//
//  Created by Jessica Malesh on 8/1/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>
#import <Security/Security.h>



NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
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
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
        
        if (SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL) == noErr)
            {
                NSLog(@"Token already exists");
            } else
            {
                query[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
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
        NSDictionary *userInfo = @{@"Description" : @"Access Token does not exist."};
        NSError *myError = [NSError errorWithDomain:@"MyDomain" code:101 userInfo:userInfo];
        NSLog(@"%@", [myError.userInfo objectForKey:@"Description"]);
        
        return nil;
    }
    
}


        
@end



















