//
//  CICCarFirstReportViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseCheckReportViewController.h"
#import "CICCarBaseCheckDetailViewController.h"

@interface CICCarBaseCheckReportViewController ()

@property (strong, nonatomic) UITableViewCell *selectedCell;

@end

@implementation CICCarBaseCheckReportViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.selectedCell = sender;
    
    NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
    CICCarBaseCheckDetailViewController *detailVC = segue.destinationViewController;
    
    // 当用户选择详细项目视图弹出后，获取已选项，填充到 cell 中
    detailVC.selectCheckItemFinishBlock = ^(NSArray *itemNameList, NSMutableArray *markedItemIndexPath) {
        
        if (itemNameList && [itemNameList count] > 0) {
            self.selectedCell.detailTextLabel.text = [NSString stringWithFormat:@"发现 %d 个问题", [itemNameList count]];
        }
        else {
            self.selectedCell.detailTextLabel.text = @"不填则没问题";
        }
    };

    // 判断选择详细项目视图应该显示哪个类别的项目
    switch (selectedRow) {
        case 0:
            detailVC.checkType = Underpan; // 底盘
            break;
        
        case 1:
            detailVC.checkType = Engine; // 发动机
            break;
            
        case 2:
            detailVC.checkType = Paint; // 漆面
            break;
            
        case 3:
            detailVC.checkType = Inside; // 内饰
            break;
            
        case 4:
            detailVC.checkType = Facade; // 外观成色
            break;
            
        default:
            break;
    }
}

@end
