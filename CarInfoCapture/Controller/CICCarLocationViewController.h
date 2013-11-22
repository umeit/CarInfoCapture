//
//  CICCarLocalViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICCarLocationViewController : UITableViewController
@property (strong, nonatomic) NSArray *sourceLocationList;
@property (nonatomic) BOOL isFinalViewController;
@end
