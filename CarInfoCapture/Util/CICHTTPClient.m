//
//  CICHTTPClient.m
//  CarInfoCapture
//
//  Created by Liu Feng on 14-2-11.
//  Copyright (c) 2014年 Liu Feng. All rights reserved.
//

#import "CICHTTPClient.h"

static NSString *const BaseURLString = @"http://capture.yicheyi.com/";

@implementation CICHTTPClient

+ (instancetype)sharedClient
{
    static CICHTTPClient *client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[CICHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    return client;
}

@end
