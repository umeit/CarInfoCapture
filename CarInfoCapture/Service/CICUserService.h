//
//  CICUserService.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CICUserServiceLoginBlock)(NSInteger retCode);

@interface CICUserService : NSObject

- (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(CICUserServiceLoginBlock)block;

@end
