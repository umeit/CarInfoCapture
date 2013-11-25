//
//  CICCarMasterInfoViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CICCarInfoDidChangeDelegate.h"

@class  CICCarInfoEntity;

@interface CICCarMasterInfoViewController : UITableViewController

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@property (weak, nonatomic) id<CICCarInfoDidChangeDelegate> delegate;

@end
