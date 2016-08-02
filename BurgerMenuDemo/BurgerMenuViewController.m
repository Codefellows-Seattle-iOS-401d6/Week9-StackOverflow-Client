//
//  BurgerMenuViewController.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/1/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"

CGFloat const kBurgerOpenScreenDivider = 3.0;

CGFloat const kBurgerOpenScreenMultiplier = 2.0;

NSTimeInterval const kTimeToSlideMenu = 0.25;
CGFloat const kBurgerButtonWidth = 50.0;
CGFloat const kBurgerButtonHeight = 50.0;

NSString const *NSDerekErrorDomain = @"NSDerekErrorDomain";

@interface BurgerMenuViewController ()<UITableViewDelegate>

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSString *token;

@end

@implementation BurgerMenuViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    self.token = [defaults objectForKey:@"token"];
    
    NSError *error = nil;
    self.token = [self getFromKeyChain: &error];
    
        if (!self.token) {
            WebOAuthViewController *webVC = [[ WebOAuthViewController alloc]init];
            [self presentViewController:webVC animated:YES completion:nil];
        }
        else {
            if (error.code == 0 ) {
                NSLog(@"Success code returned loading keychain token!");
            } else {
                NSLog(@"error: %@, %@", error, NSLocalizedString(NSLocalizedFailureReasonErrorKey, nil));

            }
    }
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearchVC"];
    
    UserQuestionsViewController *userQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserQuestionsVC"];
    
    self.viewControllers = @[questionSearchVC, userQuestionsVC];
    
    UITableViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    
    mainMenu.tableView.delegate = self;
    
    
    [self setupChildController:userQuestionsVC];
    [self setupChildController:mainMenu];
    [self setupChildController:questionSearchVC];
    
    
    self.topViewController = questionSearchVC;
    
    [self setupBurgerButton];
    [self setupPanGesture];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupBurgerButton{
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 20.0, kBurgerButtonWidth, kBurgerButtonHeight)];
    
    [burgerButton setImage: [UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    
    [self.topViewController.view addSubview:burgerButton];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.burgerButton = burgerButton;
}

- (void) burgerButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
        
    } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        
        [self.topViewController.view addGestureRecognizer:tap];
        sender.userInteractionEnabled = NO;
    }];
}


- (void) tapToCloseMenu: (UITapGestureRecognizer *)sender {
    [self.topViewController.view removeGestureRecognizer:sender];
    
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        self.topViewController.view.center = self.view.center;
        
    } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = YES;
        
    }];
}


- (void)  setupChildController:(UIViewController *)viewController {
    [ self addChildViewController:viewController];
    
    viewController.view.frame = self.view.frame;
    
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void) setupPanGesture{
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
    [self.topViewController.view addGestureRecognizer:self.panRecognizer];
}

- (void) topViewControllerPanned: (UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x >= 0 ) {
            self.topViewController.view.center = CGPointMake(self.view.center.x + translation.x, self.view.center.y);
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
       if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kBurgerOpenScreenDivider ) {
           
           [UIView animateWithDuration:kTimeToSlideMenu animations:^{
               self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
           } completion:^(BOOL finished) {
               UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
               
               [self.topViewController.view addGestureRecognizer:tap];
               
               self.burgerButton.userInteractionEnabled = NO;
               
           }];
       } else {
           [UIView animateWithDuration:kTimeToSlideMenu animations:^{
               self.topViewController.view.center = self.view.center;
           }];
       }

    }
 }

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UIViewController *newViewController = self.viewControllers[indexPath.row];
    
    if (![newViewController isEqual:self.topViewController]) {

        [self changeTopViewController:newViewController];
    } else {
        NSLog(@"Happening Here");
        
    }
}

- (void) changeTopViewController: (UIViewController *)newTopViewController {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.topViewController.view.frame = CGRectMake(strongSelf.view.frame.size.width, strongSelf.topViewController.view.frame.origin.y, strongSelf.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        CGRect oldFrame = strongSelf.topViewController.view.frame;
        [strongSelf.topViewController willMoveToParentViewController:nil];
        [strongSelf.topViewController.view removeFromSuperview];
        [strongSelf.topViewController removeFromParentViewController];
        
        [strongSelf addChildViewController:newTopViewController];
        
        newTopViewController.view.frame = oldFrame;
        [strongSelf.view addSubview:newTopViewController.view];
        [newTopViewController didMoveToParentViewController:strongSelf];
    
        
        strongSelf.topViewController = newTopViewController;
        
        [strongSelf.burgerButton removeFromSuperview];
        [strongSelf.topViewController.view addSubview:strongSelf.burgerButton];
        
        [UIView animateWithDuration:kTimeToSlideMenu animations:^{
            strongSelf.topViewController.view.center = strongSelf.view.center;
            
        } completion:^(BOOL finished) {
            [strongSelf.topViewController.view addGestureRecognizer:strongSelf.panRecognizer];
            strongSelf.burgerButton.userInteractionEnabled = YES;
        }];
        
    }];
}

- (NSString *)getFromKeyChain: (NSError **)error {
    NSDictionary *keychainDict = @{
                                   (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrService : kAccessTokenKey,
                                   (__bridge id)kSecAttrAccount : kAccessTokenKey,
                                   (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
                                   (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
                                   (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne
                                   
                                   };
    
    CFDataRef result = nil;
    
    OSStatus keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)keychainDict, (CFTypeRef *)&result);
    
    NSLog(@"Error Code: %d", (int)keychainError);
    
    if(keychainError == noErr)
    {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Keychain info Found", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Success loading keychain.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Success.", nil)
                                   };
        *error = [NSError errorWithDomain: (NSString * _Nonnull)NSDerekErrorDomain code:0 userInfo:userInfo];

        return [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData * _Nonnull)(result)];
    } else {
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Keychain key was not found.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Unable to load keychain info from system.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Not sure there is anything to do but take matters in to your own hands.", nil)
                                   };
        *error = [NSError errorWithDomain: (NSString * _Nonnull)NSDerekErrorDomain code:-1 userInfo:userInfo];
        
        return nil;
    }
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
