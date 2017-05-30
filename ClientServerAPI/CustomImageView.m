//
//  CustomImageView.m
//  ClientServerAPI
//
//  Created by Syngmaster on 30/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = CGRectGetMaxX(self.bounds)/2;
    
}

@end
