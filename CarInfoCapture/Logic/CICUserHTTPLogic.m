//
//  CICUserHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-12-6.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUserHTTPLogic.h"
#import "CICHTTPClient.h"

@implementation CICUserHTTPLogic

+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(LoginBlock)block
{
    [[CICHTTPClient sharedClient] POST:@"login" parameters:@{@"username": userID, @"password": password}
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   block(responseObject, nil);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   block(nil, error);
                               }];
}

@end
