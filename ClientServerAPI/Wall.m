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
        [formatter setDateFormat:@"dd MMM 'at' hh:mm"];
        
        self.ownerID = [responseObject objectForKey:@"from_id"];

        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [formatter stringFromDate:dateTime];
        self.postDate = date;
        
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
