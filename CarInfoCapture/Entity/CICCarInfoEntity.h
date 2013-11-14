//
//  CICCarInfoEntity.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CICCarInfoEntity : NSObject <NSCoding>

/* 基本信息 */
@property (strong, nonatomic) NSString *carName;

@property (strong, nonatomic) UIImage *carImage;

@property (nonatomic) double salePrice;

@property (nonatomic) NSUInteger mileage;

@property (strong, nonatomic) NSString *firstRegTime;

// 表示：已上传、未上传、
@property (nonatomic) NSInteger status;

/* 初步检查信息 */
// 底盘问题
@property (strong, nonatomic) NSArray *underpanIssueList;

@end
