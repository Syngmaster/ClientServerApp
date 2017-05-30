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
    [self.tableView reloadData];

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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultArray count];
}

- (WallViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    WallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WallCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Wall *wall = [self.resultArray objectAtIndex:indexPath.section];
    cell.userName.text = wall.postOwnerName;
    //cell.userImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:wall.postOwnerImgURL]];
    cell.postDate.text = [NSString stringWithFormat:@"%@", wall.postDate];
    cell.likeLabel.text = [NSString stringWithFormat:@"Like %@", wall.likes ? wall.likes : @""];
    cell.postLabel.text = [NSString stringWithFormat:@"Share %@", wall.reposts ? wall.reposts : @""];
    cell.viewLabel.text = [NSString stringWithFormat:@"View %@", wall.views ? wall.views : @""];
    cell.postBodyText.text = wall.ownerPostText;
    cell.postBodyImage.image = nil;
    
    __weak WallViewCell* weakCell = cell;
    [weakCell layoutSubviews];
    [self setImageView:weakCell.userImage withURLRequest:wall.postOwnerImgURL];
    [self setImageView:weakCell.postBodyImage withURLRequest:wall.attachmentImgURL];
    return cell;
}

- (void)setImageView:(UIImageView *) cellImageView withURLRequest:(NSURL *) url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak UIImageView *weakImgView = cellImageView;
    
    [cellImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakImgView.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error.localizedDescription);
    }];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wall *wall = [self.resultArray objectAtIndex:indexPath.section];
    NSLog(@"%@", wall.attachmentImgURL);
    if (!wall.attachmentImgURL) {
        return 150;
    } else {
        return tableView.rowHeight;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}


@end
