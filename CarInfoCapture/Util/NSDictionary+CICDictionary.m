//
//  NSDictionary+CICDictionary.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSDictionary+CICDictionary.h"

@implementation NSDictionary (CICDictionary)

- (NSString *)jsonString
{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"jsonStr error: %@", error.description);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
