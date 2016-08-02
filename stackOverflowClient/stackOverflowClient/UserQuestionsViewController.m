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

@interface UserQuestionsViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchedUsers;

@end

@implementation UserQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (token) {
        [StackOverflowService questionsForSearchTerm:@"" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            
            self.searchedUsers = results;
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@end
