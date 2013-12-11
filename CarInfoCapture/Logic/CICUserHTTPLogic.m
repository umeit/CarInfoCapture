//
//  CICUserHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-12-6.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUserHTTPLogic.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CICUserHTTPLogic
+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(LoginBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    [httpManager POST:@"http://capture.yicheyi.com/login" parameters:@{@"username": userID, @"password": password}
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  block(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  block(nil, error);
              }];
}
@end
