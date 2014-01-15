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
#import <CommonCrypto/CommonDigest.h>

@interface CICCarInfoHTTPLogic ()

@end

@implementation CICCarInfoHTTPLogic

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    [httpManager GET:@"http://capture.yicheyi.com/capture/get_mycapture"
          parameters:@{@"pi": @(1), @"ps": @(200)}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 block(responseObject, nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(nil, error);
             }];
}

- (void)uploadCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UploadCarInfoListBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    NSDictionary *carInfoParameters = [self carInfoParameters:carInfo];
    //capture.youche.com
    [httpManager POST:@"http://capture.yicheyi.com/capture/upload" parameters:carInfoParameters
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                    }
                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                          block(nil);
                                                      }
                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                          block(error);
                                                      }];
}

- (void)cancelAllUploadTask
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [[httpManager operationQueue] cancelAllOperations];
}

- (void)uploadImageWithLocalPath:(NSString *)filePathStr block:(CICCarInfoHTTPLogicUploadImageBLock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *uploadImageParameters = [self uploadImageParameters:filePathStr];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES)[0];
    NSData *imageData = [NSData dataWithContentsOfFile:[documentPath stringByAppendingPathComponent:filePathStr]];
    
    [httpManager POST:@"http://upload.darengong.com:8090"
           parameters:uploadImageParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                [formData appendPartWithFileData:imageData
                                                                            name:@"Filedata"
                                                                        fileName:@"tuxiang.png"
                                                                        mimeType:@"image/jpeg"];
                                                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                NSString *remoteImagePath = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                               
                                                                block([NSString stringWithFormat:@"/0/capture/%@", remoteImagePath], nil);
                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                NSLog(@"%@", error.description);
                                                                
                                                                block(nil, error);
                                                           }];
}



+ (void)downloadImageWithPath:(NSString *)path withBlock:(CICCarInfoHTTPLogicDownloadImageBlock)block
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [httpManager GET:[NSString stringWithFormat:@"http://file.darengong.com%@", path]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 block(responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(nil);
             }];
}

#pragma mark - Private

- (NSDictionary *)carInfoParameters:(CICCarInfoEntity *)carInfo
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentLoginedUserID"];
    NSString *captureUniqID = [self md532:[NSString stringWithFormat:@"%@%@", userID, [NSDate date]]];
    NSDictionary *carInfoParameters = @{@"addtime": carInfo.addTime,
                                        @"captureuniqid": captureUniqID,
                                        @"modelid": carInfo.modelID,
                                        @"carname": carInfo.carName,
                                        @"location": carInfo.location,
                                        @"firstregtime": carInfo.firstRegTime,
                                        @"insuranceexpire": carInfo.insuranceExpire,
                                        @"yearexamineexpire": carInfo.yearExamineExpire,
                                        @"carsource": carInfo.carSource,
                                        @"dealtime": carInfo.dealTime,
                                        @"mileage": carInfo.mileage,
                                        @"saleprice": carInfo.salePrice,
                                        @"chassisstate": carInfo.underpanIssueList ? [carInfo.underpanIssueList oneStringFormat] : @"",
                                        @"enginestate": carInfo.engineIssueList ? [carInfo.engineIssueList oneStringFormat] : @"",
                                        @"paintstate": carInfo.paintIssueList ? [carInfo.paintIssueList oneStringFormat] : @"",
                                        @"insidestate": carInfo.insideIssueList ? [carInfo.insideIssueList oneStringFormat] : @"",
                                        @"facadestate": carInfo.facadeIssueList ? [carInfo.facadeIssueList oneStringFormat] : @"",
                                        @"mastername": carInfo.masterName,
                                        @"mastertel": carInfo.masterTel,
                                        @"pic": [carInfo.carImagesRemotePaths jsonStringRemoteFormat]};
    return carInfoParameters;
}

- (NSDictionary *)uploadImageParameters:(NSString *)filePathStr
{
    NSDictionary *uploadImageParameters = @{@"Filename": @"TuXiang.png",
                                            @"filepath": @"/0/capture/",
                                            @"filecate": @"picture"};
    return uploadImageParameters;
}

- (NSString *)md532:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    //NSLog(@"%@",ret);
    return ret;
}
@end
