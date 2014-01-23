//
//  CICFinalCheckViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICFinalCheckViewController.h"

@implementation CICFinalCheckViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList[section][@"cellList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICFinalCheckViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([self.dataList[indexPath.section][@"cellList"][indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = self.dataList[indexPath.section][@"cellList"][indexPath.row];
    }
    else if ([self.dataList[indexPath.section][@"cellList"][indexPath.row] isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = self.dataList[indexPath.section][@"cellList"][indexPath.row][@"displayName"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataList[section][@"sectionName"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemPrefix) {
        if ([self.dataList[indexPath.section][@"cellList"][indexPath.row] isKindOfClass:[NSString class]]) {
            [self.delegate selecatItem:[NSString stringWithFormat:@"%@%@", self.itemPrefix, self.dataList[indexPath.section][@"cellList"][indexPath.row]]];

        }
         else if ([self.dataList[indexPath.section][@"cellList"][indexPath.row] isKindOfClass:[NSDictionary class]]) {
             self.dataList[indexPath.section][@"cellList"][indexPath.row][@"displayName"] = [NSString stringWithFormat:@"%@ %@", self.itemPrefix, self.dataList[indexPath.section][@"cellList"][indexPath.row][@"displayName"]];
             [self.delegate selecatItem:self.dataList[indexPath.section][@"cellList"][indexPath.row]];
         }
    } else {
        [self.delegate selecatItem:self.dataList[indexPath.section][@"cellList"][indexPath.row]];
    }
    
    [self.navigationController popToViewController:self.popToViewController animated:YES];
}

@end
