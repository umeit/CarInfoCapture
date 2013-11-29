//
//  CICMainCaptureViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICMainCaptureViewController.h"
#import "CICCarBaseCheckReportViewController.h"
#import "CICCarInfoService.h"
#import "CICCarInfoEntity.h"
#import "UIViewController+CICViewController.h"

#define NeedSaveToNSUserDefaults self.carInfoSaveStatus == FromNSUserDefaults || self.carInfoSaveStatus == NewCarInfo
#define NeedUpdateToDB             self.carInfoSaveStatus == FromDB

typedef enum CarInfoSaveStatus : NSInteger {
    FromDB,
    FromNSUserDefaults,
    NewCarInfo
}CarInfoSaveStatus;

@interface CICMainCaptureViewController () <CICCarInfoDidChangeDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *firstCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthCheckCompleteImage;

@property (nonatomic) CarInfoSaveStatus carInfoSaveStatus;

@property (strong, nonatomic) CICCarInfoService *carInfoService;
@end

@implementation CICMainCaptureViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.carInfoService = [[CICCarInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 如果已经有 CarInfoEntity 信息，表示在编辑/修改采集信息，而不是新建的(或上次未保存的)采集信息
    // 所以后续就可以保存到 NSUserDefaults，而不是跟新数据库
    if (self.carInfoEntity) {
        self.carInfoSaveStatus = FromDB;
        self.navigationItem.hidesBackButton = YES;

    }
    else {
        // 检查是否有上次未保存的采集信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.carInfoEntity = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"UnsaveCarInfoEntity"]];
        
        // 上次未保存的
        if (self.carInfoEntity) {
            self.carInfoSaveStatus = FromNSUserDefaults;
            
            if ([self checkCarBaseInfo:self.carInfoEntity]) {
                self.firstCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
            } else {
                self.firstCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
            }
            
            
            if ([self checkCarBaseCheckInfo:self.carInfoEntity]) {
                self.secondCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
            } else {
                self.secondCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
            }
            
            
            if ([self checkCarImageInfo:self.carInfoEntity]) {
                self.thirdCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
            } else {
                self.thirdCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
            }
            
            
            if ([self checkCarMasterInfo:self.carInfoEntity]) {
                self.fourthCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
            } else {
                self.fourthCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
            }
        }
        // 新建的
        else {
            self.carInfoSaveStatus = NewCarInfo;
            self.carInfoEntity = [[CICCarInfoEntity alloc] init];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    
    if ([destinationViewController respondsToSelector:@selector(setDelegate:)]) {
        [destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
    
    if ([destinationViewController respondsToSelector:@selector(setCarInfoEntity:)]) {
        [destinationViewController performSelector:@selector(setCarInfoEntity:) withObject:self.carInfoEntity];
    }
    
    if (self.carInfoSaveStatus == FromDB) {
        
    }
    else if (self.carInfoSaveStatus == FromNSUserDefaults) {
        
    }
    else if (self.carInfoSaveStatus == NewCarInfo) {
        // 第一导航到其他的视图，表示用户开始采集信息
        // 将 self.carInfoEntity 保存到 userDefaults 暂存起来
        // 用于用户在没有「保存」的情况下退出应用后，下次打开时还能看到上次编辑的信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSData *carInfoEntityData = [userDefaults objectForKey:@"UnsaveCarInfoEntity"];
//        if (!carInfoEntityData) {
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.carInfoEntity]
                             forKey:@"UnsaveCarInfoEntity"];
//        }
    }
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
    // 判断信息完整性
    if ([self checkDataIntegrity:self.carInfoEntity]) {
//        [self formateDataForUpload:self.carInfoEntity];
        
        if (self.carInfoSaveStatus == FromDB) {
            // 更新到数据库
            [self.carInfoService updateCarInfo:self.carInfoEntity];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.carInfoSaveStatus == NewCarInfo || self.carInfoSaveStatus == FromNSUserDefaults) {
            // 保存到数据库
            self.carInfoEntity.status = NoUpload;
            [self.carInfoService saveCarInfo:self.carInfoEntity];
            // 清空界面
            [self clearCurrentCapture];
        }
    }
    else {
        [self showCustomTextAlert:@"采集信息不完整，请补充必要信息"];
    }
}

- (IBAction)clearButtonPress:(id)sender
{
    [self clearCurrentCapture];
}

#pragma mark - CICCarInfoDidChangeDelegate

- (void)carInfoDidChange:(CICCarInfoEntity *)carInfoEntity
{
    // 更新 UI
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath.row == 0) {
        if ([self checkCarBaseInfo:carInfoEntity]) {
            self.firstCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
        } else {
            self.firstCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
        }
    }
    else if (selectedIndexPath.row == 1) {
        if ([self checkCarBaseCheckInfo:carInfoEntity]) {
            self.secondCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
        } else {
            self.secondCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
        }
    }
    else if (selectedIndexPath.row == 2) {
        if ([self checkCarImageInfo:carInfoEntity]) {
            self.thirdCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
        } else {
            self.thirdCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
        }
    }
    else if (selectedIndexPath.row == 3) {
        if ([self checkCarMasterInfo:carInfoEntity]) {
            self.fourthCheckCompleteImage.image = [UIImage imageNamed:@"cpture_finish"];
        } else {
            self.fourthCheckCompleteImage.image = [UIImage imageNamed:@"cpture_fail"];
        }
    }
    
    if (NeedUpdateToDB) {
        // 更新到数据库
        // 此处暂时不保存到数据库，因为对于修改的采集信息，必须要点击「保存修改」后再更新数据库
    }
    else if (NeedSaveToNSUserDefaults) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.carInfoEntity]
                         forKey:@"UnsaveCarInfoEntity"];
    }
}

#pragma mark - Private

- (void)clearCurrentCapture
{
    // 清空暂存在 NSUserDefaults 中的信息
    
    // 还原界面
}

- (BOOL)checkDataIntegrity:(CICCarInfoEntity *)carInfo
{
    if ([self checkCarBaseInfo:carInfo] && [self checkCarBaseCheckInfo:carInfo]
        && [self checkCarImageInfo:carInfo] && [self checkCarMasterInfo:carInfo]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)checkCarBaseInfo:(CICCarInfoEntity *)carInfo
{
    if ((carInfo.modelID != 0)
        && carInfo.carName && [carInfo.carName length] > 0
        && carInfo.location && [carInfo.location length] > 0
        && carInfo.firstRegTime && [carInfo.firstRegTime length] > 0
        && carInfo.insuranceExpire && [carInfo.insuranceExpire length] > 0
        && carInfo.yearExamineExpire && [carInfo.yearExamineExpire length] > 0
        && carInfo.carSource && [carInfo.carSource length] > 0
        && carInfo.dealTime && [carInfo.dealTime length] > 0
        && carInfo.mileage && [carInfo.mileage length] > 0
        && carInfo.salePrice && [carInfo.salePrice length] > 0) {
        
        return YES;
    }
    return NO;
}

- (BOOL)checkCarBaseCheckInfo:(CICCarInfoEntity *)carInfo
{
    if (carInfo.facadeIssueList && [carInfo.facadeIssueList count] > 0
        && carInfo.insideIssueList && [carInfo.insideIssueList count] > 0
        && carInfo.engineIssueList && [carInfo.engineIssueList count] > 0
        && carInfo.paintIssueList && [carInfo.paintIssueList count] > 0
        && carInfo.underpanIssueList && [carInfo.underpanIssueList count] > 0) {
        
        return YES;
    }
    return NO;
}

- (BOOL)checkCarImageInfo:(CICCarInfoEntity *)carInfo
{
    for (NSDictionary *dic in carInfo.carImagesLocalPathList) {
        if ([dic[@"k"] integerValue] == 0 || [dic[@"v"] length] < 1) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkCarMasterInfo:(CICCarInfoEntity *)carInfo
{
    if (carInfo.masterName && [carInfo.masterName length] > 0
        &&carInfo.masterTel && [carInfo.masterTel length] > 0) {
        return YES;
    }
    return NO;
}
@end
