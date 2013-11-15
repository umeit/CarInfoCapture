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

@interface CICCarInfoDBLogic : NSObject

+ (void)initCarInfoDB;

+ (BOOL)isDBExist;

+ (void)carInfoListWithBlock:(CarInfoListBlock)block;

+ (void)saveCarInfo:(CICCarInfoEntity *)carInfo WithBlock:(SaveCarInfoBlock)block;

+ (void)saveCarInfoList:(NSArray *)carInfoList WithBlock:(SaveCarInfoBlock)block;

@end
