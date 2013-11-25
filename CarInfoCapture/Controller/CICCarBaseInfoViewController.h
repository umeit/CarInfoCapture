//
//  CICCarBaseInfoViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CICFinalCheckViewController.h"
#import "CICCarInfoDidChangeDelegate.h"

@interface CICCarBaseInfoViewController : UITableViewController <CICFinalCheckViewControllerDelegate>

@property (weak, nonatomic) id<CICCarInfoDidChangeDelegate> delegate;

@property (strong, nonatomic) CICCarInfoEntity *carInfoEntity;

@end
