//
//  CICLoginViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICLoginViewController.h"
#import "CICUserService.h"
#import "UIViewController+GViewController.h"

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
    
#ifdef GDEBUG
    self.userIDTextField.text = @"111";
    self.PasswordTextField.text = @"123456";
#endif
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
    
    [self showLodingView];
    
    [self.userService loginWithUserID:userID password:password block:^(CICUserServiceRetCode retCode) {
        
        [self hideLodingView];
        
        switch (retCode) {
            case CICUserServiceLoginSuccess:
            {
                // 保存用户名和密码
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:userID forKey:@"currentLoginedUserID"];
                [userDefaults setObject:password forKey:@"currentLoginedPassword"];
                
                self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CICTabBarController"];
            }
                break;
                
            case CICUserServiceNetworkingError:
                [self showCustomTextAlert:@"网络不给力，请稍后再试"];
                break;
                
            case CICUserServiceServerError:
                [self showCustomTextAlert:@"登录出错，请稍后再试"];
                break;
                
            case CICUserServiceUserIDError:
                [self showCustomTextAlert:@"用户名错误"];
                break;
                
            case CICUserServicePasswordError:
                [self showCustomTextAlert:@"密码错误"];
                break;
                
            default:
                [self showCustomTextAlert:@"登录出错，请稍后再试"];
                break;
        }
    }];
}

- (IBAction)signInButtonPress:(id)sender
{
    [self showCustomTextAlert:@"请联系公司系统管理员"];
}
@end
