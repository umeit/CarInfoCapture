//
//  CICMainCaptureViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICMainCaptureViewController.h"
#import "CICCarBaseCheckReportViewController.h"
#import "CICCarInfoEntity.h"

#define NeedSaveToNSUserDefaults self.carInfoSaveStatus == FromNSUserDefaults || self.carInfoSaveStatus == NewCarInfo
#define NeedSaveToDB             self.carInfoSaveStatus == FromDB

typedef enum CarInfoSaveStatus : NSInteger {
    FromDB,
    FromNSUserDefaults,
    NewCarInfo
}CarInfoSaveStatus;

@interface CICMainCaptureViewController () <CICCarBaseCheckReportDeledate>
@property (weak, nonatomic) IBOutlet UIImageView *firstCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthCheckCompleteImage;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@property (nonatomic) CarInfoSaveStatus carInfoSaveStatus;
@end

@implementation CICMainCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 如果已经有 CarInfoEntity 信息，表示在编辑采集信息，而不是新建的(或上次未保存的)采集信息
    // 所以后续就可以保存到 NSUserDefaults，而不是跟新数据库
    if (self.carInfoEntity) {
        self.carInfoSaveStatus = FromDB;
        
        
    }
    else {
        // 检查是否有上次未保存的采集信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.carInfoEntity = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"UnsaveCarInfoEntity"]];
        
        // 上次未保存的
        if (self.carInfoEntity) {
            self.carInfoSaveStatus = FromNSUserDefaults;
        }
        // 新建的
        else {
            self.carInfoSaveStatus = FromNSUserDefaults;
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
        NSData *carInfoEntityData = [userDefaults objectForKey:@"UnsaveCarInfoEntity"];
        if (!carInfoEntityData) {
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.carInfoEntity]
                             forKey:@"UnsaveCarInfoEntity"];
        }
    }
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
    // 判断信息完整性
    
    // 保存到数据库
    
    // 清空暂存在 NSUserDefaults 中的信息
}

- (IBAction)clearButtonPress:(id)sender
{
    // 清空暂存在 NSUserDefaults 中的信息
    
    // 还原界面
}

#pragma mark - CICCarBaseCheckReportDeledate

- (void)carInfoDidChange:(CICCarInfoEntity *)carInfoEntity
{
    if (NeedSaveToDB) {
        
    }
    else if (NeedSaveToNSUserDefaults) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.carInfoEntity]
                         forKey:@"UnsaveCarInfoEntity"];
    }
}
@end
