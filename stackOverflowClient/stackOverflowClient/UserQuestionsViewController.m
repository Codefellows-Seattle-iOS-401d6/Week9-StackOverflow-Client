//
//  UserQuestionsViewController.m
//  stackOverflowClient
//
//  Created by Erin Roby on 8/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "User.h"
#import "StackOverflowService.h"
@import UIKit;

@interface UserQuestionsViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *usernameSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchedUsers;

@end

@implementation UserQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.usernameSearch.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)performUserSearch {
    NSString *searchTerm = self.usernameSearch.text;
    [StackOverflowService usersForSearchTerm:searchTerm completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        self.searchedUsers = results;
        [self.tableView reloadData];
    }];

}

#pragma MARK TableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    User *currentUser = self.searchedUsers[indexPath.row];
    cell.textLabel.text = currentUser.username;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedUsers.count;
}

#pragma MARK SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)usernameSearch {
    [self performUserSearch];
}

@end
