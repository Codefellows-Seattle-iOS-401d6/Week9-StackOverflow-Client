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

@interface QuestionSearchViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *searchedQuestions;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchButtonSelected:(UIButton *)sender;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [StackOverFlowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error) {
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    NSString *token = [WebOAuthViewController accessToken];
//    
////   <#^(NSArray *results, NSError *error)completion#> if (token) {
////        [StackOverFlowService questionsForSearchTerm:<#(NSString *)#> completionHandler:]
////    }
//}


- (IBAction)searchButtonSelected:(UIButton *)sender {
    NSString *searchText = self.searchTextField.text;
    self.searchTextField.text = @"";
    NSString *token = [WebOAuthViewController accessToken];
    if (token) {
        [StackOverFlowService questionsForSearchTerm:searchText completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            self.searchedQuestions = results;
            [self.tableView reloadData];
        }];
    }
}
@end
