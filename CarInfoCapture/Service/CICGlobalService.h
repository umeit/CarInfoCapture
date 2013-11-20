//
//  CICGlobalService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CICGlobalService : NSObject

+ (BOOL)isFirstOpenThisApp;

+ (void)markUsed;

+ (NSString *)documentPath;

+ (UIImage *)iamgeWithPath:(NSString *)pathStr;

+ (NSString *)saveImageToLocal:(UIImage *)image;

@end
