//
//  NSData+CICData.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSData+CICData.h"

@implementation NSData (CICData)

- (NSArray *)arrayWithJSONData
{
    NSError *error;
    NSArray *array;
    
    array = [NSJSONSerialization JSONObjectWithData:self
                                          options:kNilOptions
                                            error:&error];
    if (error) {
        NSLog(@"Convert JSON data to NSArray error!");
    }
    return array;
}

@end
