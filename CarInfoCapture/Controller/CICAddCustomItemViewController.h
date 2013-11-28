//
//  CICAddCustomItemViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CICAddCustomItemViewControllerDelegate <NSObject>

- (void)newItemDidadded:(NSString *)item;

@end

@interface CICAddCustomItemViewController : UIViewController

@property (weak, nonatomic) id<CICAddCustomItemViewControllerDelegate>delegate;

@end
