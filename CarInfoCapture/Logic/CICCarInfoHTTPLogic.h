//
//  CICCarInfoHTTPLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CarInfoHistoryListBlock)(NSArray *list, NSError *error);

@interface CICCarInfoHTTPLogic : NSObject

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block;

@end
