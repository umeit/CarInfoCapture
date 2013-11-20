//
//  CICGlobalService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICGlobalService.h"

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
    NSData *imageData = [NSData dataWithContentsOfFile:pathStr];
    
    return [UIImage imageWithData:imageData];
}

+ (NSString *)saveImageToLocal:(UIImage *)image
{
    // 保存图片的目录
    NSString *saveImageDir = [[self documentPath] stringByAppendingPathComponent:@"carImages"];
    
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
    
    // 图片路径
    NSString *iamgeSavePath = [saveImageDir stringByAppendingPathComponent:@"image.png"];
    
    // 保存
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        if ([imageData writeToFile:iamgeSavePath atomically:YES]) {
            return iamgeSavePath;
        }
    }
    
    return nil;
}
@end
