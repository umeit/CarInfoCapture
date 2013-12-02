//
//  CICUserService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUserService.h"
#import "CICCarInfoHTTPLogic.h"

@implementation CICUserService

- (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(CICUserServiceLoginBlock)block
{
    [CICCarInfoHTTPLogic loginWithUserID:userID password:password block:^(id responseObject, NSError *error) {
        if (!error) {
            NSInteger retCode = [[responseObject objectForKey:@"ret"] integerValue];
            block(retCode);
        }
        else {
            block(-1);
        }
    }];
}

@end
