//
//  NSDictionary+CICDictionary.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-20.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CICDictionary)

- (NSString *)jsonStringLocalFormat;

- (NSString *)jsonStringRemoteFormat;
@end
