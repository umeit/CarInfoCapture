//
//  NSString+CICString.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CICString)

- (NSDictionary *)jsonStrToDictionary;

- (NSArray *)jsonStrToArray;

@end
