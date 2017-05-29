//
//  Wall.m
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "Wall.h"

@implementation Wall

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        
        self.ownerID = [responseObject objectForKey:@"owner_id"];
        self.postDate = [responseObject objectForKey:@"date"];
        self.ownerPostText = [responseObject objectForKey:@"text"];
        NSArray *attachmentArray = [responseObject objectForKey:@"attachments"];
        NSDictionary *dict = [attachmentArray firstObject];
        NSDictionary *photoDict = [dict objectForKey:@"photo"];
        NSString *urlString = [photoDict objectForKey:@"photo_130"];
        if (urlString) {
            self.attachmentImgURL = [NSURL URLWithString:urlString];
        }
        
        NSArray *likesArray = [responseObject objectForKey:@"likes"];
        self.likes = [likesArray valueForKey:@"count"];
        
        NSArray *viewsArray = [responseObject objectForKey:@"views"];
        self.views = [viewsArray valueForKey:@"count"];
        
        NSArray *repostsArray = [responseObject objectForKey:@"reposts"];
        self.reposts = [repostsArray valueForKey:@"count"];

        
    }
    return self;
}

@end
