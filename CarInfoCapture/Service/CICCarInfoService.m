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
#import "CICCarInfoEntity.h"

@implementation CICCarInfoService

- (void)carInfoListWithBlock:(CarInfoListBlock)block
{
    // 判断是否存在数据库
    if ([CICCarInfoDBLogic isDBExist]) {
        // 如果已存在数据库，则去数据库里去信息
        [CICCarInfoDBLogic carInfoListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                block(list, nil);
            }
            else {
                // 错误处理
            }
        }];
    }
    else {
        // 如果不存在就去服务器上取，然后建立数据库，存入信息
        [CICCarInfoHTTPLogic carInfoHistoryListWithBlock:^(NSArray *list, NSError *error) {
            if (!error) {
                block(list, nil);
                
                [CICCarInfoDBLogic initCarInfoDB];
                
                // 将信息存入数据库，以后都从数据库读取
                [CICCarInfoDBLogic saveCarInfoList:list WithBlock:^(NSError *error) {
                    if (error) {
                        // 错误处理
                    }
                }];
            }
            else {
                block(nil, error);
                
                // 即使访问网络失败，也要建立数据库
                [CICCarInfoDBLogic initCarInfoDB];
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

- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block
{
    
}

- (void)uploadCarInfoWithBlock:(UploadCarInfoBlock)block
{
    // 从数据库中取得未上传的数据
    [CICCarInfoDBLogic noUploadCarInfoListWithBlock:^(NSArray *noUploadCarInfoList, NSError *error) {
        if (!error && noUploadCarInfoList && [noUploadCarInfoList count] > 0) {
            if (!self.carInfoHTTPLogic) {
                self.carInfoHTTPLogic = [[CICCarInfoHTTPLogic alloc] init];
            }
            self.carInfoHTTPLogic.delegate = self.delegate;
            
            // 上传至服务器
            [noUploadCarInfoList enumerateObjectsUsingBlock:^(CICCarInfoEntity *carInfo, NSUInteger idx, BOOL *stop) {
                
                // 1\先上传信息中的车辆图片
                [self uploadCarImageList:carInfo];
                // 2\再上传其他信息
                [self.carInfoHTTPLogic uploadCarInfo:carInfo];
                
            }];
        }
    }];
}

- (void)uploadCarImageList:(CICCarInfoEntity *)carInfo
{
    [carInfo.carImagesLocalPath enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *imagePath, BOOL *stop) {
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        
        [self.carInfoHTTPLogic uploadImage:@"" withBlock:^(NSString *urlStr, NSError *error) {
            
        }];
    }];
}
@end
