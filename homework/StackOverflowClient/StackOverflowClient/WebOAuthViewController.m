//
//  WebOAuthViewController.m
//  StackOverflowClient
//
//  Created by Sung Kim on 8/1/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import "WebOAuthViewController.h"
@import WebKit;
@import Security;

//good question here
NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7591";
NSString const *kAccessTokenID = @"kAccessTokenID";

typedef enum {
    MissingAccessToken = 0,
    ResponseFromStackExchange
} stackExchangeError;

@interface WebOAuthViewController () <WKNavigationDelegate>



@end

@implementation WebOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kBaseURL, kClientID, kRedirectURI];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        
//        NSLog(@"%@", components);
        
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;

        
        //************CHANGE TO KEYCHAIN************
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:token forKey:@"token"];
//        [defaults synchronize];
        
        NSMutableDictionary *query = [[self class] keychainQuery:@"kAccessTokenID"];
        query[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"This is the token: %@", token);
        
        SecItemDelete((__bridge CFDictionaryRef)query);
        SecItemAdd((__bridge CFDictionaryRef)query, nil);
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

+ (NSMutableDictionary *)keychainQuery:(NSString *)query
{
    NSMutableDictionary *keychainDictionary = [[NSMutableDictionary alloc]init];
    keychainDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainDictionary[(__bridge id)kSecAttrService] = query;
    keychainDictionary[(__bridge id)kSecAttrAccount] = query;
    keychainDictionary[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlock;

    return keychainDictionary;
}

+ (NSString *)accessToken
{
    NSMutableDictionary *query = [self keychainQuery:@"kAccessTokenID"];
    query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    CFDataRef dataRef = nil;
    
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&dataRef);

    if (error == noErr) {

        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)dataRef;
        NSData *tken = resultDict[(__bridge id)kSecValueData];
        NSString *token = [[NSString alloc] initWithData:tken encoding:NSUTF8StringEncoding];
        return token;
    } else {
        NSLog(@"Error: %d", (int)error);
        NSLog(@"There is no token");
        return nil;
    }
}

@end
