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
//        self.carImagesLocalPathDictionary = [[NSMutableDictionary alloc] init];
//        self.carImagesRemotePathDictionary = [[NSMutableDictionary alloc] init];
        
        NSDictionary *placeholderDic = @{@"k": @(-1), @"v": @""};
        
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
        self.carName = [aDecoder decodeObjectForKey:@"carName"];
        self.carImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"carImage"]];
        self.salePrice = [aDecoder decodeObjectForKey:@"salePrice"];
        self.mileage = [aDecoder decodeObjectForKey:@"mileage"];
        self.firstRegTime = [aDecoder decodeObjectForKey:@"firstRegTime"];
        self.underpanIssueList = [aDecoder decodeObjectForKey:@"underpanIssueList"];
//        self.carImagesLocalPathDictionary = [aDecoder decodeObjectForKey:@"carImagesLocalPathDictionary"];
        self.carImagesLocalPathList = [aDecoder decodeObjectForKey:@"carImagesLocalPathList"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.carName forKey:@"carName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.carImage) forKey:@"carImage"];
    [aCoder encodeObject:self.salePrice forKey:@"salePrice"];
    [aCoder encodeObject:self.mileage forKey:@"mileage"];
    [aCoder encodeObject:self.firstRegTime forKey:@"firstRegTime"];
    [aCoder encodeObject:self.underpanIssueList forKey:@"underpanIssueList"];
//    [aCoder encodeObject:self.carImagesLocalPathDictionary forKey:@"carImagesLocalPathDictionary"];
    [aCoder encodeObject:self.carImagesLocalPathList forKey:@"carImagesLocalPathList"];
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
