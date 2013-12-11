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
                
                if (retObject) {
                    NSInteger code = [retObject integerValue];
                    // 获取成功
                    if (code == 0) {
                        // 解析数据
                        [self jsonListToCarInfoEntityList:[responseObject objectForKey:@"capture"]
                                                withBlock:^(NSMutableArray *carInfoList) {
                                                    if ([carInfoList count] > 0) {
                                                        // 将信息存入数据库，以后都从数据库读取
                                                        [CICCarInfoDBLogic saveCarInfoList:carInfoList
                                                                                 WithBlock:^(NSError *error) {
                                                                                     if (!error) {
                                                                                         block(carInfoList, nil);
                                                                                     }
                                                                                     else {
                                                                                         // 错误处理
                                                                                         NSLog(@"初始信息存入数据库失败！");
                                                                                         block(nil, error);
                                                                                     }
                                                                                 }];
                                                    }
                                                }];
                    }
                    // 获取出错
                    else {
                        NSLog(@"从服务器获取采集信息失败，返回码: %ld", code);
                        block(nil, nil);
                    }
                }
                // 获取出错
                else {
                    block(nil, nil);
                }
            }
            // 访问网络失败
            else {
                NSLog(@"从服务器获取采集信息失败，返回无法解析的数据: %@", responseObject);
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
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
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
    NSDate *date = [NSDate date];
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate:date];
    //    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    carInfo.addTime = [dateFormatter stringFromDate:date];
    [CICCarInfoDBLogic updateCarInfo:carInfo withBlock:^(NSError *error) {
        block(error);
    }];
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
        
        // 1\先上传信息中的车辆图片
        [self uploadCarImageList:carInfo withBlock:^(NSMutableArray *remoteImagePathList) {
            // 上传图片成功
            if (remoteImagePathList) {
                carInfo.carImagesRemotePathList = remoteImagePathList;
                
                // 2\再上传其他信息
                [self.carInfoHTTPLogic uploadCarInfo:carInfo withBlock:^(NSError *error) {
                    if (!error) {
                        
                        // 3\更新数据库中的信息
                        carInfo.status = Uploaded;
                        [CICCarInfoDBLogic updateCarInfo:carInfo withBlock:^(NSError *error) {
                            [self.delegate carInfoUploadDidFailAtIndex:idx];
                        }];
                        
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

#pragma mark - Private

- (void)jsonListToCarInfoEntityList:(NSArray *)jsonList withBlock:(void(^)(NSMutableArray *carInfoList))block
{
    NSMutableArray *carInfoList = [[NSMutableArray alloc] init];
    
    for (id carInfoDic in jsonList) {
        CICCarInfoEntity *carInfoEntity = [[CICCarInfoEntity alloc] init];
        
        carInfoEntity.status = Uploaded;
        
        carInfoEntity.addTime = [carInfoDic objectForKey:@"addTime"];
        
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
        
        carInfoEntity.carImagesRemotePathList = [NSMutableArray arrayWithArray:[carInfoDic objectForKey:@"pic"]];
        [self downloadImageFromRemotePath:carInfoEntity.carImagesRemotePathList withBlock:^(NSMutableArray *localPathList) {
            carInfoEntity.carImagesLocalPathList = localPathList;
            
            [carInfoList addObject:carInfoEntity];
            
            if ([carInfoList count] == [jsonList count]) {
                block(carInfoList);
            }
        }];
    }
}

- (void)downloadImageFromRemotePath:(NSMutableArray *)carImagesRemotePathList
                          withBlock:(void(^)(NSMutableArray *localPathList))block
{
    NSMutableArray *localPathList = [[NSMutableArray alloc] init];
    
    for (id imagePathDic in carImagesRemotePathList) {
        NSString *remotePath = [imagePathDic objectForKey:@"v"];
        
        // 下载服务器端的图片保存到本地
        [CICCarInfoHTTPLogic downloadImageWithPath:remotePath
                                         withBlock:^(UIImage *image) {
                                             
            NSString *localPath = [CICGlobalService saveImageToLocal:image];
            // 记录保存在本地的地址
            [localPathList addObject:@{@"k": imagePathDic[@"k"], @"v": localPath}];
            
            if ([localPathList count] == [carImagesRemotePathList count]) {
                block(localPathList);
                return;
            }
        }];
    }
}

// 上传一次采集中的所有有图片，哪怕只有一个上传失败都认为是全部失败，回调返回 nil
- (void)uploadCarImageList:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceUploadImageBlock)block
{
    NSDictionary *placeholderDic = @{@"k": @(-1), @"v": @""};
    NSMutableArray *remoteImagePathList = [[NSMutableArray alloc] initWithArray:@[placeholderDic,
                                                                                  placeholderDic,
                                                                                  placeholderDic,
                                                                                  placeholderDic,
                                                                                  placeholderDic]];
    
    [carInfo.carImagesLocalPathList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj[@"v"] && [obj[@"v"] length] > 0) {
            
            // 上传图片至服务器
            [self.carInfoHTTPLogic uploadImage:obj[@"v"] withBlock:^(NSString *remoteImagePathStr, NSError *error) {
                if (!error) {
                    // 用本地图片同样的 key 保存图片在服务器的路径
                    remoteImagePathList[idx] = @{@"k": obj[@"k"], @"v": remoteImagePathStr};
                    
                    if ([self allOfImageUploadForList:remoteImagePathList]) {
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

// 判断是否所有的图片都上传成功
- (BOOL)allOfImageUploadForList:(NSArray *)remoteImagePathList
{
    for (NSDictionary *dic in remoteImagePathList) {
        if ([dic[@"v"]length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
