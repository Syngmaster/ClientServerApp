//
//  MainUserTableViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "MainUserTableViewController.h"
#import "ServerManager.h"
#import "Subscription.h"
#import "UIImageView+AFNetworking.h"

@interface MainUserTableViewController ()

@end

@implementation MainUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultArray = [NSArray array];
    
    [[ServerManager sharedManager] getUserDetails:self.userID withRequestURL:self.URLString onSuccess:^(NSArray *friends) {
        self.resultArray = friends;
        [self.tableView reloadData];
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
    
    Subscription *sub = [self.resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = sub.subscriptionName;
    NSLog(@"%@",sub);
    __weak UITableViewCell* weakCell = cell;
    cell.imageView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sub.subscriptionImgURL];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakCell.imageView.image = image;
        [weakCell layoutSubviews];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@", error.localizedDescription);
        
    }];
    
}

@end
