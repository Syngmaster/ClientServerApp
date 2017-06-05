//
//  LoginViewController.m
//  ClientServerAPI
//
//  Created by Syngmaster on 04/06/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "LoginViewController.h"
#import "Token.h"
#import "ServerManager.h"

@interface LoginViewController () <UIWebViewDelegate>

@end

@implementation LoginViewController

- (instancetype)initWithCompletionBlock:(LoginViewToken) completionBlock;
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    self.navigationItem.rightBarButtonItem = cancel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=5912355&"
    "scope=139286&" // + 2 + 4 + 16 + 131072 + 8192
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.11&"
    "response_type=token";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
}

#pragma mark - Actions

- (void)cancelAction:(UIBarButtonItem *) sender {
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"this is - %@", [[request URL] description]);
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        
        Token *token = [[Token alloc] init];
        NSString *query = [[request URL] description];
        NSArray *array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            
            NSArray *values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                if ([values[0] isEqualToString:@"access_token"]) {
                    token.tokenID = values[1];
                } else if ([values[0] isEqualToString:@"expires_in"]) {
                    token.expireDate = [NSDate dateWithTimeIntervalSinceNow:[values[1] doubleValue]];
                } else {
                    token.userID = values[1];
                }
                
            }
        }

        if (self.completionBlock) {
            self.completionBlock(token);
        }
    }
    
    return YES;
    
}

@end
