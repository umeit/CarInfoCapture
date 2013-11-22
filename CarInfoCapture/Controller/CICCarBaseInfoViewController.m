//
//  CICCarBaseInfoViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseInfoViewController.h"

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
    
}


#pragma mark - CICFinalCheckViewControllerDelegate

- (void)selecatItem:(id)item
{
    [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text = item;
}

@end
