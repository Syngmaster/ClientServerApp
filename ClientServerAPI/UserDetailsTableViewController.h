//
//  UserDetailsTableViewController.h
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *resultArray;
@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) NSString *userID;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
