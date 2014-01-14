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

// 获取采集历史记录
- (void)carInfoListWithBlock:(CICCarInfoServiceCarInfoListBlock)block
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
        // 建立数据库
        [CICCarInfoDBLogic initCarInfoDB];
        
        // 如果不存在就去服务器上取，然后建立数据库，存入信息
        [CICCarInfoHTTPLogic carInfoHistoryListWithBlock:^(id responseObject, NSError *error) {
            if (!error) {
                id retObject = [responseObject objectForKey:@"ret"];
                
                if (retObject && [retObject integerValue] == 0) {
                    
                    // 解析数据
                    [self jsonListToCarInfoEntityList:[responseObject objectForKey:@"capture"]
                          withBlock:^(NSMutableArray *carInfoList) {
                              
                              // 将信息存入数据库，以后都从数据库读取
                              [CICCarInfoDBLogic saveCarInfoList:[[carInfoList reverseObjectEnumerator] allObjects]
                              WithBlock:^(NSError *error) {
                                  if (!error) {
                                      // 再从数据库中读出来，就带有 id 信息了
                                      [CICCarInfoDBLogic carInfoListWithBlock:^(NSArray *list, NSError *error) {
                                          if (!error) {
                                              block(list, nil);
                                          }
                                          else {
                                              // 错误处理
                                              NSLog(@"查询数据库失败！");
                                              block(nil, error);
                                          }
                                      }];
                                  }
                                  else {
                                      // 错误处理
                                      NSLog(@"历史采集信息存入数据库失败！");
                                      block(nil, error);
                                  }
                              }];
                    }];
                }
                // 获取出错
                else {
                    block(nil, nil);
                }
            }
            // 访问网络失败
            else {
                block(nil, error);
            }
        }];
    }
}

// 待上传的采集信息列表
- (void)noUploadCarInfoListWithBlock:(CarInfoListBlock)block
{
    [CICCarInfoDBLogic noUploadCarInfoListWithBlock:^(NSArray *list, NSError *error) {
        block(list, nil);
    }];
}

// 保存采集信息
- (void)saveCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    carInfo.addTime = [dateFormatter stringFromDate:date];
    
    [CICCarInfoDBLogic saveCarInfo:carInfo WithBlock:^(NSError *error) {
        block(error);
    }];
}

// 更新修改过的采集信息
- (void)updateCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CICCarInfoDBLogic updateCarInfo:carInfo withBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(error);
            });
        }];
    });
}

// 待上传的采集信息总数
- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block
{
    NSInteger sum = [CICCarInfoDBLogic sumOfCarInfo];
    NSInteger needUploadSum = [CICCarInfoDBLogic sumOfNoUploadCarInfo];
    
    block(sum, needUploadSum);
}

- (void)uploadCarInfoList:(NSArray *)carInfoList
{
    if (!self.carInfoHTTPLogic) {
        self.carInfoHTTPLogic = [[CICCarInfoHTTPLogic alloc] init];
    }
    
    // 将每个采集信息上传至服务器
    [carInfoList enumerateObjectsUsingBlock:^(CICCarInfoEntity *carInfo, NSUInteger idx, BOOL *stop) {
        
        // 监听上传图片的状态
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadImageStatus:)
                                                     name:@"UploadImageStatus"
                                                   object:nil];
        
        // 先上传信息中的车辆图片
        [carInfo.carImagesLocalPaths enumerateKeysAndObjectsUsingBlock:^(id imageKey, id imageLocalPath, BOOL *stop) {
            [self.carInfoHTTPLogic uploadImageWithLocalPath:imageLocalPath block:^(NSString *remoteImagePathStr, NSError *error) {
                if (error) {
                    // 发送上传失败通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImageStatus"
                                                                        object:nil
                                                                      userInfo:@{@"Status": @NO,
                                                                                 @"CarInfoEntity": carInfo,
                                                                                 @"Index": @(idx)}];
                }
                else {
                    carInfo.carImagesRemotePaths[imageKey] = remoteImagePathStr;
                    
                    // 全部上传成功
                    if (carInfo.carImagesRemotePaths.count == carInfo.carImagesLocalPaths.count) {
                        
                        // 发送上传图片成功通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImageStatus"
                                                                            object:nil
                                                                          userInfo:@{@"Status": @YES,
                                                                                     @"CarInfoEntity": carInfo,
                                                                                     @"Index": @(idx)}];
                    }
                }
            }];
        }];
    }];
}

// 下载指定 URL 的图片，保存到本地，返回本地路径
- (void)downloadImageFromRemotePath:(NSString *)remotePath
                          withBlock:(void(^)(UIImage *image, NSString *localPath))block
{
    // 下载服务器端的图片
    [CICCarInfoHTTPLogic downloadImageWithPath:remotePath withBlock:^(UIImage *image) {
        // 保存到本地
        NSString *localPath = [CICGlobalService saveImageToLocal:image];
        block(image, localPath);
    }];
}

#pragma mark - Private

- (void)uploadImageStatus:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSUInteger index = [userInfo[@"Index"] integerValue];
    CICCarInfoEntity *carInfo = userInfo[@"CarInfoEntity"];
    
    // 上传图片成功
    if ([userInfo[@"Status"] boolValue]) {
        
        // 上传其他信息
        [self.carInfoHTTPLogic uploadCarInfo:carInfo withBlock:^(NSError *error) {
            if (!error) {
                
                // 更新数据库中的信息
                carInfo.status = Uploaded;
                [CICCarInfoDBLogic updateCarInfo:carInfo withBlock:^(NSError *error) {}];
                
                // 返回上传信息成功
                [self.delegate carInfoDidUploadAtIndex:index];
            }
            else {
                // 返回上传失败
                [self.delegate carInfoUploadDidFailAtIndex:index];
            }
        }];
    }
    // 上传图片失败
    else {
        // 返回上传失败
        [self.delegate carInfoUploadDidFailAtIndex:index];
    }
}

- (void)jsonListToCarInfoEntityList:(NSArray *)jsonList withBlock:(void(^)(NSMutableArray *carInfoList))block
{
    NSMutableArray *carInfoList = [[NSMutableArray alloc] init];
    
    for (id carInfoDic in jsonList) {
        
        CICCarInfoEntity *carInfoEntity = [self carInfoEntiryFromDic:carInfoDic];
        
        [carInfoList addObject:carInfoEntity];
        
    }
    block(carInfoList);
}

- (CICCarInfoEntity *)carInfoEntiryFromDic:(NSDictionary *)carInfoDic
{
    CICCarInfoEntity *carInfoEntity = [[CICCarInfoEntity alloc] init];
    
    carInfoEntity.status = Uploaded;
    
    carInfoEntity.addTime = [carInfoDic objectForKey:@"addTime"];
    if ([carInfoEntity.addTime isEqualToString:@"null"]) {
        carInfoEntity.addTime = nil;
    }
    carInfoEntity.modelID = [carInfoDic objectForKey:@"modelid"];
    carInfoEntity.carName = [carInfoDic objectForKey:@"carName"];
    carInfoEntity.location = [carInfoDic objectForKey:@"location"];
    carInfoEntity.firstRegTime = [carInfoDic objectForKey:@"firstRegTime"];
    carInfoEntity.insuranceExpire = [carInfoDic objectForKey:@"insuranceExpire"];
    carInfoEntity.yearExamineExpire = [carInfoDic objectForKey:@"yearExamineExpire"];
    carInfoEntity.carSource = [carInfoDic objectForKey:@"carSource"];
    carInfoEntity.dealTime = [NSString stringWithFormat:@"%@", [carInfoDic objectForKey:@"dealTime"]];
    carInfoEntity.mileage = [NSString stringWithFormat:@"%@", [carInfoDic objectForKey:@"mileage"]];
    carInfoEntity.salePrice = [NSString stringWithFormat:@"%@", [carInfoDic objectForKey:@"salePrice"]];
    
    NSString *chassisState = [carInfoDic objectForKey:@"chassisState"];
    carInfoEntity.underpanIssueList = [chassisState componentsSeparatedByString:@"#"];
    NSString *engineState = [carInfoDic objectForKey:@"engineState"];
    carInfoEntity.engineIssueList = [engineState componentsSeparatedByString:@"#"];
    NSString *paintState = [carInfoDic objectForKey:@"paintState"];
    carInfoEntity.paintIssueList = [paintState componentsSeparatedByString:@"#"];
    NSString *insideState = [carInfoDic objectForKey:@"insideState"];
    carInfoEntity.insideIssueList = [insideState componentsSeparatedByString:@"#"];
    NSString *facadeState = [carInfoDic objectForKey:@"facadeState"];
    carInfoEntity.facadeIssueList = [facadeState componentsSeparatedByString:@"#"];
    
    carInfoEntity.masterName = [carInfoDic objectForKey:@"masterName"];
    carInfoEntity.masterTel = [carInfoDic objectForKey:@"masterTel"];
    
    NSArray *array = [carInfoDic objectForKey:@"pic"];
    carInfoEntity.carImagesRemotePaths = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in array) {
        carInfoEntity.carImagesRemotePaths[[NSString stringWithFormat:@"%@", dic[@"k"]]] = dic[@"v"];
    }
    
    return carInfoEntity;
}
@end
