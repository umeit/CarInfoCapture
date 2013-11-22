//
//  CICFinalCheckViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICFinalCheckViewController.h"

@interface CICFinalCheckViewController ()

@end

@implementation CICFinalCheckViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICFinalCheckViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemPrefix) {
        [self.delegate selecatItem:[NSString stringWithFormat:@"%@%@", self.itemPrefix, self.dataList[indexPath.row]]];
    } else {
        [self.delegate selecatItem:self.dataList[indexPath.row]];
    }
    
    
    [self.navigationController popToViewController:self.popToViewController animated:YES];
}

@end
