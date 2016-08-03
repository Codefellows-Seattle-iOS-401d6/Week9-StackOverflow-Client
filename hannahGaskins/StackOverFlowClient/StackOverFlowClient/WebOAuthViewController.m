//
//  WebOAuthViewController.m
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/1/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

@import Security;

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7590";

@interface WebOAuthViewController ()<WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",kBaseURL, kClientID, kRedirectURI];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
        
        
        
        // TODO
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:token forKey:@"token"];
//        [defaults synchronize];
        
        NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
        
        //Populate it with the data and the attributes we want to use.
        
        keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
        keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
        keychainItem[(__bridge id)kSecAttrServer] = @"AccessToken";
        keychainItem[(__bridge id)kSecAttrAccount] = @"AccessToken";
        
        //Check if this keychain item already exists.
        
        if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
        {
            NSLog(@"The token already exists");
            
        } else
        {
            keychainItem[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding]; //Our password
            
            OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
            NSLog(@"Error Code: %d", (int)sts);
        }
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (NSString *)accessToken
{
    // empty dictionary to store values and keys
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    query[(__bridge id)kSecAttrServer] = @"AccessToken";
    query[(__bridge id)kSecAttrAccount] = @"AccessToken";
    
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDataRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    if (sts == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
        
        return password;
    }
    return nil;
}

@end
