//
//  WebOAuthViewController.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/1/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "WebOAuthViewController.h"
@import WebKit;
@import Security;

NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog";

NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";
NSString const *kClientID = @"7596";
NSString const *kAccessTokenKey = @"kAccessTokenKey";



@interface WebOAuthViewController ()<WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    
    NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kBaseURL,kClientID, kRedirectURI];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
        NSString *fragmentString = navigationAction.request.URL.fragment;
        
        NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
        NSString *fullTokenParameter = components.firstObject;
        NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
        
        NSLog(@"Got token: %@", token);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:@"token"];
        
        if ([self saveToKeyChain:token] == YES ) {
            NSLog(@"Success saving token %@", token);
        } else {
            NSLog(@"Error saving token");
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



- (BOOL) saveToKeyChain:(NSString *)token{
    NSDictionary *keychainDict = @{
                                   (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrService : kAccessTokenKey,
                                   (__bridge id)kSecAttrAccount : kAccessTokenKey,
                                   (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
                                   (__bridge id)kSecValueData : [NSKeyedArchiver archivedDataWithRootObject:token]

                                   };
    OSStatus keychainStatus;
    
    
   keychainStatus = SecItemDelete( (__bridge CFDictionaryRef)keychainDict);
    if (keychainStatus){
        NSLog(@"Success adding to keychain: %@", token);
        
        
        keychainStatus =  SecItemAdd((__bridge CFDictionaryRef)keychainDict, nil);
        if (keychainStatus) {
            return YES;
        } else {
            return NO;
        }
    }
    
    
    
    
    return NO;
    
}
//- (NSString *)getFromKeyChain {
//    NSDictionary *keychainDict = @{
//                                   (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
//                                   (__bridge id)kSecAttrService : kAccessTokenKey,
//                                   (__bridge id)kSecAttrAccount : kAccessTokenKey,
//                                   (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
//                                   (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
//                                   (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne
//
//                                   };
//
//    CFDataRef result = nil;
//    
//    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)keychainDict, (CFTypeRef *)&result);
//    
//    NSLog(@"Error Code: %d", (int)error);
//    
//    if(error == noErr)
//    {
//        return [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData * _Nonnull)(result)];
//    } else {
//        return nil;
//    }
//}

- (NSDictionary *)keychainQuery: (NSString *) query {
    
    NSDictionary *keychainDict = @{
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrService : query,
                                    (__bridge id)kSecAttrAccount : query,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
                                     };
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//     
//        NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
//        [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
//        [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
//        [dict setObject:service forKey:(__bridge id)kSecAttrService];
//        [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
//    
//    
    return keychainDict;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
