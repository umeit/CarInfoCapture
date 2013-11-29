//
//  UIViewController+CICViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "UIViewController+CICViewController.h"
#import "MBProgressHUD.h"

@implementation UIViewController (CICViewController)

- (void)showCustomTextAlert:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showCustomText:(NSString *)text
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.labelText = text;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

- (void)showLoading
{

}

- (void)hideLoading
{
    
}

@end
