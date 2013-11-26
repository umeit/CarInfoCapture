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
    
    NSString *imageName = [NSString stringWithFormat:@"CarIamge_%f.png", [[NSDate date] timeIntervalSince1970]];
    // 图片路径
    NSString *iamgeSavePath = [saveImageDir stringByAppendingPathComponent:imageName];
    
    // 保存
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        if ([imageData writeToFile:iamgeSavePath atomically:YES]) {
            return iamgeSavePath;
        }
    }
    
    return nil;
}

+ (void)deleteLocalFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:path error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    } else {
        NSLog(@"文件删除失败");
    }
    NSLog(@"文件是否存在: %@", [fileManager isExecutableFileAtPath:path] ? @"YES" : @"NO");
}
@end
