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

@property (strong, nonatomic) NSString *currentTackIamgeKey;
@end

@implementation CICCarImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.frontFlankImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathDictionary[kFrontFlankImage]];
}

#pragma mark - Action

- (IBAction)takePhotoButtonPress:(id)sender
{
    switch (((UIButton *)sender).tag) {
        case kFrontFlankImageTag:
            // 判断是否弹出编辑图片的菜单
            if(self.frontFlankImage.image) {
                [self showEditImageMenu];
                
                return;
            }
            else {
                // 启动相机
                self.currentTackIamgeKey = kFrontFlankImage;
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
    
    // 将图片路径保存到实体类
    NSString *iamgeSavePath = [CICGlobalService saveImageToLocal:image];
    self.carInfoEntity.carImagesLocalPathDictionary[self.currentTackIamgeKey] = iamgeSavePath ? iamgeSavePath : @"";
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
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
        case kRetakePhoto:
            // 启动相机
            [self showImagePicker];
            break;
            
        case kReselectPhoto:
            
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
@end
