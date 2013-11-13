//
//  CICCarBaseCheckDetailViewController.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CheckType : NSInteger {
    Underpan,
    Engine,
    Paint,
    Inside,
    Facade
} CheckType;

typedef void(^SelectCheckItemFinishBlock)(NSArray *itemNameList, NSMutableArray *markedItemIndexPath);

@interface CICCarBaseCheckDetailViewController : UITableViewController

@property (nonatomic) CheckType checkType;

@property (strong, nonatomic) SelectCheckItemFinishBlock selectCheckItemFinishBlock;

@end
