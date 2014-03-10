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
#import "NSDictionary+CICDictionary.h"
#import "NSString+CICString.h"
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
    " addTime VARCHAR, " \
    " status INTEGER, " \
    " modelID INTEGER, " \
    " carName VARCHAR, " \
    " location VARCHAR, " \
    " insuranceExpire VARCHAR, " \
    " yearExamineExpire VARCHAR, " \
    " carSource VARCHAR, " \
    " dealTime VARCHAR, " \
    " salePrice VARCHAR, " \
    " mileage VARCHAR, " \
    " firstRegTime VARCHAR, " \
    " underpanIssueList VARCHAR, " \
    " engineIssueList VARCHAR, " \
    " paintIssueList VARCHAR, " \
    " insideIssueList VARCHAR, " \
    " facadeIssueList VARCHAR, " \
    " carImagesLocalPaths VARCHAR, " \
    " carImagesRemotePaths VARCHAR, " \
    " masterName VARCHAR, " \
    " masterTel VARCHAR, " \
    " carColor VARCHAR, " \
    " company VARCHAR" \
    ")";
    
    [db executeUpdate:createTableSQL];
    
    [db close];
}

+ (BOOL)isDBExist
{
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
    
    FMResultSet *s = [db executeQuery:@"SELECT * FROM T_CarInfo ORDER BY id DESC"];
    while ([s next]) {
        CICCarInfoEntity *carInfo = [[CICCarInfoEntity alloc] init];
        
        carInfo.dbID = [s intForColumn:@"id"];
        carInfo.addTime = [s stringForColumn:@"addTime"];
        carInfo.status = [s intForColumn:@"status"];
        carInfo.modelID = [s stringForColumn:@"modelID"];
        carInfo.carName = [s stringForColumn:@"carName"];
        carInfo.location = [s stringForColumn:@"location"];
        carInfo.insuranceExpire = [s stringForColumn:@"insuranceExpire"];
        carInfo.yearExamineExpire = [s stringForColumn:@"yearExamineExpire"];
        carInfo.carSource = [s stringForColumn:@"carSource"];
        carInfo.dealTime = [s stringForColumn:@"dealTime"];
        carInfo.salePrice = [s stringForColumn:@"salePrice"];
        carInfo.mileage = [s stringForColumn:@"mileage"];
        carInfo.firstRegTime = [s stringForColumn:@"firstRegTime"];
        carInfo.underpanIssueList = [[s stringForColumn:@"underpanIssueList"] componentsSeparatedByString:@"#"];
        carInfo.engineIssueList = [[s stringForColumn:@"engineIssueList"] componentsSeparatedByString:@"#"];
        carInfo.paintIssueList = [[s stringForColumn:@"paintIssueList"] componentsSeparatedByString:@"#"];
        carInfo.insideIssueList = [[s stringForColumn:@"insideIssueList"] componentsSeparatedByString:@"#"];
        carInfo.facadeIssueList = [[s stringForColumn:@"facadeIssueList"] componentsSeparatedByString:@"#"];
//        carInfo.carImagesLocalPathList = [NSMutableArray arrayWithArray:[[s stringForColumn:@"carImagesLocalPathList"] jsonStrToArray]];
        carInfo.carImagesLocalPaths = [NSMutableDictionary dictionaryWithDictionary:[[s stringForColumn:@"carImagesLocalPaths"] jsonStrToDictionary]];
        carInfo.carImagesRemotePaths = [NSMutableDictionary dictionaryWithDictionary:[[s stringForColumn:@"carImagesRemotePaths"] jsonStrToDictionary]];
        carInfo.masterName = [s stringForColumn:@"masterName"];
        carInfo.masterTel = [s stringForColumn:@"masterTel"];
        carInfo.carColor = [s stringForColumn:@"carColor"];
        carInfo.company = [s stringForColumn:@"company"];
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
    
    // 顺序
//    "(id INTEGER PRIMARY KEY AUTOINCREMENT," \
//    " addTime VARCHAR, " \
//    " status INTEGER, " \
//    " modelID INTEGER, " \
//    " carName VARCHAR, " \
//    " location VARCHAR, " \
//    " insuranceExpire VARCHAR, " \
//    " yearExamineExpire VARCHAR, " \
//    " carSource VARCHAR, " \
//    " dealTime VARCHAR, " \
//    " salePrice VARCHAR, " \
//    " mileage VARCHAR, " \
//    " firstRegTime VARCHAR, " \
//    " underpanIssueList VARCHAR, " \
//    " engineIssueList VARCHAR, " \
//    " paintIssueList VARCHAR, " \
//    " insideIssueList VARCHAR, " \
//    " facadeIssueList VARCHAR, " \
//    " carImagesLocalPathList VARCHAR, " \
//    " masterName VARCHAR, " \
//    " masterTel VARCHAR " \
//    ")";
    
    BOOL success = [db executeUpdate:@"INSERT INTO T_CarInfo VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                        nil,
                        carInfo.addTime, @(carInfo.status), carInfo.modelID, carInfo.carName, carInfo.location,
                        carInfo.insuranceExpire, carInfo.yearExamineExpire, carInfo.carSource,
                        carInfo.dealTime, carInfo.salePrice, carInfo.mileage, carInfo.firstRegTime,
                        [carInfo.underpanIssueList oneStringFormat],
                        [carInfo.engineIssueList oneStringFormat],
                        [carInfo.paintIssueList oneStringFormat],
                        [carInfo.insideIssueList oneStringFormat],
                        [carInfo.facadeIssueList oneStringFormat],
                        [carInfo.carImagesLocalPaths jsonStringLocalFormat],
                        [carInfo.carImagesRemotePaths jsonStringLocalFormat],
                        carInfo.masterName, carInfo.masterTel, carInfo.carColor, carInfo.company];
    
    [db close];
    
    if (success) {
        if (block) block(nil);
    }
    else {
        NSLog(@"%@", db.lastErrorMessage);
        if (block) block(db.lastError);
    }
    
    
}

+ (void)saveCarInfoList:(NSArray *)carInfoList WithBlock:(SaveCarInfoBlock)block
{
    for (CICCarInfoEntity *carInfo in carInfoList) {
        [CICCarInfoDBLogic saveCarInfo:carInfo WithBlock:nil];
    }
    
    block(nil);
}

+ (NSInteger)sumOfCarInfo
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return 0;
    }
    
    FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM T_CarInfo"];
    
    if ([s next]) {
        return [s intForColumnIndex:0];
    }
    
    [db close];
    return 0;
}

+ (NSInteger)sumOfNoUploadCarInfo
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return 0;
    }
    
    FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM T_CarInfo WHERE status = 1"];
    
    if ([s next]) {
        return [s intForColumnIndex:0];
    }
    
    [db close];
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
    
    FMResultSet *s = [db executeQuery:@"SELECT * FROM T_CarInfo WHERE status = 1 ORDER BY id DESC"];
    while ([s next]) {
        CICCarInfoEntity *carInfo = [[CICCarInfoEntity alloc] init];
        
        carInfo.dbID = [s intForColumn:@"id"];
        carInfo.addTime = [s stringForColumn:@"addTime"];
        carInfo.status = [s intForColumn:@"status"];
        carInfo.modelID = [s stringForColumn:@"modelID"];
        carInfo.carName = [s stringForColumn:@"carName"];
        carInfo.location = [s stringForColumn:@"location"];
        carInfo.insuranceExpire = [s stringForColumn:@"insuranceExpire"];
        carInfo.yearExamineExpire = [s stringForColumn:@"yearExamineExpire"];
        carInfo.carSource = [s stringForColumn:@"carSource"];
        carInfo.dealTime = [s stringForColumn:@"dealTime"];
        carInfo.salePrice = [s stringForColumn:@"salePrice"];
        carInfo.mileage = [s stringForColumn:@"mileage"];
        carInfo.firstRegTime = [s stringForColumn:@"firstRegTime"];
        carInfo.underpanIssueList = [[s stringForColumn:@"underpanIssueList"] componentsSeparatedByString:@"#"];
        carInfo.engineIssueList = [[s stringForColumn:@"engineIssueList"] componentsSeparatedByString:@"#"];
        carInfo.paintIssueList = [[s stringForColumn:@"paintIssueList"] componentsSeparatedByString:@"#"];
        carInfo.insideIssueList = [[s stringForColumn:@"insideIssueList"] componentsSeparatedByString:@"#"];
        carInfo.facadeIssueList = [[s stringForColumn:@"facadeIssueList"] componentsSeparatedByString:@"#"];
        carInfo.carImagesLocalPaths = [NSMutableDictionary dictionaryWithDictionary:[[s stringForColumn:@"carImagesLocalPaths"] jsonStrToDictionary]];
        carInfo.carImagesRemotePaths = [NSMutableDictionary dictionaryWithDictionary:[[s stringForColumn:@"carImagesRemotePaths"] jsonStrToDictionary]];
        carInfo.masterName = [s stringForColumn:@"masterName"];
        carInfo.masterTel = [s stringForColumn:@"masterTel"];
        carInfo.carColor = [s stringForColumn:@"carColor"];
        carInfo.company = [s stringForColumn:@"company"];
        
        [carInfoList addObject:carInfo];
    }
    
    [db close];
    block(carInfoList, nil);
}

+ (void)updateCarInfo:(CICCarInfoEntity *)carInfo withBlock:(UpdateCarInfoBlock)block
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
        return;
    }
    
    BOOL success = [db executeUpdate:@"UPDATE T_CarInfo SET addTime = ?, status = ?, modelID = ?, carName = ?, "\
                                      "location = ?, insuranceExpire = ?, yearExamineExpire = ?, "\
                                      "carSource = ?, dealTime = ?, salePrice = ?, mileage = ?, "\
                                      "firstRegTime = ?, underpanIssueList = ?, engineIssueList = ?, "\
                                      "paintIssueList = ?, insideIssueList = ?, facadeIssueList = ?, "\
                                      "carImagesLocalPaths = ?, carImagesRemotePaths = ?, masterName = ?, masterTel = ?, carColor = ?, company = ? "\
                                      "WHERE id = ? ",
                    carInfo.addTime, @(carInfo.status), carInfo.modelID, carInfo.carName, carInfo.location,
                    carInfo.insuranceExpire, carInfo.yearExamineExpire, carInfo.carSource,
                    carInfo.dealTime, carInfo.salePrice, carInfo.mileage, carInfo.firstRegTime,
                    [carInfo.underpanIssueList oneStringFormat],
                    [carInfo.engineIssueList oneStringFormat],
                    [carInfo.paintIssueList oneStringFormat],
                    [carInfo.insideIssueList oneStringFormat],
                    [carInfo.facadeIssueList oneStringFormat],
                    [carInfo.carImagesLocalPaths jsonStringLocalFormat],
                    [carInfo.carImagesRemotePaths jsonStringLocalFormat],
                    carInfo.masterName, carInfo.masterTel, carInfo.carColor, carInfo.company,
                    @(carInfo.dbID)];
    
    [db close];
    
    if (success) {
        if (block) block(nil);
    }
    else {
        NSLog(@"%@", db.lastErrorMessage);
        if (block) block(db.lastError);
    }
}

+ (void)deleteCarInfoWithID:(NSInteger)dbID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBPath];
    if (![db open]) {
        NSLog(@"**Error** Open DB error");
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM T_CarInfo WHERE id = %d", dbID];
    
    [db executeUpdate:sqlString];
}
@end
