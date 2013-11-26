//
//  CICCarInfoEntity.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoEntity.h"

@implementation CICCarInfoEntity

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *placeholderDic = @{@"k": @(0), @"v": @""};
        
        self.carImagesLocalPathList = [[NSMutableArray alloc] initWithArray:@[placeholderDic,
                                                                              placeholderDic,
                                                                              placeholderDic,
                                                                              placeholderDic,
                                                                              placeholderDic]];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        // 基本信息
        self.modelID = [[aDecoder decodeObjectForKey:@"modelID"] integerValue];
        self.carName = [aDecoder decodeObjectForKey:@"carName"];
        self.carImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"carImage"]];
        self.salePrice = [aDecoder decodeObjectForKey:@"salePrice"];
        self.mileage = [aDecoder decodeObjectForKey:@"mileage"];
        self.firstRegTime = [aDecoder decodeObjectForKey:@"firstRegTime"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.insuranceExpire = [aDecoder decodeObjectForKey:@"insuranceExpire"];
        self.yearExamineExpire = [aDecoder decodeObjectForKey:@"yearExamineExpire"];
        self.carSource = [aDecoder decodeObjectForKey:@"carSource"];
        self.dealTime = [aDecoder decodeObjectForKey:@"dealTime"];
        
        // 初步检查信息
        self.underpanIssueList = [aDecoder decodeObjectForKey:@"underpanIssueList"];
        self.carImagesLocalPathList = [aDecoder decodeObjectForKey:@"carImagesLocalPathList"];
        
        // 车主信息
        self.masterName = [aDecoder decodeObjectForKey:@"masterName"];
        self.masterTel = [aDecoder decodeObjectForKey:@"masterTel"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 基本信息
    [aCoder encodeObject:@(self.modelID) forKey:@"modelID"];
    [aCoder encodeObject:self.carName forKey:@"carName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.carImage) forKey:@"carImage"];
    [aCoder encodeObject:self.salePrice forKey:@"salePrice"];
    [aCoder encodeObject:self.mileage forKey:@"mileage"];
    [aCoder encodeObject:self.firstRegTime forKey:@"firstRegTime"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.insuranceExpire forKey:@"insuranceExpire"];
    [aCoder encodeObject:self.yearExamineExpire forKey:@"yearExamineExpire"];
    [aCoder encodeObject:self.carSource forKey:@"carSource"];
    [aCoder encodeObject:self.dealTime forKey:@"dealTime"];
    // 初步检查信息
    [aCoder encodeObject:self.underpanIssueList forKey:@"underpanIssueList"];
    [aCoder encodeObject:self.carImagesLocalPathList forKey:@"carImagesLocalPathList"];
    // 车主信息
    [aCoder encodeObject:self.masterName forKey:@"masterName"];
    [aCoder encodeObject:self.masterTel forKey:@"masterTel"];
}

- (NSInteger)imageCodeWithImageIndex:(NSInteger)index
{
    switch (index) {
        case frontFlankImage:
            return 1001;
            break;
            
        case backFlankImage:
            return 1002;
            break;
            
        case insideCentralImage:
            return 3002;
            break;
            
        case frontSeatImage:
            return 3001;
            break;
            
        case backSeatImage:
            return 3006;
            break;
            
        default:
            break;
    }
    return -1;
}

@end
