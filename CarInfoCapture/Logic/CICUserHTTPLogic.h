//
//  CICUserHTTPLogic.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-12-6.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LoginBlock)(id responseObject, NSError *error);
@interface CICUserHTTPLogic : NSObject
+ (void)loginWithUserID:(NSString *)userID password:(NSString *)password block:(LoginBlock)bloc;
@end
