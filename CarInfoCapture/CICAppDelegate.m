//
//  CICAppDelegate.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-8.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICAppDelegate.h"
#import "CICGlobalService.h"
#import "CICCarInfoDBLogic.h"
#import "CICMyCaptureListViewController.h"

@implementation CICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLoginedUserID = [userDefaults stringForKey:@"currentLoginedUserID"];
    NSString *currentLoginedPassword = [userDefaults stringForKey:@"currentLoginedPassword"];
    
    if (currentLoginedUserID && currentLoginedPassword) {
        UITabBarController *vc = (UITabBarController *)self.window.rootViewController;
        UINavigationController *navVC = vc.viewControllers[0];
        CICMyCaptureListViewController *myCaptureListVC = (CICMyCaptureListViewController *)navVC.topViewController;
        
        myCaptureListVC.userID = currentLoginedUserID;
        myCaptureListVC.password = currentLoginedPassword;
        
    }
    else {
        // 进入登录页面
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CICLoginViewController"];
    }
    
    return YES;
}

@end
