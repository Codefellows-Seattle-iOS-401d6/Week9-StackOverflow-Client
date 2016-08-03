//
//  UserQuestionsViewController.m
//  StackOverflow
//
//  Created by Rick  on 8/1/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"
#import "StackOverFlowService.h"
#import "User.h"


@interface UserQuestionsViewController ()<UITableViewDataSource>

- (IBAction)searchButtonSelected:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userSearchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *searchedUsers;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)userTextEntered:(UITextField *)sender;


@end

@implementation UserQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchButtonSelected:(UIButton *)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    NSString *userSearch = self.userSearchTextField.text;
    self.userSearchTextField.text = @"";
    NSString *token = [WebOAuthViewController accessToken];
    if (token) {
        [StackOverFlowService questionsForSearchTerm:userSearch searchCategory:@"User" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            self.searchedUsers = results;
            [self.tableView reloadData];
            [[self.view viewWithTag:12] stopAnimating];
        }];
    }
}


#pragma mark - Table Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    User *currentUser = self.searchedUsers[indexPath.row];
    cell.textLabel.text = currentUser.userName;
    
    cell.imageView.image = currentUser.profileImage;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedUsers.count;
}

- (IBAction)userTextEntered:(UITextField *)sender {
    [self searchButtonSelected:self.searchButton];
}
@end


