//
//  CICSettingsViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICSettingsViewController.h"

@interface CICSettingsViewController () <UIActionSheetDelegate>
@end

@implementation CICSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 检查新版本
    }
}

#pragma mark - Action

- (IBAction)logoutButtonPress:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出登录？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定退出"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"currentLoginedUserID"];
        [userDefaults removeObjectForKey:@"currentLoginedPassword"];
        
        self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CICLoginViewController"];
    }
}

@end
