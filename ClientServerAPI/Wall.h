//
//  Wall.h
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wall : NSObject

@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *postDate;
@property (strong, nonatomic) NSString *ownerPostText;
@property (strong, nonatomic) NSURL *attachmentImgURL;

@property (strong, nonatomic) NSString *likes;
@property (strong, nonatomic) NSString *reposts;
@property (strong, nonatomic) NSString *views;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
