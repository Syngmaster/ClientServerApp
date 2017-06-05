//
//  Token.h
//  ClientServerAPI
//
//  Created by Syngmaster on 05/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject

@property (strong, nonatomic) NSString *tokenID;
@property (strong, nonatomic) NSDate *expireDate;
@property (strong, nonatomic) NSString *userID;

@end
