//
//  CICMainCaptureViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CICTableViewController.h"

@class CICCarInfoEntity;

@interface CICMainCaptureViewController : CICTableViewController

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@end
