//
//  NSArray+CICArray.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-15.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSArray+CICArray.h"

@implementation NSArray (CICArray)

- (NSString *)formatToOneString;
{
    NSMutableString *str = [[NSMutableString alloc] init];
//    for (NSString *s in self) {
//        [str appendString:[NSString stringWithFormat:@"#%@", s]];
//    }
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [str appendString:[NSString stringWithFormat:@"%@", obj]];
        }
        else {
            [str appendString:[NSString stringWithFormat:@"#%@", obj]];
        }
    }];
    return str;
}

@end
