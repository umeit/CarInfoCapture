//
//  CICMainCaptureViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICMainCaptureViewController.h"
#import "CICCarInfoEntity.h"

@interface CICMainCaptureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *firstCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCheckCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthCheckCompleteImage;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;
@end

@implementation CICMainCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 检查是否有上次未保存的采集信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.carInfoEntity = [userDefaults objectForKey:@"UnsaveCarInfoEntity"];
    
    if (self.carInfoEntity) {
        
    }
    else {
        self.carInfoEntity = [[CICCarInfoEntity alloc] init];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 第一导航到其他的视图，表示用户开始采集信息
    // 将 self.carInfoEntity 保存到 userDefaults 暂存起来
    // 用于用户在没有「保存」的情况下退出应用后，下次打开时还能看到上次编辑的信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"UnsaveCarInfoEntity"]) {
#warning 需要对 carInfoEntity 类做序列化处理
        [userDefaults setObject:self.carInfoEntity forKey:@"UnsaveCarInfoEntity"];
    }
    
    
}

#pragma mark - Action

- (IBAction)saveButtonPress:(id)sender
{
}

- (IBAction)clearButtonPress:(id)sender
{
}
@end
