//
//  WallViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "WallViewController.h"
#import "ServerManager.h"
#import "Wall.h"
#import "WallViewCell.h"

@interface WallViewController ()

@property (strong, nonatomic) NSArray *resultArray;

@end

@implementation WallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultArray = [NSArray array];
    
    [[ServerManager sharedManager] getUserWall:self.userID
                                     onSuccess:^(NSArray *friends) {
                                         self.resultArray = friends;
                                         [self.tableView reloadData];
        
                                     } onFailure:^(NSError *error, NSInteger statusCode) {
        
         
       
                                     }];
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArray count];
}


- (WallViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    WallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WallCell"];

    Wall *wall = [self.resultArray objectAtIndex:indexPath.row];
    
    cell.postDate.text = [NSString stringWithFormat:@"%@", wall.postDate];
    cell.likeLabel.text = [NSString stringWithFormat:@"Like %@", wall.likes];
    cell.postLabel.text = [NSString stringWithFormat:@"Share %@", wall.reposts];
    cell.viewLabel.text = [NSString stringWithFormat:@"View %@", wall.views];

    return cell;
}

#pragma mark - UITableViewDelegate


/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200.f;
    
}*/


@end
