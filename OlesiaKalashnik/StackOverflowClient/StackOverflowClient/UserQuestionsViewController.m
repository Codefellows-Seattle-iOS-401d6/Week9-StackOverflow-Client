//
//  UserQuestionsViewController.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "UserQuestionsViewController.h"
#import "User.h"
#import "StackOverflowService.h"
#import "UserTableViewCell.h"

@interface UserQuestionsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *searchedUsers;

@end

@implementation UserQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    self.tableView.estimatedRowHeight = 60.0;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self retreiveUsers];
}

-(void)retreiveUsers {
    if (!([self.searchTextField.text isEqualToString:@""])) {
        NSString *searchTerm = [self convertSearchTextToURLFormat:self.searchTextField.text];
        [StackOverflowService usersForSearchTerm:[NSString stringWithFormat:@"%@", searchTerm] completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedUsers = results;
            [self.tableView reloadData];
        }];
    }
}

-(NSString *)convertSearchTextToURLFormat:(NSString *)searchText {
    NSString *acc = @"";
    NSArray *words = [self getWordsFrom:searchText];
    for (NSString *word in words) {
        acc = [[acc stringByAppendingString:word]stringByAppendingString:@"%20"];
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

#pragma - TableView DataSource and Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.user = nil;
    User *currUser = self.searchedUsers[indexPath.row];
    cell.user = currUser;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self retreiveUsers];
    return YES;
}



@end
