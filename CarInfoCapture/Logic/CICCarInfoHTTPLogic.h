//
//  CICCarInfoHTTPLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CICCarInfoEntity;


typedef void(^CICCarInfoHTTPLogicUploadImageBLock)(NSString *remoteImagePathStr, NSError *error);

typedef void(^CarInfoHistoryListBlock)(id responseObject, NSError *error);

typedef void(^UploadCarInfoListBlock)(NSError *error);

typedef void(^CICCarInfoHTTPLogicDownloadImageBlock)(UIImage *image);


@interface CICCarInfoHTTPLogic : NSObject

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block;

+ (void)downloadImageWithPath:(NSString *)path withBlock:(CICCarInfoHTTPLogicDownloadImageBlock)block;

- (void)uploadCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UploadCarInfoListBlock)block;

- (void)uploadImageWithLocalPath:(NSString *)filePathStr block:(CICCarInfoHTTPLogicUploadImageBLock)block;

- (void)cancelAllUploadTask;
@end
