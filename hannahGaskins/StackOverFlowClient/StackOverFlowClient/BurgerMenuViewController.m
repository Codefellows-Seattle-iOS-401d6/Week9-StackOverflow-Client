//
//  BurgerMenuViewController.m
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/1/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"

// constants

CGFloat const kBurgerOpenScreenDividr = 3.0;
CGFloat const kBurgerOpenScreenMultiplier = 2.0;
NSTimeInterval const kTimerToSlideMenu = 0.25;
CGFloat const kBurgerButtonWidth = 50.0;
CGFloat const kBurgerButtonHeight = 50.0;


@interface BurgerMenuViewController ()<UITableViewDelegate>

@property(strong, nonatomic)UIViewController *topViewController;
@property(strong, nonatomic)NSArray *viewControllers;
@property(strong, nonatomic)UIPanGestureRecognizer *panRecognizer;
@property(strong, nonatomic)UIButton *burgerButton;
// TODO SWItch from user defaults to keychain
@property(strong, nonatomic)NSString *token;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearchVC"];
    UserQuestionsViewController *userQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserQuestionsVC"];
    self.viewControllers = @[questionSearchVC, userQuestionVC]; // manages views
    UITableViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    
    //assign delegate
    mainMenu.tableView.delegate = self;
    
    [self setupChildController:userQuestionVC];
    [self setupChildController:mainMenu];
    [self setupChildController:questionSearchVC];
    self.topViewController = questionSearchVC;
    [self setupBurgerButton];
    [self setupPanGesture];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.token = [defaults objectForKey:@"token"];
    
    WebOAuthViewController *webVC = [[WebOAuthViewController alloc]init];
    self.token = [webVC accessToken];
    NSLog(@"Token: %@", self.token);
    if (!self.token) {
        [self presentViewController:webVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupBurgerButton
{
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 20.0, kBurgerButtonWidth, kBurgerButtonHeight)];
    [burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    [self.topViewController.view addSubview:burgerButton];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.burgerButton = burgerButton;
}

-(void)burgerButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:kTimerToSlideMenu animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    } completion:^(BOOL finished) {
        // hanldes tap - when menu is close and they tap, should not do anything. but when menu open tap gesture assigned to top VC to clos
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        sender.userInteractionEnabled = NO; // hamburger disables while menu is open
    }];
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)sender
{
    [self.topViewController.view removeGestureRecognizer:sender]; // removes from VC
    [UIView animateWithDuration:kTimerToSlideMenu animations:^{
        //animate view back to full screen. moves center from offset to back on screen
        self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
        // re enable burger button
        self.burgerButton.userInteractionEnabled = YES;
    }];
}

-(void)setupChildController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.frame;
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}


-(void)setupPanGesture
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
    [self.topViewController.view addGestureRecognizer:self.panRecognizer];
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender
{
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    // if state is changing we want the view to move at same rate as finger move
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x >= 0) {
            self.topViewController.view.center = CGPointMake(self.view.center.x + translation.x, self.view.center.y);
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kBurgerOpenScreenDividr) {
            [UIView animateWithDuration:kTimerToSlideMenu animations:^{
                self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
            } completion:^(BOOL finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
                [self.topViewController.view addGestureRecognizer:tap];
                
                self.burgerButton.userInteractionEnabled = NO;
            }];
        } else {
            [UIView animateWithDuration:kTimerToSlideMenu animations:^{
                self.topViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y);
            }];
        }
    }
}

-(void)changeTopViewController:(UIViewController *)newTopViewController
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:kTimerToSlideMenu animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.topViewController.view.frame = CGRectMake(strongSelf.view.frame.size.width, strongSelf.topViewController.view.frame.origin.y, strongSelf.topViewController.view.frame.size.width, strongSelf.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        CGRect oldFrame = strongSelf.topViewController.view.frame;
        
        // boiler plate to take a view controller out of view
        [strongSelf.topViewController willMoveToParentViewController:nil];
        [strongSelf.topViewController.view removeFromSuperview];
        [strongSelf.topViewController removeFromParentViewController];
        
        [strongSelf addChildViewController:newTopViewController];
        newTopViewController.view.frame = oldFrame;
        
        [strongSelf.view addSubview:newTopViewController.view];
        [newTopViewController didMoveToParentViewController:strongSelf];
        strongSelf.topViewController = newTopViewController;
        
        strongSelf.topViewController = newTopViewController;
        [strongSelf.burgerButton removeFromSuperview];
        [strongSelf.topViewController.view addSubview:strongSelf.burgerButton];
        
        [UIView animateWithDuration:kTimerToSlideMenu animations:^{
            strongSelf.topViewController.view.center = strongSelf.view.center;
        } completion:^(BOOL finished) {
            [strongSelf.topViewController.view addGestureRecognizer:strongSelf.panRecognizer];
            strongSelf.burgerButton.userInteractionEnabled = YES;
        }];
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newViewController = self.viewControllers[indexPath.row];
    
    // if the menu is open and they click on same cell that is open, do nothing
    if (![newViewController isEqual:self.topViewController]) {
        [self changeTopViewController:newViewController];
    }
}












@end
