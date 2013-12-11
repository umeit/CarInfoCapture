//
//  CICCarBaseCheckDetailViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-12.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseCheckDetailViewController.h"
#import "CICAddCustomItemViewController.h"

@interface CICCarBaseCheckDetailViewController () <CICAddCustomItemViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *itemList;

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
    [self.delegate selectedCheckItemList:self.selectedItems fromType:self.checkType];
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
    
    if (self.checkType == Facade) {
        // 单选
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
            
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self removeAllMarkedItems];
            
            [self addMarkedItemName:itemName];
            
            [self.tableView reloadData];
        }
    }
    else {
        // 多选
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self removeMarkedItemName:itemName];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self addMarkedItemName:itemName];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICAddCustomItemViewController *addCustomItemViewController = segue.destinationViewController;
    addCustomItemViewController.delegate = self;
}

#pragma mark - CICAddCustomItemViewControllerDelegate

- (void)newItemDidadded:(NSString *)item
{
    [self.itemList addObject:item];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (self.checkType) {
        case Underpan:
            [userDefaults setObject:self.itemList
                             forKey:[NSString stringWithFormat:@"%@%@", @"Underpan", [userDefaults stringForKey:@"currentLoginedUserID"]]];
            break;
            
        case Engine:
            [userDefaults setObject:self.itemList
                             forKey:[NSString stringWithFormat:@"%@%@", @"Engine", [userDefaults stringForKey:@"currentLoginedUserID"]]];
            break;
            
        case Paint:
            [userDefaults setObject:self.itemList
                             forKey:[NSString stringWithFormat:@"%@%@", @"Paint", [userDefaults stringForKey:@"currentLoginedUserID"]]];
            break;
            
        case Inside:
            [userDefaults setObject:self.itemList
                             forKey:[NSString stringWithFormat:@"%@%@", @"Inside", [userDefaults stringForKey:@"currentLoginedUserID"]]];
            break;
            
        case Facade:
            [userDefaults setObject:self.itemList
                             forKey:[NSString stringWithFormat:@"%@%@", @"Facade", [userDefaults stringForKey:@"currentLoginedUserID"]]];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (NSMutableArray *)checkItemWithType:(NSString *)typeStr
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@%@", typeStr, [userDefaults stringForKey:@"currentLoginedUserID"]];
    
    NSMutableArray *itemList = (NSMutableArray *)[userDefaults arrayForKey:key];
    if (!itemList) {
        // 初始的选项
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

- (void)addMarkedItemName:(NSString *)itemName
{
    if (!self.selectedItems) {
        self.selectedItems = [[NSMutableArray alloc] init];
    }
    [self.selectedItems addObject:itemName];
}

- (void)removeMarkedItemName:(NSString *)itemName
{
    [self.selectedItems removeObject:itemName];
}

- (void)removeAllMarkedItems
{
    [self.selectedItems removeAllObjects];
}

- (BOOL)isItemMarkedWithItemName:(NSString *)itemName
{
    return (self.selectedItems) && ([self.selectedItems indexOfObject:itemName] != NSNotFound)
           ? YES : NO;
}
@end
