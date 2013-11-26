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

@property (nonatomic) CarImageIndex currentTackIamgeIndex;

@end

@implementation CICCarImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.frontFlankImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[frontFlankImage][@"v"]];
    self.backFlankImage.image  = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[backFlankImage][@"v"]];
}

#pragma mark - Action

- (IBAction)takePhotoButtonPress:(id)sender
{
    switch (((UIButton *)sender).tag) {
        case kFrontFlankImageTag:
            self.currentTackIamgeIndex = frontFlankImage;
            // 判断是否弹出编辑图片的菜单
            if(self.frontFlankImage.image) {
                [self showEditImageMenu];
                return;
            }
            else {
                // 启动相机
                [self showImagePicker];
            }
            break;
            
        case kBackFlankImageTag:
            // 判断是否弹出编辑图片的菜单;
            self.currentTackIamgeIndex = backFlankImage;
            if(self.backFlankImage.image) {
                [self showEditImageMenu];
                
                return;
            }
            else {
                // 启动相机
                [self showImagePicker];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完毕
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 原图
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // 保存到手机相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // 压缩图片
    image = [CICGlobalService thumbWithImage:image maxHeight:1024 maxWidth:1024];
    
    // 将图片保存到本地
    // 将图片路径保存到实体类
    NSString *iamgeSavePath = [CICGlobalService saveImageToLocal:image];
    
    // 如果该位置已有照片，则删除
    if ([self isAlreadySaveThisImageIndex:self.currentTackIamgeIndex]) {
        [CICGlobalService deleteLocalFileWithPath:self.carInfoEntity.carImagesLocalPathList[self.currentTackIamgeIndex][@"v"]];
    }
    
    self.carInfoEntity.carImagesLocalPathList[self.currentTackIamgeIndex] =
        @{@"k": @([self.carInfoEntity imageCodeWithImageIndex:self.currentTackIamgeIndex]),
          @"v": (iamgeSavePath ? iamgeSavePath : @"")};
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.delegate carInfoDidChange:self.carInfoEntity];
    }];
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

- (BOOL)isAlreadySaveThisImageIndex:(NSInteger)index
{
    NSDictionary *dic = self.carInfoEntity.carImagesLocalPathList[index];
    if ([dic[@"k"] integerValue] == 0) {
        return NO;
    }
    return YES;
}

@end
