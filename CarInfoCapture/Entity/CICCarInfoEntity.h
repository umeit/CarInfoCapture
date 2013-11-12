//
//  CICCarInfoEntity.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CICCarInfoEntity : NSObject

@property (strong, nonatomic) NSString *carName;

@property (strong, nonatomic) UIImage *carImage;

@property (nonatomic) double salePrice;

@property (nonatomic) NSUInteger mileage;

@property (strong, nonatomic) NSString *firstRegTime;

@property (nonatomic) NSInteger status;

@end
