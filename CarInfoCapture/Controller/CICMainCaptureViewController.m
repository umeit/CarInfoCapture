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

@interface CICMainCaptureViewController () <CICCarBaseCheckReportDeledate>
@property (weak, nonatomic) IBOutlet UIImageView *firstCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthCheckCompleteImage;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@property (nonatomic) BOOL needsSaveToDB;
@end

@implementation CICMainCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 如果已经有 CarInfoEntity 信息，表示在编辑采集信息，而不是新建的(或上次未保存的)采集信息
    // 所以后续就可以保存到 NSUserDefaults，而不是跟新数据库
    if (self.carInfoEntity) {
        self.needsSaveToDB = YES;
        
        
    }
    else {
        // 检查是否有上次未保存的采集信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        self.carInfoEntity = [userDefaults objectForKey:@"UnsaveCarInfoEntity"];
        self.carInfoEntity = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"UnsaveCarInfoEntity"]];
        // 有未保存的
        if (self.carInfoEntity) {
            
        }
        // 新建的
        else {
            self.carInfoEntity = [[CICCarInfoEntity alloc] init];
            NSLog(@"Create a new Car-Info object.");
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICCarBaseCheckReportViewController *carBaseCheckReportVC = segue.destinationViewController;
    carBaseCheckReportVC.delegate = self;
    carBaseCheckReportVC.carInfoEntity = self.carInfoEntity;
    
    if (self.needsSaveToDB) {
        
    }
    else {
        // 第一导航到其他的视图，表示用户开始采集信息
        // 将 self.carInfoEntity 保存到 userDefaults 暂存起来
        // 用于用户在没有「保存」的情况下退出应用后，下次打开时还能看到上次编辑的信息
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *carInfoEntityData = [userDefaults objectForKey:@"UnsaveCarInfoEntity"];
        if (!carInfoEntityData) {
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.carInfoEntity]
                             forKey:@"UnsaveCarInfoEntity"];
            NSLog(@"Save the new Car-Info to NSUserDefaults.");
        }
//        else {
//            self.carInfoEntity = [NSKeyedUnarchiver unarchiveObjectWithData:carInfoEntityData];
//        }
    }
    
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
    
}

- (IBAction)clearButtonPress:(id)sender
{
    
}

#pragma mark - CICCarBaseCheckReportDeledate

- (void)carInfoDidChange:(CICCarInfoEntity *)carInfoEntity
{
    
}
@end
