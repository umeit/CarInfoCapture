//
//  CICCarBaseCheckDetailViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseCheckDetailViewController.h"

@interface CICCarBaseCheckDetailViewController ()

@property (strong, nonatomic) NSMutableArray *itemList;

//@property (strong, nonatomic) NSMutableArray *markedItemIndexPath;

@end

@implementation CICCarBaseCheckDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    switch (self.checkType) {
        case Underpan:
            self.itemList = [self checkItemWithType:@"Underpan"];
            self.title = @"底盘";
            break;
            
        case Engine:
            self.itemList = [self checkItemWithType:@"Engine"];
            self.title = @"发动机";
            break;
            
        case Paint:
            self.itemList = [self checkItemWithType:@"Paint"];
            self.title = @"漆面";
            break;
        
        case Inside:
            self.itemList = [self checkItemWithType:@"Inside"];
            self.title = @"内饰";
            break;
        
        case Facade:
            self.itemList = [self checkItemWithType:@"Facade"];
            self.title = @"外观";
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 当视图弹出时，找出所有被选中的项（的名称），传递给上一级视图
//    NSMutableArray *itemNameList = [[NSMutableArray alloc] init];
    
//    for (NSIndexPath *indexPath in self.markedItemIndexPath) {
//        [itemNameList addObject:self.itemList[indexPath.row]];
//    }
//    
//    self.selectCheckItemFinishBlock(itemNameList, self.markedItemIndexPath);
    
    self.selectCheckItemFinishBlock(self.selectedItems);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    // 填入检查项的名称，如：发动机加速无力
    cell.textLabel.text = self.itemList[indexPath.row];
    
    // 标识已经被选则过的项
//    if ([self isMarkedItemIndexPath:indexPath]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    if ([self isItemMarkedWithItemName:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *itemName = cell.textLabel.text;
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
//        [self removeMarkedItemIndexPath:indexPath];
        [self removeMarkedItemName:itemName];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self addMarkedItemName:itemName];
        
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Private

- (NSMutableArray *)checkItemWithType:(NSString *)typeStr
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
#warning typeStr + userID
    NSMutableArray *itemList = (NSMutableArray *)[userDefaults arrayForKey:typeStr];
    if (!itemList) {
        switch (self.checkType) {
            case Underpan:
                itemList = [NSMutableArray arrayWithArray:@[@"事故导致底盘变形", @"悬挂系统异常",
                                                            @"传动轴异常", @"漏油"]];
                break;
                
            case Engine:
                itemList = [NSMutableArray arrayWithArray:@[@"有进水记录", @"有大修记录",
                                                            @"发动机更换过", @"有异响", @"加速无力"]];
                break;
                
            case Paint:
                itemList = [NSMutableArray arrayWithArray:@[@"有划痕", @"有钣金修复记录",
                                                            @"有更换外观件记录", @"有局部喷漆记录", @"有全车喷漆记录"]];
                break;
                
            case Inside:
                itemList = [NSMutableArray arrayWithArray:@[@"有瑕疵", @"有更换过内饰件记录"]];
                break;
                
            case Facade:
                itemList = [NSMutableArray arrayWithArray:@[@"较新", @"较旧", @"全新"]];
                break;
                
            default:
                break;
        }
        [userDefaults setObject:itemList forKey:typeStr];
    }
    return itemList;
}

//- (void)addMarkedItemIndexPath:(NSIndexPath *)indexPath
//{
//    if (!self.markedItemIndexPath) {
//        self.markedItemIndexPath = [[NSMutableArray alloc] init];
//    }
//    [self.markedItemIndexPath addObject:indexPath];
//}

- (void)addMarkedItemName:(NSString *)itemName
{
    if (!self.selectedItems) {
        self.selectedItems = [[NSMutableArray alloc] init];
    }
    [self.selectedItems addObject:itemName];
}

//- (void)removeMarkedItemIndexPath:(NSIndexPath *)indexPath
//{
//    [self.markedItemIndexPath removeObject:indexPath];
//}

- (void)removeMarkedItemName:(NSString *)itemName
{
    [self.selectedItems removeObject:itemName];
}

//- (BOOL)isMarkedItemIndexPath:(NSIndexPath *)indexPath
//{
//    if (!self.markedItemIndexPath
//        || [self.markedItemIndexPath indexOfObject:indexPath] == NSNotFound) {
//        
//        return NO;
//    }
//    return YES;
//}

- (BOOL)isItemMarkedWithItemName:(NSString *)itemName
{
    return (self.selectedItems) && ([self.selectedItems indexOfObject:itemName] != NSNotFound)
           ? YES : NO;
}
@end
