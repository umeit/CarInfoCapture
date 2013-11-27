//
//  CICCarInfoService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CICCarInfoHTTPLogic.h"

@protocol CICCarInfoServiceUploadCarInfoDelegate <NSObject>

- (void)carInfoUploadDidFailAtIndex:(NSInteger)index;

- (void)carInfoDidUploadAtIndex:(NSInteger)index;

- (void)carInfoDidUploadForAll;

@end

@class CICCarInfoEntity;

typedef void(^CarInfoListBlock)(NSArray *list, NSError *error);
typedef void(^NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)(NSInteger sum, NSInteger needUpload);
/**
 *  上传采集信息后的回调
 *
 *  @param error 没有错无则为 nil
 */
typedef void(^UploadCarInfoBlock)(NSError *error);

@interface CICCarInfoService : NSObject

@property (weak, nonatomic) id<CICCarInfoServiceUploadCarInfoDelegate> delegate;

@property (strong, nonatomic) CICCarInfoHTTPLogic *carInfoHTTPLogic;

- (void)carInfoListWithBlock:(CarInfoListBlock)block;

- (void)nouploadCarInfoListWithBlock:(CarInfoListBlock)block;

- (void)saveCarInfo:(CICCarInfoEntity *)carInfo;

- (void)updateCarInfo:(CICCarInfoEntity *)carInfo;

- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block;

- (void)uploadCarInfoWithBlock:(UploadCarInfoBlock)block;

@end
