//
//  CICCarInfoService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoService.h"
#import "CICCarInfoHTTPLogic.h"
#import "CICCarInfoDBLogic.h"
#import "CICGlobalService.h"

@implementation CICCarInfoService

- (void)carInfoListWithBlock:(CarInfoListBlock)block
{
    // 对于第一次打开 app 的情况
    // 只从服务器拉去用户的采集记录
    if ([CICGlobalService isFirstOpenThisApp]) {
        [CICGlobalService markUsed];
        
        NSLog(@"First open the app, Load Car-Info by networking.");
        
        [CICCarInfoHTTPLogic carInfoHistoryListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                
            }
            else {
                block(list, nil);
            }
        }];
    }
    else {
        NSLog(@"Not first open the app, Load Car-Info by networking.");
        
        [CICCarInfoDBLogic carInfoListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                
            }
            else {
                block(list, nil);
            }
        }];
    }
}


@end
