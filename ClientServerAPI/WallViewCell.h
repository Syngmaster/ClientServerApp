//
//  WallViewCell.h
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

@property (weak, nonatomic) IBOutlet UILabel *postBodyText;
@property (weak, nonatomic) IBOutlet UIImageView *postBodyImage;



+ (CGFloat)heightForText:(NSString *) string;


@end
