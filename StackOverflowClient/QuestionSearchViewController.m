//
//  QuestionSearchViewController.m
//  StackOverflowClient
//
//  Created by Sean Champagne on 8/1/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import "WebOAuthViewController.h"

@interface QuestionSearchViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchedQuestions;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *token = [WebOAuthViewController accessToken]; //update to keychain
    
    if (token)
    {
    [StackOverflowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", error.localizedDescription);
             return;
         }
         self.searchedQuestions = results;
         [self.tableView reloadData];
     }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    
    Question *currentQuestion = self.searchedQuestions[indexPath.row];
    cell.textLabel.text = currentQuestion.title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedQuestions.count;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = self.searchBar.text;
    
    [StackOverflowService questionsForSearchTerm:searchText completionHandler:^(NSArray *results, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        self.searchedQuestions = results;
        [self.tableView reloadData];
    }];
}

@end
