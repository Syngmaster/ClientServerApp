//
//  ServerManager.h
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void)getFriendsWithOffset:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray *friends)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getUserInformation:(NSString *) userID
                   onSuccess:(void(^)(NSArray *friends, NSString *cityName)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getUserDetails:(NSString *) userID
        withRequestURL:(NSString *) URLString
             onSuccess:(void(^)(NSArray *friends)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
