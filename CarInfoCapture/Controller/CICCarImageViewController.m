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

@interface CICCarImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *frontFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *backFlankImage;
@property (weak, nonatomic) IBOutlet UIImageView *insideCentralImage;
@property (weak, nonatomic) IBOutlet UIImageView *frontSeatImage;
@property (weak, nonatomic) IBOutlet UIImageView *backSeatImage;
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 原图
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // 保存到手机相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.frontFlankImage.image = image;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
