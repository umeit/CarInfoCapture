//
//  CICViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-12-4.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICViewController : UIViewController

- (void)showCustomTextAlert:(NSString *)text withOKButtonPressed:(void(^)())block;

- (void)showCustomTextAlert:(NSString *)text;

- (void)showCustomText:(NSString *)text delay:(NSInteger)delay;

- (void)showLodingView;

- (void)showLodingViewWithText:(NSString *)text;

- (void)hideLodingView;

@end
