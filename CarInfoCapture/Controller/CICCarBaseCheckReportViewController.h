//
//  CICCarFirstReportViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CICCarInfoEntity;

@protocol CICCarBaseCheckReportDeledate <NSObject>

- (void)carInfoDidChange:(CICCarInfoEntity *)carInfoEntity;

@end

@interface CICCarBaseCheckReportViewController : UITableViewController

@property (weak, nonatomic) id<CICCarBaseCheckReportDeledate> delegate;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@end