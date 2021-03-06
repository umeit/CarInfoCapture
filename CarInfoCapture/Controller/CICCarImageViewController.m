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

// 必须拍摄的图片
#define kFrontFlankImageTag     30
#define kBackFlankImageTag      31
#define kInsideCentralImageTag  32
#define kFrontSeatImageTag      33
#define kBackSeatImageTag       34
#define kBackImageTag           35

// 其他车辆图片
#define kCarOtherImage0Tag           40
#define kCarOtherImage1Tag           41
#define kCarOtherImage2Tag           42
#define kCarOtherImage3Tag           43
#define kCarOtherImage4Tag           44
#define kCarOtherImage5Tag           45
#define kCarOtherImage6Tag           46
#define kCarOtherImage7Tag           47
#define kCarOtherImage8Tag           48
#define kCarOtherImage9Tag           49

@interface CICCarImageViewController () <UINavigationControllerDelegate,
                                         UIImagePickerControllerDelegate,
                                         UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *frontFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *backFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *insideCentralImage;
@property (weak, nonatomic) IBOutlet UIImageView *frontSeatImage;
@property (weak, nonatomic) IBOutlet UIImageView *backSeatImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage0;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage1;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage2;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage3;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage4;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage5;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage6;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage7;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage8;
@property (weak, nonatomic) IBOutlet UIImageView *carOtherImage9;

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
            
        case kBackImageTag:
            self.currentTackIamgeKey = kBackImage;
            break;
            
        case kCarOtherImage0Tag:
            self.currentTackIamgeKey = kCarOtherImage0;
            break;
            
        case kCarOtherImage1Tag:
            self.currentTackIamgeKey = kCarOtherImage1;
            break;
            
        case kCarOtherImage2Tag:
            self.currentTackIamgeKey = kCarOtherImage2;
            break;
            
        case kCarOtherImage3Tag:
            self.currentTackIamgeKey = kCarOtherImage3;
            break;
            
        case kCarOtherImage4Tag:
            self.currentTackIamgeKey = kCarOtherImage4;
            break;
            
        case kCarOtherImage5Tag:
            self.currentTackIamgeKey = kCarOtherImage5;
            break;
            
        case kCarOtherImage6Tag:
            self.currentTackIamgeKey = kCarOtherImage6;
            break;
            
        case kCarOtherImage7Tag:
            self.currentTackIamgeKey = kCarOtherImage7;
            break;
            
        case kCarOtherImage8Tag:
            self.currentTackIamgeKey = kCarOtherImage8;
            break;
            
        case kCarOtherImage9Tag:
            self.currentTackIamgeKey = kCarOtherImage9;
            break;
            
        default:
            break;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
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
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
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
        case 0:  // 拍照
            [self startCamera];
            break;
            
        case 1:  // 从相册选取
            [self showPhotoBrowser];
            break;
        default:
            break;
    }
}


#pragma mark - Private

- (void)updateUI
{
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
    
    UIImage *backImage = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kBackImage]];
    if (backImage) {
        self.backImage.image = [CICGlobalService thumbWithImage:backImage maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage0 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage0]];
    if (otherImage0) {
        self.carOtherImage0.image = [CICGlobalService thumbWithImage:otherImage0 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage1 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage1]];
    if (otherImage1) {
        self.carOtherImage1.image = [CICGlobalService thumbWithImage:otherImage1 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage2 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage2]];
    if (otherImage2) {
        self.carOtherImage2.image = [CICGlobalService thumbWithImage:otherImage2 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage3 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage3]];
    if (otherImage3) {
        self.carOtherImage3.image = [CICGlobalService thumbWithImage:otherImage3 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage4 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage4]];
    if (otherImage4) {
        self.carOtherImage4.image = [CICGlobalService thumbWithImage:otherImage4 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage5 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage5]];
    if (otherImage5) {
        self.carOtherImage5.image = [CICGlobalService thumbWithImage:otherImage5 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage6 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage6]];
    if (otherImage6) {
        self.carOtherImage6.image = [CICGlobalService thumbWithImage:otherImage6 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage7 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage7]];
    if (otherImage7) {
        self.carOtherImage7.image = [CICGlobalService thumbWithImage:otherImage7 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage8 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage8]];
    if (otherImage8) {
        self.carOtherImage8.image = [CICGlobalService thumbWithImage:otherImage8 maxHeight:160 maxWidth:213];
    }
    
    UIImage *otherImage9 = [CICGlobalService iamgeWithPath:self.carInfoEntity.carImagesLocalPaths[kCarOtherImage9]];
    if (otherImage9) {
        self.carOtherImage9.image = [CICGlobalService thumbWithImage:otherImage9 maxHeight:160 maxWidth:213];
    }
}

- (void)startCamera
{
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)showPhotoBrowser
{
    [self showImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

@end
