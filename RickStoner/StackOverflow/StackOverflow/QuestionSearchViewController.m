//
//  QuestionSearchViewController.m
//  StackOverflow
//
//  Created by Rick  on 8/1/16.
//  Copyright © 2016 Rick . All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverFlowService.h"
#import "WebOAuthViewController.h"
#import "Question.h"

@interface QuestionSearchViewController ()<UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *searchedQuestions;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchButtonSelected:(UIButton *)sender;
- (IBAction)searchEntered:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchButtonSelected:(UIButton *)sender {
    NSString *searchText = self.searchTextField.text;
    self.searchTextField.text = @"";
    NSString *token = [WebOAuthViewController accessToken];
    if (token) {
        [StackOverFlowService questionsForSearchTerm:searchText searchCategory:@"Questions" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            self.searchedQuestions = results;
            [self.tableView reloadData];
        }];
    }
}

- (IBAction)searchEntered:(UITextField *)sender {
    [self searchButtonSelected:self.searchButton];
}


#pragma mark - Table Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    Question *currentQuestion = self.searchedQuestions[indexPath.row];
    cell.textLabel.text = currentQuestion.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedQuestions.count;
}
@end
