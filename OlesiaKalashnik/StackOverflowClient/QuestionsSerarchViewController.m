//
//  QuestionsSerarchViewController.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "QuestionsSerarchViewController.h"
#import "StackOverflowService.h"
#import "WebOAuthViewController.h"
#import "Question.h"

@interface QuestionsSerarchViewController () <UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *searchedQuestions;
@end

@implementation QuestionsSerarchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.searchTextField.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    WebOAuthViewController *webVC = [[WebOAuthViewController alloc]init];
    NSString *token = [webVC getToken];
    
    if (token) {
        [self retreiveQuestions];
    }
}

-(void)retreiveQuestions {
    if (!([self.searchTextField.text isEqualToString:@""])) {
        NSString *searchTerm = [self convertSearchTextToURLFormat:self.searchTextField.text];
        [StackOverflowService questionsForSearchTerm:[NSString stringWithFormat:@"%@", searchTerm] completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedQuestions = results;
            [self.tableView reloadData];
        }];
    }
}

-(NSString *)convertSearchTextToURLFormat:(NSString *)searchText {
    NSString *acc = @"";
    NSArray *words = [self getWordsFrom:searchText];
    for (NSString *word in words) {
        acc = [[acc stringByAppendingString:word]stringByAppendingString:@"%20"];
        NSLog(@"%@", acc);
    }
    
    return acc;
}

- (NSArray *)getWordsFrom:(NSString *)string {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRange range = NSMakeRange(0, [string length]);
    if (error == nil) {
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:range];
        NSMutableArray<NSString *> *results = [[NSMutableArray alloc]initWithCapacity:[string length]];
        for (NSTextCheckingResult *match in matches) {
            NSRange range = [match range];
            [results addObject:[string substringWithRange:range]];
        }
        return results;
    }
    else {
        NSLog(@"Invalid regex pattern");
        return nil;
    }
}

#pragma - TableView DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedQuestions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    Question *currQuestion = self.searchedQuestions[indexPath.row];
    cell.textLabel.text = currQuestion.title;
    return cell;
}

#pragma - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self retreiveQuestions];
    return YES;
}

@end
