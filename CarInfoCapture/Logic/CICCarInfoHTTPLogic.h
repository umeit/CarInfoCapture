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
typedef void(^CarInfoHistoryListBlock)(id list, NSError *error);
typedef void(^UploadCarInfoListBlock)(NSError *error);
typedef void(^LoginBlock)(id responseObject, NSError *error);
typedef void(^CICCarInfoHTTPLogicDownloadImageBlock)(UIImage *image);

@interface CICCarInfoHTTPLogic : NSObject

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block;

+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(LoginBlock)bloc;

+ (void)downloadImageWithPath:(NSString *)path withBlock:(CICCarInfoHTTPLogicDownloadImageBlock)block;

- (void)uploadCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UploadCarInfoListBlock)block;

- (void)uploadImage:(NSString *)filePathStr withBlock:(CICCarInfoHTTPLogicUploadImageBLock)block;


@end
