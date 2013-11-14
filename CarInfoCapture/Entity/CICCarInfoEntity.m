//
//  CICCarInfoEntity.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoEntity.h"

@implementation CICCarInfoEntity

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.carName = [aDecoder decodeObjectForKey:@"carName"];
        self.carImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"carImage"]];
        self.salePrice = [aDecoder decodeDoubleForKey:@"salePrice"];
        self.mileage = [aDecoder decodeIntegerForKey:@"mileage"];
        self.firstRegTime = [aDecoder decodeObjectForKey:@"firstRegTime"];
        self.underpanIssueList = [aDecoder decodeObjectForKey:@"underpanIssueList"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.carName forKey:@"carName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.carImage) forKey:@"carImage"];
    [aCoder encodeDouble:self.salePrice forKey:@"salePrice"];
    [aCoder encodeInteger:self.mileage forKey:@"mileage"];
    [aCoder encodeObject:self.firstRegTime forKey:@"firstRegTime"];
    [aCoder encodeObject:self.underpanIssueList forKey:@"underpanIssueList"];
}

@end
