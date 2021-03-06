//
//  CICCarInfoHTTPLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CICCarInfoEntity;

typedef void(^CarInfoHistoryListBlock)(id responseObject, NSError *error);

typedef void(^CICCarInfoHTTPLogicDownloadImageBlock)(UIImage *image);

@interface CICCarInfoHTTPLogic : NSObject

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block;

+ (void)downloadImageWithPath:(NSString *)path withBlock:(CICCarInfoHTTPLogicDownloadImageBlock)block;

- (NSError *)uploadCarInfo:(CICCarInfoEntity *)carInfo;

- (NSString *)uploadImageWithLocalPath:(NSString *)filePathStr;

- (void)cancelAllUploadTask;
@end
