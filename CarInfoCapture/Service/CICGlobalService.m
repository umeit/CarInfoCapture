//
//  CICGlobalService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICGlobalService.h"

@implementation CICGlobalService

+ (BOOL)isFirstOpenThisApp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return ![userDefaults boolForKey:@"used"];
}

+ (void)markUsed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"used"];
}

+ (NSString *)documentPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
    return documentPaths[0];
}

@end
