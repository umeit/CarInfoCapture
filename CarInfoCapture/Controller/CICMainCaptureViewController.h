//
//  CICMainCaptureViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-13.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CICCarInfoEntity;

@interface CICMainCaptureViewController : UITableViewController

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@property (nonatomic, getter = isReviewModel) BOOL reviewModel;

@end
