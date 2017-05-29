//
//  Subscription.h
//  ClientServerAPI
//
//  Created by Syngmaster on 29/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscription : NSObject

@property (strong, nonatomic) NSString *subscriptionName;
@property (strong, nonatomic) NSURL *subscriptionImgURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
