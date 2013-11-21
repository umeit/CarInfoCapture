//
//  CICCarInfoEntity.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SaveStatus : NSInteger {
    Uploaded = 0,
    NoUpload = 1
}SaveStatus;

typedef enum CarImageIndex : NSInteger {
    frontFlankImage    = 0,
    backFlankImage     = 1,
    insideCentralImage = 2,
    frontSeatImage     = 3,
    backSeatImage      = 4
}CarImageIndex;


// 车辆各部位图片的 key
#define kFrontFlankImage    @"frontFlankImage"
#define kBackFlankImage     @"backFlankImage"
#define kInsideCentralImage @"insideCentralImage"
#define kFrontSeatImage     @"frontSeatImage"
#define kBackSeatImage      @"backSeatImage"

@interface CICCarInfoEntity : NSObject <NSCoding>

// 表示：已上传、未上传、
@property (nonatomic) NSInteger status;

// 车辆ID
@property (nonatomic) NSInteger carID;

/* 基本信息 */
@property (strong, nonatomic) NSString *carName;
@property (strong, nonatomic) UIImage *carImage;
@property (nonatomic) NSString *salePrice;
@property (nonatomic) NSString *mileage;
@property (strong, nonatomic) NSString *firstRegTime;
@property (strong, nonatomic) NSString *location;

/* 初步检查信息 */
// 底盘问题
@property (strong, nonatomic) NSArray *underpanIssueList;
@property (strong, nonatomic) NSArray *engineIssueList;
@property (strong, nonatomic) NSArray *paintIssueList;
@property (strong, nonatomic) NSArray *insideIssueList;
@property (strong, nonatomic) NSArray *facadeIssueList;

/* 车辆实拍信息 */
/**
 *  车辆图片的本地路径
 */
//@property (strong, nonatomic) NSMutableDictionary *carImagesLocalPathDictionary;
@property (strong, nonatomic) NSMutableArray *carImagesLocalPathList;
/**
 *  车辆图片的服务器路径
 */
//@property (strong, nonatomic) NSMutableDictionary *carImagesRemotePathDictionary;
@property (strong, nonatomic) NSMutableArray *carImagesRemotePathList;

- (NSInteger)imageCodeWithImageIndex:(NSInteger)index;

@end
