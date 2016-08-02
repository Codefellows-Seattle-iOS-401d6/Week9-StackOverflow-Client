//
//  BurgerMenuViewController.m
//  stackOverflowClient
//
//  Created by Erin Roby on 8/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"
@import UIKit;


CGFloat const kBurgerOpenScreenDivider = 3.0; // lowercase k for constant is a convention.
CGFloat const kBurgerOpenScreenMultiplier = 2.0;
NSTimeInterval const kTimeToSlideMenu = 0.25;
CGFloat const kBurgerButtonWidth = 50.0;
CGFloat const kBurgerButtonheight = 50.0;

@interface BurgerMenuViewController () <UITableViewDelegate>

@property(strong, nonatomic)UIViewController *topViewController;
@property(strong, nonatomic)NSArray *viewControllers;
@property(strong, nonatomic)UIPanGestureRecognizer *panRecognizer;
@property(strong, nonatomic)UIButton *burgerButton;
@property(strong, nonatomic)NSString *token;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearchVC"];
    UserQuestionsViewController *userQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserQuestionsVC"];
    
    self.viewControllers = @[questionSearchVC, userQuestionVC];
    UITableViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    mainMenu.tableView.delegate = self;
    
    // setup child views --> not the heirarchy here. this order matters!
    [self setupChildController:userQuestionVC];
    [self setupChildController:mainMenu];
    [self setupChildController:questionSearchVC];
    
    self.topViewController = questionSearchVC;
    
    [self setupBurgerButton];
    [self setupPanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Homework with keychain changes here:
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults objectForKey:@"token"];
    if (!self.token) {
        WebOAuthViewController *webVC = [[WebOAuthViewController alloc]init];
        [self presentViewController:webVC animated: YES completion:nil];
    }
}

-(void)setupBurgerButton {
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 20.0, kBurgerButtonWidth, kBurgerButtonheight)];
    
    [burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    [self.topViewController.view addSubview:burgerButton];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.burgerButton = burgerButton;
}

-(void)burgerButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        
        self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
   
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        
        [self.topViewController.view addGestureRecognizer:tap];
        sender.userInteractionEnabled = NO;
    }];
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)sender {
    [self.topViewController.view removeGestureRecognizer:sender];
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = YES;
    }];
}

-(void)setupChildController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.frame;
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
}

-(void)setupPanGesture {
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
    [self.topViewController.view addGestureRecognizer:self.panRecognizer];
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x >= 0) {
            self.topViewController.view.center = CGPointMake(self.view.center.x + translation.x, self.view.center.y);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width/kBurgerOpenScreenDivider) {
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *newViewController = self.viewControllers[indexPath.row];
    if (![newViewController isEqual:self.topViewController]) {
        [self changeTopViewController:newViewController];
    }
    
}

-(void)changeTopViewController:(UIViewController *)newTopViewController {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.topViewController.view.frame = CGRectMake(strongSelf.view.frame.size.width, strongSelf.topViewController.view.frame.origin.y, strongSelf.topViewController.view.frame.size.width, strongSelf.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        __strong typeof (weakSelf) strongSelf = weakSelf;

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

@end































