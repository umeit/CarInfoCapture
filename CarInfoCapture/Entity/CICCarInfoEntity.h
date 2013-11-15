//
//  CICCarInfoEntity.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CICCarInfoEntity : NSObject <NSCoding>

// 表示：已上传、未上传、
@property (nonatomic) NSInteger status;

/* 基本信息 */
@property (strong, nonatomic) NSString *carName;

@property (strong, nonatomic) UIImage *carImage;

@property (nonatomic) NSString *salePrice;

@property (nonatomic) NSString *mileage;

@property (strong, nonatomic) NSString *firstRegTime;

/* 初步检查信息 */
// 底盘问题
@property (strong, nonatomic) NSArray *underpanIssueList;
@property (strong, nonatomic) NSArray *engineIssueList;
@property (strong, nonatomic) NSArray *paintIssueList;
@property (strong, nonatomic) NSArray *insideIssueList;
@property (strong, nonatomic) NSArray *facadeIssueList;

@end
