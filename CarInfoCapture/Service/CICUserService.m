//
//  CICUserService.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-29.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUserService.h"
#import "CICUserHTTPLogic.h"

@implementation CICUserService

- (void)loginWithUserID:(NSString *)userID
               password:(NSString *)password
                  block:(CICUserServiceLoginBlock)block
{
    [CICUserHTTPLogic loginWithUserID:userID
                             password:password
                                block:^(id responseObject, NSError *error) {
        if (!error) {
            id retObject = [responseObject objectForKey:@"ret"];
            
            if (retObject) {
                
                NSInteger code = [retObject integerValue];
                switch (code) {
                    case 0:
                        block(CICUserServiceLoginSuccess);
                        break;
                    
                    case 1001:
                        block(CICUserServiceUserIDError);
                        break;
                        
                    case 1002:
                        block(CICUserServicePasswordError);
                        break;
                        
                    default:
                        block(CICUserServiceServerError);
                        break;
                }
            }
            else {
                block(CICUserServiceServerError);
            }
        }
        else {
            block(CICUserServiceNetworkingError);
        }
    }];
}

@end
