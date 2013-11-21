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
#import "NSDictionary+CICDictionary.h"
#import "NSArray+CICArray.h"

@interface CICCarInfoHTTPLogic ()

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
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *carInfoParameters = [self carInfoParameters:carInfo];
    
    [httpManager POST:@"http://192.168.100.190/capture/upload" parameters:carInfoParameters
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
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *uploadImageParameters = [self uploadImageParameters:filePathStr];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePathStr];
    
    [httpManager POST:@"http://upload.darengong.com:8090"
           parameters:uploadImageParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                [formData appendPartWithFileData:imageData
                                                                            name:@"Filedata"
                                                                        fileName:@"tuxiang.png"
                                                                        mimeType:@"image/jpeg"];
                                                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                NSString *remoteImagePath = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                               
                                                                block(remoteImagePath, nil);
                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                NSLog(@"%@", error.description);
                                                                
                                                                block(nil, error);
                                                           }];
}

#pragma mark - Private

- (NSDictionary *)carInfoParameters:(CICCarInfoEntity *)carInfo
{
    NSDictionary *carInfoParameters = @{@"location": [carInfo.carImagesLocalPathList jsonStringFormat],
//                                        @"carName": carInfo.carName,
//                                        @"firstRegTime": carInfo.firstRegTime,
//                                        @"insuranceExpire": carInfo.location,
//                                        @"yearExamineExpire": carInfo.location,
//                                        @"carSource": carInfo.location,
//                                        @"dealTime": carInfo.location,
//                                        @"mileage": carInfo.location,
//                                        @"salePrice": carInfo.location,
//                                        @"chassisState": carInfo.location,
//                                        @"engineState": carInfo.location,
//                                        @"paintState": carInfo.location,
//                                        @"insideState": carInfo.location,
//                                        @"facadeState": carInfo.location,
//                                        @"masterName": carInfo.location,
//                                        @"pic": [carInfo.carImagesRemotePathDictionary jsonStringWithArrayFormat]};
    @"pic": [carInfo.carImagesLocalPathList jsonStringFormat]};
//                                        @"addTime": carInfo.location};
    return carInfoParameters;
}

- (NSDictionary *)uploadImageParameters:(NSString *)filePathStr
{
//    NSData *imageData = [NSData dataWithContentsOfFile:filePathStr];
    
    NSDictionary *uploadImageParameters = @{@"Filename": @"TuXiang.png",
                                            @"filepath": @"/0/capture/",
                                            @"filecate": @"picture"};
//                                            @"Filedata": imageData};
    return uploadImageParameters;
}

@end
