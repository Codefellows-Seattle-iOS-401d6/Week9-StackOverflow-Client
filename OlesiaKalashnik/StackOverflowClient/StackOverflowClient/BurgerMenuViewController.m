//
//  BurgerMenuViewController.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionsSerarchViewController.h"
#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"
@import UIKit;


CGFloat const kBurgerOpenScreenDevider = 3.0;
CGFloat const kBurgerOpenScreenMultiplier = 2.0;
NSTimeInterval const kTimeToSlideMenu = 0.5;
CGFloat const kBurgerButtonWidth = 50.0;
CGFloat const kBurgerButtonHeight = 50.0;


@interface BurgerMenuViewController () <UITableViewDelegate>
@property (strong, nonatomic)UIViewController *topViewController;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSString *token;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QuestionsSerarchViewController *questionsSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionsSearchViewController"];
    UserQuestionsViewController *userQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserQuestionsViewController"];
    self.viewControllers = @[questionsSearchVC, userQuestionsVC];
    UITableViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    mainMenu.tableView.delegate = self;
    
    [self setupChildController:userQuestionsVC];
    [self setupChildController:mainMenu];
    [self setupChildController:questionsSearchVC];
    
    self.topViewController = questionsSearchVC;
    
    [self setupPanGesture];
    [self setupBurgerButton];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WebOAuthViewController *webVC = [[WebOAuthViewController alloc]init];

    self.token = [webVC getToken];
    NSLog(@"Token: %@", self.token);
    if (!self.token) {
        [self presentViewController:webVC animated:YES completion:nil];
    }
}


-(void)setupBurgerButton {
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 20.0, kBurgerButtonWidth, kBurgerButtonHeight)];
    [burgerButton setImage:[UIImage imageNamed:@"bad_burger"] forState:UIControlStateNormal];
    [self.topViewController.view addSubview:burgerButton];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.burgerButton = burgerButton;
}

-(void)burgerButtonPressed:(UIButton *)sender{
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    } completion:^(BOOL finished) {
        //handling tap
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tapRecognizer];
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

-(void)setupChildController:(UIViewController *)vc {
    [self addChildViewController:vc];
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

-(void)setupPanGesture {
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topVCPanned:)];
    [self.topViewController.view addGestureRecognizer:self.panRecognizer];
}

-(void)topVCPanned:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x >= 0) {
            self.topViewController.view.center = CGPointMake(self.view.center.x + translation.x, self.view.center.y);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kBurgerOpenScreenDevider) {
            [UIView animateWithDuration:kTimeToSlideMenu animations:^{
                self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
            } completion:^(BOOL finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(tapToCloseMenu:)];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *newVC = self.viewControllers[indexPath.row];
    if (![newVC isEqual:self.topViewController]) {
        [self changeTopVCTo:newVC];
    }
}

-(void)changeTopVCTo:(UIViewController *)newVC {
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:kTimeToSlideMenu animations:^{
        __strong typeof (self) strongSelf = weakSelf;
        
        self.topViewController.view.frame = CGRectMake(strongSelf.view.frame.size.width, strongSelf.view.frame.origin.y, strongSelf.topViewController.view.frame.size.width, strongSelf.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        __strong typeof (self) strongSelf = weakSelf;
        
        CGRect oldFrame = strongSelf.topViewController.view.frame;
        
        //remove topViewController from parent
        [strongSelf.topViewController willMoveToParentViewController:nil];
        [strongSelf.topViewController.view removeFromSuperview];
        [strongSelf.topViewController removeFromParentViewController];
        
        [strongSelf addChildViewController:newVC];
        newVC.view.frame = oldFrame;
        [strongSelf.view addSubview:newVC.view];
        [newVC didMoveToParentViewController:strongSelf];
        
        strongSelf.topViewController = newVC;
        
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
