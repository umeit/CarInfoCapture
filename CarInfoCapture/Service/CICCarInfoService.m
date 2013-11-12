//
//  CICCarInfoService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoService.h"


@implementation CICCarInfoService

- (NSArray *)carInfoList
{
    // 对于第一次打开 app 的情况，先从服务器拉去用户的采集记录
    if ([self isFirstOpenThisApp]) {
        [self markUsed];
        
        
    }
    else {
        
    }
    
    return nil;
}

- (BOOL)isFirstOpenThisApp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return ![userDefaults boolForKey:@"used"];
}

- (void)markUsed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"used"];
}
@end
