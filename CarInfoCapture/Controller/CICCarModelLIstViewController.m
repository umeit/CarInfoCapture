//
//  CICCarModelLIstViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarModelLIstViewController.h"
#import "CICCarBrandService.h"
#import "CICFinalCheckViewController.h"

@interface CICCarModelLIstViewController ()

@property (strong, nonatomic) NSArray *carModelList;

@property (strong, nonatomic) CICCarBrandService *carBrandService;

@end

@implementation CICCarModelLIstViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.carBrandService = [[CICCarBrandService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.carModelList = [self.carBrandService carModelListAtLineNumber:self.lineNumberForCarModeListData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.carModelList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = self.carModelList[section][@"series"];
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICCarModelListViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.carModelList[indexPath.section][@"series"][indexPath.row][@"name"];
//    NSString *imageName = [NSString stringWithFormat:@"%@", self.carModelList[indexPath.section][@"series"][indexPath.row][@"id"]];
//    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.carModelList[section][@"factory"];
}

#pragma mark - Navigation

// 进入选择具体车型的视图（使用通用的最终视图）
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICFinalCheckViewController *finalVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger lineNumberForCarModeListData = [self.carModelList[indexPath.section][@"series"][indexPath.row][@"childline"] integerValue];
    
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    
    NSArray *carModelList = [self.carBrandService carModelListAtLineNumber:lineNumberForCarModeListData];
    
    // 填充 section 的值
    [carModelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": obj[@"year"],
                                                                                   @"cellList": [[NSMutableArray alloc] init]}];
        dataList[idx] = dic;
        
        // 填充 cell 的值
        [obj[@"cars"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dic[@"cellList"][idx] = @{@"displayName": obj[@"name"], @"value": obj[@"id"]};
        }];
    }];
    
    finalVC.dataList = dataList;
    finalVC.title = @"具体车型";
    finalVC.popToViewController = self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 3];
    finalVC.delegate = self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 3];
}

@end
