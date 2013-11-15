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

@protocol CICCarBaseCheckDetailDelegate <NSObject>

- (void)selectedCheckItemList:(NSArray *)itemNameList fromType:(CheckType)checkType;
                                                          
@end

//typedef void(^SelectCheckItemFinishBlock)(NSArray *itemNameList, NSMutableArray *markedItemIndexPath);
typedef void(^SelectCheckItemFinishBlock)(NSArray *itemNameList, CheckType checkType);

@interface CICCarBaseCheckDetailViewController : UITableViewController

@property (nonatomic) CheckType checkType;

/**
 *  详细检车列表的初始值，由上一级视图传递进来
 */
@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (strong, nonatomic) SelectCheckItemFinishBlock selectCheckItemFinishBlock;

@property (weak, nonatomic) id<CICCarBaseCheckDetailDelegate> delegate;

@end
