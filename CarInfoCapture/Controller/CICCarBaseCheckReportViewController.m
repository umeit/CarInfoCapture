//
//  CICCarFirstReportViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseCheckReportViewController.h"
#import "CICCarBaseCheckDetailViewController.h"
#import "CICCarInfoEntity.h"

@interface CICCarBaseCheckReportViewController () <CICCarBaseCheckDetailDelegate>

@property (weak, nonatomic) IBOutlet UILabel *underpanDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *paintDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *insideDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *facadeDetailLabel;

@end

@implementation CICCarBaseCheckReportViewController

- (void)viewWillAppear:(BOOL)animated
{
    // 将已选的问题填入每个分离的 cell 中
    self.underpanDetailLabel.text = [self detailLabelTextWithCarInfoCheckItemList:self.carInfoEntity.underpanIssueList];
    self.engineDetailLabel.text = [self detailLabelTextWithCarInfoCheckItemList:self.carInfoEntity.engineIssueList];
    self.paintDetailLabel.text = [self detailLabelTextWithCarInfoCheckItemList:self.carInfoEntity.paintIssueList];
    self.insideDetailLabel.text = [self detailLabelTextWithCarInfoCheckItemList:self.carInfoEntity.insideIssueList];
    self.facadeDetailLabel.text = [self detailLabelTextWithCarInfoCheckItemList:self.carInfoEntity.facadeIssueList];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
    CICCarBaseCheckDetailViewController *detailVC = segue.destinationViewController;
    detailVC.delegate = self;
    
    /*! 当用户选择详细项目视图弹出后，会调用该 Block，用于更新实体对象中的信息 */
//    detailVC.selectCheckItemFinishBlock = ^(NSArray *itemNameList, CheckType checkType) {
//        switch (checkType) {
//            case Underpan:
//                self.carInfoEntity.underpanIssueList = itemNameList;
//                break;
//                
//            case Engine:
//                self.carInfoEntity.engineIssueList = itemNameList;
//                break;
//                
//            case Paint:
//                self.carInfoEntity.paintIssueList = itemNameList;
//                break;
//                
//            case Inside:
//                self.carInfoEntity.insideIssueList = itemNameList;
//                break;
//                
//            case Facade:
//                self.carInfoEntity.facadeIssueList = itemNameList;
//                break;
//                
//            default:
//                break;
//        }
//    
//        // 将改动过的实体对象传递给 deledate（上一级视图），让 deledate 去保存
//        [self.delegate carInfoDidChange:self.carInfoEntity];
//    };

    // 判断选择详细项目视图应该显示哪个类别的项目
    // 并将实体对象中已选的信息传过去
    switch (selectedRow) {
        case 0: // 底盘
            detailVC.checkType = Underpan;
            detailVC.selectedItems = [NSMutableArray arrayWithArray:self.carInfoEntity.underpanIssueList];
            break;
        
        case 1: // 发动机
            detailVC.checkType = Engine;
            detailVC.selectedItems = [NSMutableArray arrayWithArray:self.carInfoEntity.engineIssueList];
            break;
            
        case 2: // 漆面
            detailVC.checkType = Paint;
            detailVC.selectedItems = [NSMutableArray arrayWithArray:self.carInfoEntity.paintIssueList];
            break;
            
        case 3: // 内饰
            detailVC.checkType = Inside;
            detailVC.selectedItems = [NSMutableArray arrayWithArray:self.carInfoEntity.insideIssueList];
            break;
            
        case 4: // 外观成色
            detailVC.checkType = Facade;
            detailVC.selectedItems = [NSMutableArray arrayWithArray:self.carInfoEntity.facadeIssueList];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private

- (NSString *)detailLabelTextWithCarInfoCheckItemList:(NSArray *)itemList
{
    return (itemList) && ([itemList count] > 0)
            ? [NSString stringWithFormat:@"发现 %d 个问题", [itemList count]]
            : @"不填则没问题";
}

#pragma mark - CICCarBaseCheckDetailDelegate

- (void)selectedCheckItemList:(NSArray *)itemNameList fromType:(CheckType)checkType
{
    switch (checkType) {
        case Underpan:
            self.carInfoEntity.underpanIssueList = itemNameList;
            break;
            
        case Engine:
            self.carInfoEntity.engineIssueList = itemNameList;
            break;
            
        case Paint:
            self.carInfoEntity.paintIssueList = itemNameList;
            break;
            
        case Inside:
            self.carInfoEntity.insideIssueList = itemNameList;
            break;
            
        case Facade:
            self.carInfoEntity.facadeIssueList = itemNameList;
            break;
            
        default:
            break;
    }
    
    // 将改动过的实体对象传递给 deledate（上一级视图），让 deledate 去保存
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

@end
