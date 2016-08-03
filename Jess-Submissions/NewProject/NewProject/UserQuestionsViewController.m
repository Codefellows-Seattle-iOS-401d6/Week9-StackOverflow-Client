//
//  UserQuestionsViewController.m
//  NewProject
//
//  Created by Jess Malesh on 8/1/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import "User.h"
#import "JSONParser.h"

@interface UserQuestionsViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (strong, nonatomic)NSArray *searchUser;


@end

@implementation UserQuestionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (token) {
        [StackOverflowService questionsForSearchTerm:@"userInfo" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
        }];
    }
    
    [StackOverflowService questionsForSearchTerm:@"userInfo" completionHandler:^(NSArray *results, NSError *error) {
        
        
    }];
    
}


#pragma mark - DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    User *currentUser = self.searchUser[indexPath.row];
    cell.textLabel.text = currentUser.username;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchUser.count;
}


#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    
    searchText.
}


@end















