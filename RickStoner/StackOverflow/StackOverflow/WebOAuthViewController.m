//
//  WebOAuthViewController.m
//  StackOverflow
//
//  Created by Rick  on 8/1/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "WebOAuthViewController.h"
@import WebKit;
@import Security;

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7600";
NSString const *kAccessToken = @"kAccessTokenTwo";

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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
        
        NSLog(@"Token %@", token);
        NSMutableDictionary *query = [WebOAuthViewController keyChainQuery:@"AccessToken"];
        [self saveToKeyChain:query token:token];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);

}

+ (NSMutableDictionary *)keyChainQuery:(NSString *)query {
    NSMutableDictionary *keyChainDictionary = [[NSMutableDictionary alloc] init];
    [keyChainDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id) kSecClass];
    [keyChainDictionary setObject:query forKey:(__bridge id) kSecAttrService];
    [keyChainDictionary setObject:query forKey:(__bridge id) kSecAttrAccount];
    [keyChainDictionary setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id) kSecAttrAccessible];
    return keyChainDictionary;
}

- (void)saveToKeyChain:(NSMutableDictionary *)query token:(NSString *)token {
 
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
    [query setObject:tokenData forKey:(__bridge id)kSecValueData];
    SecItemDelete((__bridge CFDictionaryRef)query);
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSLog(@"Status: %d", status);
}

+ (NSString *)accessToken{
    NSMutableDictionary *searchDictionary = [self keyChainQuery:@"AccessToken"];
    CFDataRef result = nil;
    
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id) kSecMatchLimit];
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    
    if (error == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *tokenData = resultDict[(__bridge id)kSecValueData];
        NSString *token = [[NSString alloc]initWithData:tokenData encoding:NSUTF8StringEncoding];
        token = @"ReyjqBMg8tR57ZSxwpB24w))";
        return token;
    } else {
        NSLog(@"No token");
        return nil;
    }
}

-(void)resetKeychain {
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}

-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    SecItemDelete((__bridge CFDictionaryRef) dict);
}


@end
