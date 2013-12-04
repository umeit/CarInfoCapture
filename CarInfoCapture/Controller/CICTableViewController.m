//
//  CICTableViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-12-4.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICTableViewController.h"
#import "MBProgressHUD.h"

@interface CICTableViewController ()
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation CICTableViewController

- (void)showCustomTextAlert:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showCustomText:(NSString *)text delay:(NSInteger)delay
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = text;
    
	[self.view addSubview:HUD];
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:delay];
}

- (void)showLodingView
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:self.HUD];
    
    [self.HUD show:YES];
}

- (void)hideLodingView
{
    [self.HUD hide:YES];
}

@end
