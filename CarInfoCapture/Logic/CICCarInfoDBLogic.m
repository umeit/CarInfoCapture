//
//  CICCarInfoDBLogic.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoDBLogic.h"
#import "CICGlobalService.h"
#import "CICCarInfoEntity.h"
#import "NSArray+CICArray.h"
#import "FMDatabase.h"

#define DBPath [[CICGlobalService documentPath] stringByAppendingPathComponent:@"CarInfoCapture.db"]

@implementation CICCarInfoDBLogic

+ (void)initCarInfoDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return;
    }
    
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS T_CarInfo" \
    "(id INTEGER PRIMARY KEY AUTOINCREMENT," \
    " status INTEGER, " \
    " carName VARCHAR, " \
    " carImagePath VARCHAR, " \
    " salePrice VARCHAR, " \
    " mileage VARCHAR, " \
    " firstRegTime VARCHAR, " \
    " underpanIssueList VARCHAR, " \
    " engineIssueList VARCHAR, " \
    " paintIssueList VARCHAR, " \
    " insideIssueList VARCHAR, " \
    " facadeIssueList VARCHAR " \
    ")";
    
    [db executeUpdate:createTableSQL];
    
    [db close];
}

+ (BOOL)isDBExist
{
    NSLog(@"%@", DBPath);
    return [[NSFileManager defaultManager] fileExistsAtPath:DBPath];
}

+ (void)carInfoListWithBlock:(CarInfoListBlock)block
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return;
    }
    
    NSMutableArray *carInfoList = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [db executeQuery:@"SELECT * FROM T_CarInfo"];
    while ([s next]) {
        CICCarInfoEntity *carInfo = [[CICCarInfoEntity alloc] init];
        
        carInfo.status = [s intForColumn:@"status"];
        carInfo.carName = [s stringForColumn:@"carName"];
        carInfo.carImage = [UIImage imageWithContentsOfFile:[s stringForColumn:@"carImagePath"]];
        carInfo.salePrice = [s stringForColumn:@"salePrice"];
        carInfo.mileage = [s stringForColumn:@"mileage"];
        carInfo.firstRegTime = [s stringForColumn:@"firstRegTime"];
        carInfo.underpanIssueList = [[s stringForColumn:@"underpanIssueList"] componentsSeparatedByString:@"#"];
        carInfo.engineIssueList = [[s stringForColumn:@"engineIssueList"] componentsSeparatedByString:@"#"];
        carInfo.paintIssueList = [[s stringForColumn:@"paintIssueList"] componentsSeparatedByString:@"#"];
        carInfo.insideIssueList = [[s stringForColumn:@"insideIssueList"] componentsSeparatedByString:@"#"];
        carInfo.facadeIssueList = [[s stringForColumn:@"facadeIssueList"] componentsSeparatedByString:@"#"];
        
        [carInfoList addObject:carInfo];
    }
    
    [db close];
    
    block(carInfoList, nil);
}

+ (void)saveCarInfo:(CICCarInfoEntity *)carInfo WithBlock:(SaveCarInfoBlock)block
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return;
    }
    
    BOOL success = [db executeUpdate:@"INSERT INTO T_CarInfo VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                        nil,
                        @(carInfo.status), carInfo.carName, carInfo.carImage,
                        carInfo.salePrice, carInfo.mileage, carInfo.firstRegTime,
                        [carInfo.underpanIssueList formatToOneString],
                        [carInfo.engineIssueList formatToOneString],
                        [carInfo.paintIssueList formatToOneString],
                        [carInfo.insideIssueList formatToOneString],
                        [carInfo.facadeIssueList formatToOneString]];
    
    if (success) {
        if (block) block(nil);
    }
    else {
        NSLog(@"%@", db.lastErrorMessage);
        if (block) block(db.lastError);
    }
    
    [db close];
}

+ (void)saveCarInfoList:(NSArray *)carInfoList WithBlock:(SaveCarInfoBlock)block
{
    for (CICCarInfoEntity *carInfo in carInfoList) {
        [CICCarInfoDBLogic saveCarInfo:carInfo WithBlock:nil];
    }
    
    if (block) block(nil);
}

+ (NSInteger)sumOfCarInfo
{
    #warning 待实现
    return 0;
}

+ (NSInteger)sumOfNoUploadCarInfo
{
    #warning 待实现
    return 0;
}

+ (void)noUploadCarInfoListWithBlock:(CarInfoListBlock)block
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return;
    }
    
    NSMutableArray *carInfoList = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [db executeQuery:@"SELECT * FROM T_CarInfo WHERE status = 1"];
    while ([s next]) {
        CICCarInfoEntity *carInfo = [[CICCarInfoEntity alloc] init];
        
        carInfo.status = [s intForColumn:@"status"];
        carInfo.carName = [s stringForColumn:@"carName"];
        carInfo.carImage = [UIImage imageWithContentsOfFile:[s stringForColumn:@"carImagePath"]];
        carInfo.salePrice = [s stringForColumn:@"salePrice"];
        carInfo.mileage = [s stringForColumn:@"mileage"];
        carInfo.firstRegTime = [s stringForColumn:@"firstRegTime"];
        carInfo.underpanIssueList = [[s stringForColumn:@"underpanIssueList"] componentsSeparatedByString:@"#"];
        carInfo.engineIssueList = [[s stringForColumn:@"engineIssueList"] componentsSeparatedByString:@"#"];
        carInfo.paintIssueList = [[s stringForColumn:@"paintIssueList"] componentsSeparatedByString:@"#"];
        carInfo.insideIssueList = [[s stringForColumn:@"insideIssueList"] componentsSeparatedByString:@"#"];
        carInfo.facadeIssueList = [[s stringForColumn:@"facadeIssueList"] componentsSeparatedByString:@"#"];
        
        [carInfoList addObject:carInfo];
    }
    
    [db close];
}
@end
