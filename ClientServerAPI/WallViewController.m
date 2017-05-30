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
#import "UIImageView+AFNetworking.h"


@interface WallViewController ()

@property (strong, nonatomic) NSArray *resultArray;
@property (strong, nonatomic) NSArray *userData;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;


@end

@implementation WallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultArray = [NSArray array];
    [self getUserWall:self.userID];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];    
}


- (void)getUserWall: (NSString *) userID {
    
    [[ServerManager sharedManager] getUserWall:userID
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Wall *wall = [self.resultArray objectAtIndex:indexPath.row];
    cell.userName.text = wall.postOwnerName;
    //cell.userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:wall.postOwnerImgURL]];
    cell.postDate.text = [NSString stringWithFormat:@"%@", wall.postDate];
    cell.likeLabel.text = [NSString stringWithFormat:@"Like %@", wall.likes ? wall.likes : @""];
    cell.postLabel.text = [NSString stringWithFormat:@"Share %@", wall.reposts ? wall.reposts : @""];
    cell.viewLabel.text = [NSString stringWithFormat:@"View %@", wall.views ? wall.views : @""];

    
    __weak WallViewCell* weakCell = cell;
    cell.userImage.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:wall.postOwnerImgURL];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakCell.userImage.image = image;
        [weakCell layoutSubviews];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@", error.localizedDescription);
        
    }];

    
    
    return cell;
}

#pragma mark - UITableViewDelegate


/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200.f;
    
}*/


@end
