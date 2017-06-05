//
//  ServerManager.h
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void) authorizeUser:(void(^)(User* user)) completion;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getFriendsWithOffset:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray *friends)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getUserInformation:(NSString *) userID
                   onSuccess:(void(^)(NSArray *friends, NSString *cityName, BOOL isHidden)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getUserDetails:(NSString *) userID
        withRequestURL:(NSString *) URLString
             onSuccess:(void(^)(NSArray *details)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getUserWall:(NSString *) userID
             onSuccess:(void(^)(NSArray *friends)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
