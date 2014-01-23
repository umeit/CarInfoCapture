//
//  CICCarImageViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-19.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarImageViewController.h"
#import "CICGlobalService.h"
#import "CICCarInfoEntity.h"
#import "UIViewController+GViewController.h"

#define kFrontFlankImageTag     30
#define kBackFlankImageTag      31
#define kInsideCentralImageTag  32
#define kFrontSeatImageTag      33
#define kBackSeatImageTag       34

#define kRetakePhoto    0
#define kReselectPhoto  1

@interface CICCarImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *frontFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *backFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *insideCentralImage;
@property (weak, nonatomic) IBOutlet UIImageView *frontSeatImage;
@property (weak, nonatomic) IBOutlet UIImageView *backSeatImage;

@property (nonatomic) NSString *currentTackIamgeKey;

@end

@implementation CICCarImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

#pragma mark - Action

- (IBAction)takePhotoButtonPress:(id)sender
{
    // 记录当前操作的图片
    switch (((UIButton *)sender).tag) {
        case kFrontFlankImageTag:
            self.currentTackIamgeKey = kFrontFlankImage;
            break;
            
        case kBackFlankImageTag:
            self.currentTackIamgeKey = kBackFlankImage;
            break;
            
        case kInsideCentralImageTag:
            self.currentTackIamgeKey = kInsideCentralImage;
            break;
            
        case kFrontSeatImageTag:
            self.currentTackIamgeKey = kFrontSeatImage;
            break;
            
        case kBackSeatImageTag:
            self.currentTackIamgeKey = kBackSeatImage;
            break;
            
        default:
            break;
    }
    
    // 判断是否弹出编辑图片的菜单
    if (self.carInfoEntity.carImagesLocalPaths[self.currentTackIamgeKey]) {
        [self showEditImageMenu];
    }
    else {
        // 启动相机
        [self showImagePicker];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完毕
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self showLodingViewOn:picker.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 原图
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        // 保存到手机相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        // 压缩图片
        image = [CICGlobalService thumbWithImage:image maxHeight:800 maxWidth:800];
        
        // 将图片保存到本地***
        NSString *iamgeSavePath = [CICGlobalService saveImageToLocal:image];
        
        // 如果该位置已有照片，则删除
        [CICGlobalService deleteLocalFileWithPath:self.carInfoEntity.carImagesLocalPaths[self.currentTackIamgeKey]];
        
        self.carInfoEntity.carImagesLocalPaths[self.currentTackIamgeKey] = iamgeSavePath;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideLodingView];
            
            // 跟新UI
            [self updateUI];
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
                // 通知代理实体类的变化
                [self.delegate carInfoDidChange:self.carInfoEntity];
                
            }];
        });
    });
}

// 拍照取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case kRetakePhoto:  // 拍照
            // 启动相机
            [self showImagePicker];
            break;
            
        case kReselectPhoto:  // 从相册选取
            
            break;
        default:
            break;
    }
}

#pragma mark - Private

- (void)updateUI
{
//    [self showLodingView];
    
    UIImage *frontFlankImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kFrontFlankImage]];
    if (frontFlankImage) {
        self.frontFlankImage.image = [CICGlobalService thumbWithImage:frontFlankImage maxHeight:160 maxWidth:213];
    }
    
    UIImage *backFlankImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kBackFlankImage]];
    if (backFlankImage) {
        self.backFlankImage.image = [CICGlobalService thumbWithImage:backFlankImage maxHeight:160 maxWidth:213];
    }
    
    UIImage *insideCentralImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kInsideCentralImage]];
    if (insideCentralImage) {
        self.insideCentralImage.image = [CICGlobalService thumbWithImage:insideCentralImage maxHeight:160 maxWidth:213];
    }
    
    UIImage *frontSeatImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kFrontSeatImage]];
    if (frontSeatImage) {
        self.frontSeatImage.image = [CICGlobalService thumbWithImage:frontSeatImage maxHeight:160 maxWidth:213];
    }
    
    UIImage *backSeatImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kBackSeatImage]];
    if (backSeatImage) {
        self.backSeatImage.image = [CICGlobalService thumbWithImage:backSeatImage maxHeight:160 maxWidth:213];
    }
    
//    [self hideLodingView];
}

- (void)showEditImageMenu
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"重新拍照"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    
    [self presentViewController:imagePicker animated:YES completion:^{
        // iOS 7
        
        // iOS 6
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

//- (BOOL)isAlreadySaveThisImageIndex:(NSInteger)index
//{
//    NSDictionary *dic = self.carInfoEntity.carImagesLocalPathList[index];
//    if ([dic[@"k"] integerValue] == 0) {
//        return NO;
//    }
//    return YES;
//}

@end
