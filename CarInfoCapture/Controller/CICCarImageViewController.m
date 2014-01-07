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
    
    UIImage *frontFlankImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[frontFlankImageIndex][@"v"]];
    if (frontFlankImage) {
        self.frontFlankImage.image = frontFlankImage;
    }
    
    UIImage *backFlankImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[backFlankImageIndex][@"v"]];
    if (backFlankImage) {
        self.backFlankImage.image = backFlankImage;
    }
    
    UIImage *insideCentralImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[insideCentralImageIndex][@"v"]];
    if (insideCentralImage) {
        self.insideCentralImage.image = insideCentralImage;
    }
    
    UIImage *frontSeatImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[frontSeatImageIndex][@"v"]];
    if (frontSeatImage) {
        self.frontSeatImage.image = frontSeatImage;
    }
    
    UIImage *backSeatImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[backSeatImageIndex][@"v"]];
    if (backSeatImage) {
        self.backSeatImage.image = backSeatImage;
    }
}

#pragma mark - Action

- (IBAction)takePhotoButtonPress:(id)sender
{
    // 记录当前操作的图片
    switch (((UIButton *)sender).tag) {
        case kFrontFlankImageTag:
            self.currentTackIamgeIndex = frontFlankImageIndex;
            break;
            
        case kBackFlankImageTag:
            self.currentTackIamgeIndex = backFlankImageIndex;
            break;
            
        case kInsideCentralImageTag:
            self.currentTackIamgeIndex = insideCentralImageIndex;
            break;
            
        case kFrontSeatImageTag:
            self.currentTackIamgeIndex = frontSeatImageIndex;
            break;
            
        case kBackSeatImageTag:
            self.currentTackIamgeIndex = backSeatImageIndex;
            break;
            
        default:
            break;
    }
    
    // 判断是否弹出编辑图片的菜单
    if([self.carInfoEntity.carImagesLocalPathList[self.currentTackIamgeIndex][@"v"] length] > 0) {
        [self showEditImageMenu];
        return;
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
    // 原图
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // 保存到手机相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // 压缩图片
    image = [CICGlobalService thumbWithImage:image maxHeight:800 maxWidth:800];
    
    // 将图片保存到本地
    NSString *iamgeSavePath = [CICGlobalService saveImageToLocal:image];
    
    // 如果该位置已有照片，则删除
    if ([self isAlreadySaveThisImageIndex:self.currentTackIamgeIndex]) {
        [CICGlobalService deleteLocalFileWithPath:self.carInfoEntity.carImagesLocalPathList[self.currentTackIamgeIndex][@"v"]];
    }
    
    // 将图片路径保存到实体类
    self.carInfoEntity.carImagesLocalPathList[self.currentTackIamgeIndex] =
        @{@"k": @([self.carInfoEntity imageCodeWithImageIndex:self.currentTackIamgeIndex]),
          @"v": (iamgeSavePath ? iamgeSavePath : @"")};
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // 跟新UI
        switch (self.currentTackIamgeIndex) {
            case frontFlankImageIndex:
//                self.frontFlankImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[frontFlankImageIndex][@"v"]];
                self.frontFlankImage.image = image;
                break;
                
            case backFlankImageIndex:
//                self.backFlankImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[backFlankImageIndex][@"v"]];
                self.backFlankImage.image = image;
                break;
                
            case insideCentralImageIndex:
//                self.insideCentralImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[insideCentralImageIndex][@"v"]];
                self.insideCentralImage.image = image;
                break;
                
            case frontSeatImageIndex:
//                self.frontSeatImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[frontSeatImageIndex][@"v"]];
                self.frontSeatImage.image = image;
                break;
                
            case backSeatImageIndex:
//                self.backSeatImage.image = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPathList[backSeatImageIndex][@"v"]];
                self.backSeatImage.image = image;
                break;
                
            default:
                break;
        }
        
        // 通知代理实体类的变化
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
