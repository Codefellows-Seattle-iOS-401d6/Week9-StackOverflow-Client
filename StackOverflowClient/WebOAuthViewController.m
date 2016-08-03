//
//  WebOAuthViewController.m
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/1/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import "WebOAuthViewController.h"
@import WebKit;
@import Security;

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7597";
NSString const *kAccesstokenID = @"kAccessTokenID";

typedef enum
{
    MissingAccessToken = 0,
    ResponseFromStackExchange
} stackExchangeError;

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
    NSLog(@"%@", url);
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%@", navigationAction.request.URL.path);
//    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/authorize"])
//    {
//        NSString *fragmentString = navigationAction.request.URL.fragment;
//        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
//        NSString *fullTokenParameter = components.firstObject;
//        NSString *token = [fullTokenParameter componentsSeparatedByString:@"=" ].lastObject;
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //update this to keychain
//        
//        [defaults setObject:token forKey:@"token"];
//        NSLog(@"%@", token);
//        [defaults synchronize];
//        NSLog(@"this is really the token: %@", [defaults objectForKey:@"token"]);
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"])
    {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"=" ].lastObject;
        
        NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
        
        keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
        keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
        keychainItem[(__bridge id)kSecAttrServer] = @"AccessToken";
        keychainItem[(__bridge id)kSecAttrAccount] = @"AccessToken";
         
         if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
         {
             NSLog(@"Token exists.");
         } else {
             keychainItem[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
             OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
             NSLog(@"error: %d", (int)sts);
         }
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //update this to keychain
//        
//        [defaults setObject:token forKey:@"token"];
//        
//        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
         
+ (NSString *)accessToken
         {
             NSMutableDictionary *query = [NSMutableDictionary dictionary];
             
             query[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
             query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
             query[(__bridge id)kSecAttrServer] = @"AccessToken";
             query[(__bridge id)kSecAttrAccount] = @"AccessToken";
             query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
             query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
             
             CFDataRef result = nil;
             
             OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
             
             if (sts == noErr)
             {
                 NSDictionary *resultDictionary = (__bridge_transfer NSDictionary *)result;
                 NSData *password = resultDictionary[(__bridge id)kSecValueData];
                 NSString *pass = [[NSString alloc]initWithData:password encoding:NSUTF8StringEncoding];
                 return pass;
             }
             return nil;
         }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
