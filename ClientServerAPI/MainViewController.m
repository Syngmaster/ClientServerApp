//
//  ViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "MainViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "FriendViewController.h"
#import "LoginViewController.h"


@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (assign, nonatomic) BOOL firstTimeAppear;
@property (strong, nonatomic) User *user;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    //[self getFriendsFromServer];
    self.firstTimeAppear = YES;

}

- (void)getFriendsFromServer:(User *) user  {
    
    [[ServerManager sharedManager] getFriendsOfUser:user.userID onSuccess:^(NSArray *friends) {
        
        [self.friendsArray addObjectsFromArray:friends];
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        NSLog(@"error = %@, code = %li", [error localizedDescription], statusCode);

    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[ServerManager sharedManager] authorizeUser:^(User *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
            self.user = user;
            NSLog(@"User id - %@", user.userID);
            [self getFriendsFromServer:self.user];

        }];
    }
}

#pragma mark - Action

- (IBAction)addFriendsAction:(UIBarButtonItem *)sender {
    
    //[self getFriendsFromServer];
    
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    

    
    User *user = [self.friendsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    __weak UITableViewCell* weakCell = cell;
    cell.imageView.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.imageURL];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakCell.imageView.image = image;
        [weakCell layoutSubviews];
        weakCell.imageView.layer.cornerRadius = CGRectGetMaxX(weakCell.imageView.bounds)/2;
        weakCell.imageView.clipsToBounds = YES;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@", error.localizedDescription);
        
    }];
    

    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = [self.friendsArray objectAtIndex:indexPath.row];
    FriendViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
    vc.userID = user.userID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
    
}



@end
