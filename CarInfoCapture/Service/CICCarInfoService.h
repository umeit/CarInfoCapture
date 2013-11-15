//
//  CICCarInfoService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CICCarInfoEntity;

typedef void(^CarInfoListBlock)(NSArray *list, NSError *error);
typedef void(^NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)(NSInteger sum, NSInteger needUpload);
typedef void(^UploadCarInfoBlock)(NSError *error);

@interface CICCarInfoService : NSObject

- (void)carInfoListWithBlock:(CarInfoListBlock)block;

- (void)saveCarInfo:(CICCarInfoEntity *)carInfo;

- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block;

- (void)uploadCarInfoWithBlock:(UploadCarInfoBlock)block;

@end
