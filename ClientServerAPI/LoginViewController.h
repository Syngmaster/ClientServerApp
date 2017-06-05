//
//  LoginViewController.h
//  ClientServerAPI
//
//  Created by Syngmaster on 04/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Token;

typedef void(^LoginViewToken)(Token *token);

@interface LoginViewController : UIViewController

@property (copy, nonatomic) LoginViewToken completionBlock;

- (instancetype)initWithCompletionBlock:(LoginViewToken) completionBlock;

@end
