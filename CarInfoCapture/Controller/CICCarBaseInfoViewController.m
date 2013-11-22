//
//  CICCarBaseInfoViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseInfoViewController.h"

#define CarSourceCellTag  35
#define DealTimeCellTag   36

@interface CICCarBaseInfoViewController ()

@end

@implementation CICCarBaseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    UITableViewCell *cell = sender;
    if (cell.tag == CarSourceCellTag) {
        CICFinalCheckViewController *finalVC = segue.destinationViewController;
        
        finalVC.title = @"车辆来源";
        finalVC.popToViewController = self;
        finalVC.delegate = self;
        finalVC.dataList = [self carSourceList];
    }
    else if (cell.tag == DealTimeCellTag) {
        CICFinalCheckViewController *finalVC = segue.destinationViewController;
        
        finalVC.title = @"过户次数";
        finalVC.popToViewController = self;
        finalVC.delegate = self;
        finalVC.dataList = [self dealTimeList];
    }
}


#pragma mark - CICFinalCheckViewControllerDelegate

- (void)selecatItem:(id)item
{
    [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text = item;
}

#pragma mark - Private

- (NSArray *)carSourceList
{
    #warning 使用 plist
    return @[@"亚运村", @"花乡", @"个人"];
}

- (NSArray *)dealTimeList
{
    #warning 使用 plist
    return @[@"1 次", @"2 次", @"3 次", @"4 次", @"5 次", @"6 次"];
}

@end
