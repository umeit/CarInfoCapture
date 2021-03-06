//
//  CICCarBrandListViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBrandListViewController.h"
#import "CICCarBrandService.h"
#import "CICCarModelLIstViewController.h"

@interface CICCarBrandListViewController ()

@property (strong, nonatomic) NSArray *brandList;

@property (strong, nonatomic) CICCarBrandService *carBrandService;

@end

@implementation CICCarBrandListViewController

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
    
    self.brandList = [self.carBrandService carBrandList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回有多少个同类（按首字母）品牌
    return [self.brandList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 返回某一首字母下的品牌个数
    NSArray *list = self.brandList[section][@"blands"];
    
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICCarBrandListViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.brandList[indexPath.section][@"blands"][indexPath.row][@"name"];
    NSString *imageName = [NSString stringWithFormat:@"%@.%@", self.brandList[indexPath.section][@"blands"][indexPath.row][@"id"], @"jpg"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.brandList[section][@"letter"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.brandList) {
        [array addObject:dic[@"letter"]];
    }
    
    return array;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger lineNumberForCarModeListData = [self.brandList[indexPath.section][@"blands"][indexPath.row][@"childline"] integerValue];
    NSString *brandName = self.brandList[indexPath.section][@"blands"][indexPath.row][@"name"];
    
    [[NSUserDefaults standardUserDefaults] setObject:brandName forKey:@"CurrentSelecteBrandName"];
    
    CICCarModelLIstViewController *carModelLIstViewController = (CICCarModelLIstViewController *)segue.destinationViewController;
    carModelLIstViewController.lineNumberForCarModeListData = lineNumberForCarModeListData;
}

@end
