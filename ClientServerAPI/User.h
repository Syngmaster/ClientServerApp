//
//  User.h
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSURL *imageURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
