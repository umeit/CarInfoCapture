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

typedef void(^CICCarInfoServiceUploadImageBlock)(NSMutableArray *remoteImagePathList);

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
        // 未上传的信息列表
        if (!error && noUploadCarInfoList && [noUploadCarInfoList count] > 0) {
            if (!self.carInfoHTTPLogic) {
                self.carInfoHTTPLogic = [[CICCarInfoHTTPLogic alloc] init];
            }
            
            // 将每个采集信息上传至服务器
            [noUploadCarInfoList enumerateObjectsUsingBlock:^(CICCarInfoEntity *carInfo, NSUInteger idx, BOOL *stop) {
                
                // 1\先上传信息中的车辆图片
                [self uploadCarImageList:carInfo withBlock:^(NSMutableArray *remoteImagePathList) {
                    // 上传图片成功
                    if (remoteImagePathList) {
                        carInfo.carImagesLocalPathList = remoteImagePathList;
                        
                        // 2\再上传其他信息
                        [self.carInfoHTTPLogic uploadCarInfo:carInfo withBlock:^(NSError *error) {
                            if (!error) {
                                
                                #warning  3\更新数据库中的信息
                                
                                
                                [self.delegate carInfoDidUploadAtIndex:idx];
                            }
                            else {
                                [self.delegate carInfoUploadDidFailAtIndex:idx];
                            }
                        }];
                    }
                    // 上传图片失败
                    else {
                        [self.delegate carInfoUploadDidFailAtIndex:idx];
                    }
                }];
            }];
        }
    }];
}

// 上传一次采集中的所有有图片，哪怕只有一个上传失败都认为是全部失败，回调返回 nil
- (void)uploadCarImageList:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceUploadImageBlock)block
{
    NSDictionary *placeholderDic = @{@"k": @(-1), @"v": @""};
    NSMutableArray *remoteImagePathList = [[NSMutableArray alloc] initWithArray:@[placeholderDic,
                                                                                  placeholderDic]];
    
    [carInfo.carImagesLocalPathList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj[@"v"] && [obj[@"v"] length] > 0) {
            
            // 上传图片至服务器
            [self.carInfoHTTPLogic uploadImage:obj[@"v"] withBlock:^(NSString *remoteImagePathStr, NSError *error) {
                if (!error) {
                    // 用本地图片同样的 key 保存图片在服务器的路径
                    remoteImagePathList[idx] = @{@"k": obj[@"k"], @"v": remoteImagePathStr};
                    
                    if ([self allOfUploadForList:remoteImagePathList]) {
                        // 所有的图片都上传成功，返回一个字典，包含图片在服务器的地址
                        block(remoteImagePathList);
                    }
                    
                }
                else {
                    // 上传失败
                    block(nil);
                    return;
                }
            }];
            
        }
    }];
}

#pragma mark - Private

- (BOOL)allOfUploadForList:(NSArray *)remoteImagePathList
{
    for (NSDictionary *dic in remoteImagePathList) {
        if ([dic[@"v"]length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
