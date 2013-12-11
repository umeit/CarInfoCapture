//
//  CICCarInfoService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CICCarInfoHTTPLogic.h"

/** Protocol **/
@protocol CICCarInfoServiceUploadCarInfoDelegate <NSObject>

- (void)carInfoUploadDidFailAtIndex:(NSInteger)index;

- (void)carInfoDidUploadAtIndex:(NSInteger)index;

@end


/** Classes **/
@class CICCarInfoEntity;


/** Blocks **/
typedef void(^CICCarInfoServiceCarInfoListBlock)(NSArray *list, NSError *error);

typedef void(^NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)(NSInteger sum, NSInteger needUpload);

typedef void(^CICCarInfoServiceGeneralErrorBlock)(NSError *error);


/** Interface **/
@interface CICCarInfoService : NSObject

@property (weak, nonatomic) id<CICCarInfoServiceUploadCarInfoDelegate> delegate;

@property (strong, nonatomic) CICCarInfoHTTPLogic *carInfoHTTPLogic;

- (void)carInfoListWithBlock:(CICCarInfoServiceCarInfoListBlock)block;

- (void)noUploadCarInfoListWithBlock:(CICCarInfoServiceCarInfoListBlock)block;

- (void)saveCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)updateCarInfo:(CICCarInfoEntity *)carInfo withBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)sumOfCarInfoAndNeedUploadCarInfoWithBlock:(NumberOfSumCarInfoAndNumberOfNeedUploadCarInfoBlock)block;

//- (void)uploadCarInfoWithBlock:(CICCarInfoServiceGeneralErrorBlock)block;

- (void)uploadCarInfoList:(NSArray *)list;

@end
