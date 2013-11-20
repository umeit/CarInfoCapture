//
//  CICCarImageViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-19.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CICCarInfoDidChangeDelegate.h"

@class CICCarInfoEntity;

@interface CICCarImageViewController : UITableViewController

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@property (weak, nonatomic) id<CICCarInfoDidChangeDelegate> delegate;

@end
