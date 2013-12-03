//
//  CICLoginViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICLoginViewController.h"
#import "CICUserService.h"
#import "UIViewController+CICViewController.h"
#import "MBProgressHUD.h"

@interface CICLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;

@property (strong, nonatomic) CICUserService *userService;
@end

@implementation CICLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userService = [[CICUserService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loginButtonPress:(id)sender
{
    NSString *userID = self.userIDTextField.text;
    NSString *password = self.PasswordTextField.text;
    
    if (!userID || [userID length] == 0) {
        [self showCustomTextAlert:@"请输入用户名"];
        return;
    }
    if (!password || [password length] == 0) {
        [self showCustomTextAlert:@"请输入密码"];
        return;
    }
    
    [self.userIDTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    [HUD show:YES];
    
    [self.userService loginWithUserID:userID password:password block:^(NSInteger retCode) {
        [HUD hide:YES];
        
        if (retCode == 0) {
            self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CICTabBarController"];
        }
        else if (retCode == -1) {
            [self showCustomTextAlert:@"登录失败，请稍后再试"];
        }
    }];
}

- (IBAction)signInButtonPress:(id)sender
{
    
}
@end
