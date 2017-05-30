//
//  UserDetailsTableViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "UserDetailsTableViewController.h"
#import "ServerManager.h"
#import "Subscription.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface UserDetailsTableViewController ()

@end

@implementation UserDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultArray = [NSArray array];
    [[ServerManager sharedManager] getUserDetails:self.userID withRequestURL:self.URLString onSuccess:^(NSArray *details) {
        self.resultArray = details;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.URLString isEqualToString:@"users.getSubscriptions"]) {
        
        Subscription *sub = [self.resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = sub.subscriptionName;
        [self updateCell:cell withImageFromURL:sub.subscriptionImgURL];
        
    } else {
        
        User *user = [self.resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        [self updateCell:cell withImageFromURL:user.imageURL];
    }

}

- (void)updateCell:(UITableViewCell *) cell withImageFromURL:(NSURL *) url {
    
    __weak UITableViewCell* weakCell = cell;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakCell.imageView.image = image;
        [weakCell layoutSubviews];
        weakCell.imageView.layer.cornerRadius = CGRectGetMaxX(weakCell.imageView.bounds)/2;
        weakCell.imageView.clipsToBounds = YES;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@", error.localizedDescription);
        
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
    
}

@end
