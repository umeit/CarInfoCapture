//
//  CICCarInfoDBLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CICCarInfoEntity;

typedef void(^CarInfoListBlock)(NSArray *list, NSError *error);

typedef void(^SaveCarInfoBlock)(NSError *error);
typedef void(^UpdateCarInfoBlock)(NSError *error);

@interface CICCarInfoDBLogic : NSObject

+ (void)initCarInfoDB;

+ (BOOL)isDBExist;

+ (void)carInfoListWithBlock:(CarInfoListBlock)block;

+ (void)saveCarInfo:(CICCarInfoEntity *)carInfo WithBlock:(SaveCarInfoBlock)block;

+ (void)saveCarInfoList:(NSArray *)carInfoList WithBlock:(SaveCarInfoBlock)block;

+ (NSInteger)sumOfCarInfo;

+ (NSInteger)sumOfNoUploadCarInfo;

/**
 *  查找所有没有上传过的数据
 *
 *  @param block 返回没有上传过的数据
 */
+ (void)noUploadCarInfoListWithBlock:(CarInfoListBlock)block;

+ (void)updateCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UpdateCarInfoBlock)block;
@end
