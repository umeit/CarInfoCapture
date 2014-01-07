//
//  CICGlobalService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICGlobalService.h"

#define TwoDecimal(n) [[NSString stringWithFormat:@"%.2f", n] floatValue]
#define ImageFileDirName @"carImages"

@implementation CICGlobalService

+ (BOOL)isFirstOpenThisApp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return ![userDefaults boolForKey:@"used"];
}

+ (void)markUsed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"used"];
}

+ (NSString *)documentPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
    return documentPaths[0];
}

+ (UIImage *)iamgeWithPath:(NSString *)pathStr
{
    NSData *imageData = [NSData dataWithContentsOfFile:[[self documentPath] stringByAppendingPathComponent:pathStr]];
    
    return [UIImage imageWithData:imageData];
}

+ (NSString *)saveImageToLocal:(UIImage *)image
{
    // 保存图片的目录
    NSString *saveImageDir = [[self documentPath] stringByAppendingPathComponent:ImageFileDirName];
    
    BOOL isDir;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:saveImageDir isDirectory:&isDir];
    if (!isDir || !isDirExist) {
        // 创建目录
        BOOL res = [[NSFileManager defaultManager] createDirectoryAtPath:saveImageDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        } else {
            NSLog(@"文件夹创建失败");
        }
    }
    
    NSString *imageName = [NSString stringWithFormat:@"CarIamge_%f.png", [[NSDate date] timeIntervalSince1970]];
    // 图片路径
    NSString *iamgeSavePath = [saveImageDir stringByAppendingPathComponent:imageName];
    
    // 保存
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        if ([imageData writeToFile:iamgeSavePath atomically:YES]) {
            
            // 返回保存图片目录的相对路径
            return [ImageFileDirName stringByAppendingPathComponent:imageName];
        }
    }
    
    return nil;
}

+ (void)deleteLocalFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:[[self documentPath] stringByAppendingPathComponent:path] error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    } else {
        NSLog(@"文件删除失败");
    }
    NSLog(@"文件是否存在: %@", [fileManager isExecutableFileAtPath:path] ? @"YES" : @"NO");
}

+ (UIImage *)thumbWithImage:(UIImage *)sourceImage
                  maxHeight:(CGFloat)maxH
                   maxWidth:(CGFloat)maxW
{
    CGFloat sourceH = sourceImage.size.height;
    CGFloat sourceW = sourceImage.size.width;
    
    if (sourceH <= maxH && sourceW <= maxW) {
        return sourceImage;
    }
    
    // 是否需要缩放
    CGSize newSize;
    if (sourceH > sourceW && sourceH > maxH) {
        CGFloat n = sourceH / maxH;
        n = TwoDecimal(n);
        newSize = CGSizeMake(TwoDecimal(sourceW / n), TwoDecimal(sourceH / n));
        
    } else if (sourceW > sourceH && sourceW > maxW) {
        CGFloat n = sourceW / maxW;
        n = TwoDecimal(n);
        newSize = CGSizeMake(TwoDecimal(sourceW / n), TwoDecimal(sourceH / n));
        
    } else if (sourceH == sourceW && sourceW > maxW) {
        CGFloat n = sourceW / maxW;
        n = TwoDecimal(n);
        newSize = CGSizeMake(TwoDecimal(sourceW / n), TwoDecimal(sourceH / n));
    } else {
        return sourceImage;
    }
    
    return [self image:sourceImage scaledToSize:newSize];
}

+ (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
