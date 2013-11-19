//
//  CICCarInfoHTTPLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CICCarInfoHTTPLogicUploadCarInfoDalegate <NSObject>

- (void)carInfoUploadDidFailAtIndex:(NSInteger)index;

- (void)carInfoDidUploadAtIndex:(NSInteger)index;

- (void)carInfoDidUploadForAll;

@end

@class CICCarInfoEntity;

typedef void(^CICCarInfoHTTPLogicUploadImageBLock)(NSString *urlStr, NSError *error);
typedef void(^CarInfoHistoryListBlock)(NSArray *list, NSError *error);
typedef void(^UploadCarInfoListBlock)(NSError *error);

@interface CICCarInfoHTTPLogic : NSObject

@property (weak, nonatomic) id<CICCarInfoHTTPLogicUploadCarInfoDalegate> delegate;

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block;

- (void)uploadCarInfo:(CICCarInfoEntity *)carInfo;

- (void)uploadImage:(NSString *)filePathStr withBlock:(CICCarInfoHTTPLogicUploadImageBLock)block;

@end