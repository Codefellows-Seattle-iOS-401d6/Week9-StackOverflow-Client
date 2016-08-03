//
//  UserTableViewCell.m
//  StackOverflowClient
//
//  Created by Olesia Kalashnik on 8/2/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

#import "UserTableViewCell.h"


@interface UserTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation UserTableViewCell

// Analogue of Swift's "didSet" - override setter
- (void)setUser:(User *)user {
    _user = user;
    self.nameLabel.text = self.user.name;
    [self fetchImage];
}

- (void)fetchImage {
    __weak typeof(self) weakSelf = self;
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    [backgroundQueue addOperationWithBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        NSURL *url = [NSURL URLWithString:strongSelf.user.profileImageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;

        });
    }];
}

@end
