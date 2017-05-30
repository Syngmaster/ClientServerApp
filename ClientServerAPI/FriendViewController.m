//
//  FriendViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "FriendViewController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"

#import "UserDetailsTableViewController.h"
#import "WallViewController.h"


@interface FriendViewController ()

@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *cityName;

@property (assign, nonatomic) BOOL wallIsHidden;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDict = [NSDictionary dictionary];
    [self getUserInfo];
    
}

- (void)getUserInfo {
    
    [[ServerManager sharedManager]
     getUserInformation:self.userID
     onSuccess:^(NSArray *friends, NSString *cityName, BOOL isHidden) {
         
         self.wallIsHidden = isHidden;
         self.userDict = [friends firstObject];
         self.firstName = [self.userDict valueForKey:@"first_name"];
         self.lastName = [self.userDict valueForKey:@"last_name"];
         
         if (![cityName isEqualToString:@"(null)"]) {
             self.cityName = cityName;
         } else {
             self.cityName = @"No city specified";
         }

         dispatch_async(dispatch_get_main_queue(), ^{

             self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
             [self.tableView reloadData];
             
         });
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %li", [error localizedDescription], statusCode);
         
     }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case 0:
            
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userDict valueForKey:@"photo_100"]]]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"City - %@", self.cityName];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.textLabel.text = @"Subscriptions";
            break;
        case 3:
            cell.textLabel.text = @"Followers";
            break;
        case 4:
            cell.textLabel.text = @"Wall";
            break;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return NO;
    } else {
        return YES;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        
        UserDetailsTableViewController *vc = [[UserDetailsTableViewController alloc] init];
        vc.URLString = @"users.getSubscriptions";
        vc.userID = self.userID;
        vc.navigationItem.title = @"Subscriptions";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.row == 3) {
        
        UserDetailsTableViewController *vc = [[UserDetailsTableViewController alloc] init];
        vc.URLString = @"users.getFollowers";
        vc.userID = self.userID;
        vc.navigationItem.title = @"Followers";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.row == 4) {
        
        if (self.wallIsHidden) {
            
            UIAlertController * contr = [UIAlertController alertControllerWithTitle:@"Access denied" message:@"User hid his wall from accessing from outside" preferredStyle:UIAlertControllerStyleAlert];
                        
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [contr addAction:cancel];
            
            [self presentViewController:contr animated:YES completion:nil];
            
        } else {
            
            WallViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WallViewController"];
            vc.userID = self.userID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
