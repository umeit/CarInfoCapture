//
//  NSDictionary+CICDictionary.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSDictionary+CICDictionary.h"

@implementation NSDictionary (CICDictionary)

- (NSString *)jsonStringWithArrayFormat
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:@{key: obj}];
    }];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"jsonStr error: %@", error.description);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
