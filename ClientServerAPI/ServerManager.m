//
//  ServerManager.m
//  ClientServerAPI
//
//  Created by Syngmaster on 28/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"
#import "Subscription.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        
    }
    return self;
}

- (void)getFriendsWithOffset:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray *friends)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
    @"2349419",     @"user_id",
    @"name",        @"order",
    @"photo_50",    @"fields",
    @"nom",         @"name_case",
    @(count),       @"count",
    @(offset),      @"offset", nil];
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dictsArray = [responseObject objectForKey:@"response"];

        NSMutableArray* objectsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictsArray) {
            User *user = [[User alloc] initWithServerResponse:dict];
            [objectsArray addObject:user];
        }
        
        if (success) {
            success(objectsArray);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task;
            failure(error, httpResponse.statusCode);
        }
    }];
}

- (void)getUserInformation:(NSString *) userID
                 onSuccess:(void(^)(NSArray *friends, NSString *cityName)) success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            userID,             @"user_ids",
                            @"name",            @"order",
                @"city, country, photo_100",    @"fields",
                            @"nom",             @"name_case", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __block NSArray *dictsArray = [responseObject objectForKey:@"response"];
        NSDictionary *dict = [dictsArray firstObject];
        NSString *cityID = [dict valueForKey:@"city"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:cityID, @"city_ids", nil];
        
        __block NSString *cityName = @"";

        [self.sessionManager GET:@"database.getCitiesById" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = [responseObject objectForKey:@"response"];
            NSDictionary *dict = [array firstObject];
            
            NSString *str = [dict valueForKeyPath:@"name"];
            
            if (cityName) {
                cityName = [NSString stringWithFormat:@"%@", str];
            } else {
                cityName = @"";
            }
            
            if (success) {
                success (dictsArray, cityName);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        if (success) {
            success(dictsArray, cityName);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task;
            failure(error, httpResponse.statusCode);
        }
    }];
}

- (void)getUserDetails:(NSString *) userID
        withRequestURL:(NSString *) URLString
             onSuccess:(void(^)(NSArray *friends)) success
             onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure; {
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            userID,             @"user_id",
                            @"photo_100",       @"fields",
                            @"nom",             @"name_case",
                            @"1",               @"extended", nil];
    
    [self.sessionManager GET:URLString
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                         if ([URLString isEqualToString:@"users.getSubscriptions"]) {
                             
                             NSArray *dictsArray = [responseObject objectForKey:@"response"];
                             NSMutableArray* objectsArray = [NSMutableArray array];
                             for (NSDictionary *dict in dictsArray) {
                                 Subscription *subsc = [[Subscription alloc] initWithServerResponse:dict];
                                 [objectsArray addObject:subsc];

                             }
                             if (success) {
                                 success(objectsArray);
                             }

                         } else {
                             
                             
                         }
                         
                         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
