//
//  UserQuestionsViewController.m
//  StackOverflowClient
//
//  Created by Sung Kim on 8/1/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "WebOAuthViewController.h"
#import "StackOverflowService.h"
#import "User.h"

@interface UserQuestionsViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *searchedUser;

@end

@implementation UserQuestionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSString *token = [WebOAuthViewController accessToken];
//    
//    if (token) {
//        [StackOverflowService usersForSearchTerm:@"" completionHandler:^(NSArray *results, NSError *error) {
//            if (error) {
//                NSLog(@"%@", error.localizedDescription);
//                return;
//            }
//            
//            self.searchedUser = results;
//            [self.tableView reloadData];
//        }];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    User *user = self.searchedUser[indexPath.row];
    
    cell.textLabel.text = user.userName;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedUser.count;
}

#pragma mark - UISearchbarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = self.searchBar.text;
    
    [StackOverflowService usersForSearchTerm:searchText completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        self.searchedUser = results;
        [self.tableView reloadData];
    }];
}

@end
