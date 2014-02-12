//
//  CICHTTPClient.h
//  CarInfoCapture
//
//  Created by Liu Feng on 14-2-11.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface CICHTTPClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
