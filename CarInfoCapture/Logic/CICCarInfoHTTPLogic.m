//
//  CICCarInfoHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoHTTPLogic.h"
#import "AFHTTPRequestOperationManager.h"
#import "CICCarInfoEntity.h"



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

- (void)uploadCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UploadCarInfoListBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *carInfoParameters = @{@"location": carInfo.location,
                                        @"carName": carInfo.carName,
                                        @"firstRegTime": carInfo.firstRegTime,
                                        @"insuranceExpire": carInfo.location,
                                        @"yearExamineExpire": carInfo.location,
                                        @"carSource": carInfo.location,
                                        @"dealTime": carInfo.location,
                                        @"mileage": carInfo.location,
                                        @"salePrice": carInfo.location,
                                        @"chassisState": carInfo.location,
                                        @"engineState": carInfo.location,
                                        @"paintState": carInfo.location,
                                        @"insideState": carInfo.location,
                                        @"facadeState": carInfo.location,
                                        @"masterName": carInfo.location,
                                        @"pic": carInfo.location,
                                        @"addTime": carInfo.location
                                        };
    
        [httpManager POST:@"http://xxx/capture/upload" parameters:carInfoParameters
                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            
                                        }
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              block(nil);
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              block(error);
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
