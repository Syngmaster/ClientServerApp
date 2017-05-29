//
//  Subscription.m
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "Subscription.h"

@implementation Subscription

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        self.subscriptionName = [responseObject objectForKey:@"name"];

        NSString *urlString = [responseObject objectForKey:@"photo_100"];
        if (urlString) {
            self.subscriptionImgURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
