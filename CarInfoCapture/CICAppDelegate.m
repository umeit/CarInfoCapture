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

@implementation CICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CICLoginViewController"];

    return YES;
}

@end
