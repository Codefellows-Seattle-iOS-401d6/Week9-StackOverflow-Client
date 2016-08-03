//
//  UsersViewController.m
//  BurgerMenuDemo
//
//  Created by Derek Graham on 8/1/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

#import "UsersViewController.h"
#import "StackOverFlowService.h"
#import "User.h"
#import "UsersTableViewCell.h"



@interface UsersViewController ()<UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) NSArray *searchedUsers;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    NSLog(@"Loaded UsersVC");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(token){
        [StackOverFlowService usersForSearchTerm:@"Derek" completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedUsers = results;
            [self.tableView reloadData];
        }];
    }
//    if (token) {
//        [StackOverFlowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error) {
//            //
//            if (error) {
//                NSLog(@"%@", error.localizedDescription);
//            }
//            self.searchedUsers = results;
//        
//            [self.tableView reloadData];
//            
//        }];
//    }
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsersTableViewCell *cell = (UsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    User *currentUser = self.searchedUsers[indexPath.row];
    
    cell.customTitle.text = currentUser.userName;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: currentUser.profileImageURL]];
    cell.userImage.image = [UIImage imageWithData: imageData];
    
    
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(token){
        [StackOverFlowService usersForSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            self.searchedUsers = results;
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
