//
//  UserQuestionsViewController.m
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/1/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "StackOverflowService.h"
#import "User.h"
#import "WebOAuthViewController.h"

@interface UserQuestionsViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *userQuestions;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation UserQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"]; //update to keychain
//    
//    if (token)
//    {
//        [StackOverflowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error)
//         {
//             if (error)
//             {
//                 NSLog(@"%@", error.localizedDescription);
//                 return;
//             }
//             self.userQuestions = results;
//             [self.tableView reloadData];
//         }];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    
    User *userQuestion = self.userQuestions[indexPath.row];
    cell.textLabel.text = userQuestion.userName;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userQuestions.count;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = self.searchBar.text;
    
    [StackOverflowService usersForSearchTerm:searchText completionHandler:^(NSArray *results, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        self.userQuestions = results;
        [self.tableView reloadData];
    }];
}


@end
