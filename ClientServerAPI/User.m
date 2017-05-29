//
//  User.m
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
    
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.userID = [responseObject objectForKey:@"user_id"];
        NSString *urlString = [responseObject objectForKey:@"photo_50"];
        if (urlString) {
            
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
