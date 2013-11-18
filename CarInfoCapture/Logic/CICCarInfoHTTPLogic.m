//
//  CICCarInfoHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoHTTPLogic.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^CICCarInfoHTTPLogicUploadImageBLock)(NSString *urlStr, NSError *error);

@interface CICCarInfoHTTPLogic ()

- (void)uploadImage:(NSString *)filePathStr withBlock:(CICCarInfoHTTPLogicUploadImageBLock)block;

@end

@implementation CICCarInfoHTTPLogic

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    [httpManager GET:@"Path"
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(nil, error);
             }];
}

- (void)uploadCarInfo:(NSArray *)carInfoList
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
        [httpManager POST:@"http://xxx/capture/upload" parameters:@{@"key": @"value"}
                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            
                                        }
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                          }];
}

- (void)uploadImage:(NSString *)filePathStr withBlock:(CICCarInfoHTTPLogicUploadImageBLock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePathStr];
    
    NSDictionary *postParameters = @{@"Filename": @"TuXiang.jpg",
                                     @"filepath": @"/0/capture/",
                                     @"filecate": @"picture",
                                     @"Filedata": imageData};
    
    [httpManager POST:(@"http://upload.xxx.com")
           parameters:postParameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"%@", responseObject);
                  
                  block(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"%@", error.description);
                  
                  block(nil, error);
              }];
}

@end
