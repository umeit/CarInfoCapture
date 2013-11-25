//
//  CICCarFirstReportViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CICCarInfoDidChangeDelegate.h"

@class CICCarInfoEntity;

@interface CICCarBaseCheckReportViewController : UITableViewController

@property (weak, nonatomic) id<CICCarInfoDidChangeDelegate> delegate;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@end