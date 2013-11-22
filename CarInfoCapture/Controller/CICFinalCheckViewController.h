//
//  CICFinalCheckViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CICFinalCheckViewControllerDelegate <NSObject>

- (void)selecatItem:(id)item;

@end

@interface CICFinalCheckViewController : UITableViewController

@property (weak, nonatomic) UIViewController *popToViewController;

@property (strong, nonatomic) NSArray *dataList;

@property (weak, nonatomic) id<CICFinalCheckViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *itemPrefix;

@end
