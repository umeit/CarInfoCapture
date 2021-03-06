//
//  CICCarInfoHTTPLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoHTTPLogic.h"
#import "CICHTTPClient.h"
#import "CICCarInfoEntity.h"
#import "NSDictionary+CICDictionary.h"
#import "NSArray+CICArray.h"
#import <CommonCrypto/CommonDigest.h>

@interface CICCarInfoHTTPLogic ()

@end

@implementation CICCarInfoHTTPLogic

+ (void)carInfoHistoryListWithBlock:(CarInfoHistoryListBlock)block
{
    [[CICHTTPClient sharedClient] GET:@"capture/get_mycapture"
                           parameters:@{@"pi": @(1), @"ps": @(200)}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  block(responseObject, nil);
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  block(nil, error);
                              }];
}

- (id)uploadCarInfo:(CICCarInfoEntity *)carInfo
{
    NSCondition *condition = [[NSCondition alloc] init];
    __block id response = nil;
    
    NSDictionary *carInfoParameters = [self carInfoParameters:carInfo];
    //capture.youche.com
    [[CICHTTPClient sharedClient] POST:@"capture/upload"
                            parameters:carInfoParameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   response = responseObject;
                                   
                                   // 发出信号，使线程继续
                                   [condition lock];
                                   [condition signal];
                                   [condition unlock];
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   response = nil;
                  
                                   // 发出信号，使线程继续
                                   [condition lock];
                                   [condition signal];
                                   [condition unlock];
                               }];
    
    // 线程等待请求完成
    [condition lock];
    [condition wait];
    [condition unlock];
    
    return response;
}

- (void)cancelAllUploadTask
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [[httpManager operationQueue] cancelAllOperations];
}

- (NSString *)uploadImageWithLocalPath:(NSString *)filePathStr
{
    NSCondition *condition = [[NSCondition alloc] init];
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *uploadImageParameters = [self uploadImageParameters:filePathStr];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES)[0];
    NSData *imageData = [NSData dataWithContentsOfFile:[documentPath stringByAppendingPathComponent:filePathStr]];
    
    __block NSString *remoteIamgePath = nil;
    
    [httpManager POST:@"http://upload.darengong.com:8090"
           parameters:uploadImageParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                [formData appendPartWithFileData:imageData
                                                                            name:@"Filedata"
                                                                        fileName:@"tuxiang.png"
                                                                        mimeType:@"image/jpeg"];
                                                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                NSString *remoteImagePath = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                                remoteIamgePath = [NSString stringWithFormat:@"/0/capture/%@", remoteImagePath];
                                                                // 发出信号，使线程继续
                                                                [condition lock];
                                                                [condition signal];
                                                                [condition unlock];
                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                NSLog(@"%@", error.description);
                                                                
                                                                [condition lock];
                                                                [condition signal];
                                                                [condition unlock];
                                                           }];
    // 线程等待请求完成
    [condition lock];
    [condition wait];
    [condition unlock];
    
    return remoteIamgePath;
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
                                        @"modelid": carInfo.modelID ? carInfo.modelID : @"",
                                        @"carname": carInfo.carName ? carInfo.carName : @"",
                                        @"location": carInfo.location ? carInfo.location : @"",
                                        @"firstregtime": carInfo.firstRegTime ? carInfo.firstRegTime : @"",
                                        @"insuranceexpire": carInfo.insuranceExpire ? carInfo.insuranceExpire : @"",
                                        @"yearexamineexpire": carInfo.yearExamineExpire ? carInfo.yearExamineExpire : @"",
                                        @"carsource": carInfo.carSource ? carInfo.carSource : @"",
                                        @"dealtime": carInfo.dealTime ? carInfo.dealTime : @"",
                                        @"mileage": carInfo.mileage ? carInfo.mileage : @"",
                                        @"saleprice": carInfo.salePrice ? carInfo.salePrice : @"",
                                        @"chassisstate": carInfo.underpanIssueList ? [carInfo.underpanIssueList oneStringFormat] : @"",
                                        @"enginestate": carInfo.engineIssueList ? [carInfo.engineIssueList oneStringFormat] : @"",
                                        @"paintstate": carInfo.paintIssueList ? [carInfo.paintIssueList oneStringFormat] : @"",
                                        @"insidestate": carInfo.insideIssueList ? [carInfo.insideIssueList oneStringFormat] : @"",
                                        @"facadestate": carInfo.facadeIssueList ? [carInfo.facadeIssueList oneStringFormat] : @"",
                                        @"mastername": carInfo.masterName,
                                        @"mastertel": carInfo.masterTel,
                                        @"carcolor": carInfo.carColor ? carInfo.carColor : @"",
                                        @"company" : carInfo.company ? carInfo.company : @"",
                                        @"pic": [carInfo.carImagesRemotePaths jsonStringRemoteFormat],
                                        @"vin": carInfo.vin,
                                        @"licencePlate": carInfo.licencePlate};
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
