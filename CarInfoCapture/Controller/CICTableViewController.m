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

@property (strong, nonatomic) NSMutableArray *blockList;

@property (nonatomic) NSInteger alertBlockIndex;

@end

@implementation CICTableViewController

- (void)showCustomTextAlert:(NSString *)text withOKButtonPressed:(void (^)())block
{
    if (!self.blockList) {
        self.blockList = [[NSMutableArray alloc] init];
    }
    
    [self.blockList setObject:block atIndexedSubscript:self.alertBlockIndex];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = self.alertBlockIndex;
    [alert show];
    
    self.alertBlockIndex ++;
}

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
    [self showLodingViewWithText:nil];
}

- (void)showLodingViewWithText:(NSString *)text
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:self.HUD];
    
    self.HUD.labelText = text;
    
    [self.HUD show:YES];
}

- (void)hideLodingView
{
    [self.HUD hide:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        void (^block)(void) = self.blockList[alertView.tag];
        block();
    }
}

@end
