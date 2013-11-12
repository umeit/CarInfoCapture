//
//  CICCarInfoHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoHTTPLogic.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CICCarInfoHTTPLogic

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    [httpManager GET:@"path"
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(nil, error);
             }];
}

@end
