//
//  CICCarInfoEntity.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SaveStatus : NSInteger {
    NoUpload   = 1,
    Uploaded   = 2,
    Uploading  = 3,
    uploadFail = 4
}SaveStatus;

//typedef enum CarImageIndex : NSInteger {
//    frontFlankImageIndex    = 0,
//    backFlankImageIndex     = 1,
//    insideCentralImageIndex = 2,
//    frontSeatImageIndex     = 3,
//    backSeatImageIndex      = 4
//}CarImageIndex;


// 车辆各部位图片的 key
#define kFrontFlankImage    @"1001"
#define kBackFlankImage     @"1002"
#define kInsideCentralImage @"3002"
#define kFrontSeatImage     @"3001"
#define kBackSeatImage      @"3006"

@interface CICCarInfoEntity : NSObject <NSCoding>

// 在数据库的ID
@property (nonatomic) NSInteger dbID;

// 保存到数据库的时间
@property (nonatomic) NSString *addTime;

// 表示：已上传、未上传、
@property (nonatomic) SaveStatus status;

/* 基本信息 */
@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *carName;
@property (strong, nonatomic) UIImage *carImage;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *firstRegTime;
@property (strong, nonatomic) NSString *insuranceExpire;
@property (strong, nonatomic) NSString *yearExamineExpire;
@property (strong, nonatomic) NSString *carSource;
@property (strong, nonatomic) NSString *dealTime;
@property (strong, nonatomic) NSString *mileage;
@property (strong, nonatomic) NSString *salePrice;

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
//@property (strong, nonatomic) NSMutableArray *carImagesLocalPathList;
@property (strong, nonatomic) NSMutableDictionary *carImagesLocalPaths;
/**
 *  车辆图片的服务器路径
 */
//@property (strong, nonatomic) NSMutableArray *carImagesRemotePathList;
@property (strong, nonatomic) NSMutableDictionary *carImagesRemotePaths;

/* 车主信息 */
@property (strong, nonatomic) NSString *masterName;
@property (strong, nonatomic) NSString *masterTel;

//- (NSInteger)imageCodeWithImageIndex:(NSInteger)index;

@end
