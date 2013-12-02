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

@end

@class CICCarInfoEntity;

typedef void(^CarInfoListBlock)(NSArray *list, NSError *error);
typedef void(^NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)(NSInteger sum, NSInteger needUpload);
/**
 *  通用的错误 block
 *
 *  @param error 没有错无则为 nil
 */
typedef void(^CICCarInfoServiceGeneralErrorBlock)(NSError *error);

@interface CICCarInfoService : NSObject

@property (weak, nonatomic) id<CICCarInfoServiceUploadCarInfoDelegate> delegate;

@property (strong, nonatomic) CICCarInfoHTTPLogic *carInfoHTTPLogic;

- (void)carInfoListWithBlock:(CarInfoListBlock)block;

- (void)noUploadCarInfoListWithBlock:(CarInfoListBlock)block;

- (void)saveCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)updateCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block;

//- (void)uploadCarInfoWithBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)uploadCarInfoList:(NSArray *)list;

@end
