//
//  NSString+CICString.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSString+CICString.h"

@implementation NSString (CICString)

- (NSDictionary *)jsonStrToDic
{
    NSError *error;
    NSDictionary *dic;
    
    dic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                          options:kNilOptions
                                            error:&error];
    if (error) {
        NSLog(@"Convert JSON String to NSDictionary error!");
    }
    return dic;
}

@end
