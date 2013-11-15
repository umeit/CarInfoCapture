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
//    if ([CICGlobalService isFirstOpenThisApp]) {
    
    // 如果已存在数据库，则去数据库里去信息，如果不存在就去服务器上取，然后建立数据库，存入信息
    if (![CICCarInfoDBLogic isDBExist]) {
//        [CICGlobalService markUsed]; // 记录用户已经打开过
        
        [CICCarInfoHTTPLogic carInfoHistoryListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                
            }
            else {
                block(list, nil);
                
                [CICCarInfoDBLogic initCarInfoDB];
                
                // 将信息存入数据库，以后都从数据库读取
                [CICCarInfoDBLogic saveCarInfoList:list WithBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }
    else {
        [CICCarInfoDBLogic carInfoListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                
            }
            else {
                block(list, nil);
            }
        }];
    }
}

- (void)saveCarInfo:(CICCarInfoEntity *)carInfo
{
    [CICCarInfoDBLogic saveCarInfo:carInfo WithBlock:^(NSError *error) {
        if (!error) {
            
        }
        else {
            
        }
    }];
}

@end
