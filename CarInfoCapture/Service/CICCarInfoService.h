//
//  CICCarInfoService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CarInfoListBlock)(NSArray *list, NSError *error);

@interface CICCarInfoService : NSObject

- (void)carInfoListWithBlock:(CarInfoListBlock)block;

@end
