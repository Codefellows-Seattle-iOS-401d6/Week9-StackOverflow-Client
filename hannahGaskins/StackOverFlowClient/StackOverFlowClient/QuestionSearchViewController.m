//
//  QuestionSearchViewController.m
//  StackOverFlowClient
//
//  Created by hannah gaskins on 8/1/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "Question.h"

@interface QuestionSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *searchedQuestions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token) {
        [StackOverflowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            self.searchedQuestions = results;
            [self.tableView reloadData];
        }];
    }
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma MARK TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    
    Question *currentQuestion = self.searchedQuestions[indexPath.row];
    
    cell.textLabel.text = currentQuestion.title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedQuestions.count;
}




@end
