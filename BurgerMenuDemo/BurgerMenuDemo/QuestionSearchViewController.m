//
//  QuestionSearchViewController.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/1/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverFlowService.h"
#import "Question.h"


@interface QuestionSearchViewController ()<UITableViewDataSource, UISearchBarDelegate>

//IB tableView here
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchedQuestions;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token) {
        [StackOverFlowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error) {
            //
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedQuestions = results;
            
            [self.tableView reloadData];
            
        }];

    }
  

}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    Question *currentQuestion = self.searchedQuestions[indexPath.row];
    
    cell.textLabel.text = currentQuestion.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchedQuestions.count;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(token){
        [StackOverFlowService questionsForSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
            //
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedQuestions = results;
            
            [self.tableView reloadData];
            
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
