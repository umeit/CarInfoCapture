//
//  CICCarBrandService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBrandService.h"
#import "NSFileHandle+readLine.h"
#import "NSString+CICString.h"

@implementation CICCarBrandService

- (NSArray *)carBrandList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarBrandJson" ofType:@"txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    // 资源文件的第一行为品牌信息
    NSString *carBrandStringLine = [[NSString alloc] initWithData:[fileHandle readLineWithDelimiter:@"\n"] encoding:NSUTF8StringEncoding];
    
    NSArray *carBrandList = [carBrandStringLine jsonStrToArray];
    
    return carBrandList;
}

@end
