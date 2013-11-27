//
//  CICCarLocalViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-21.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarLocationViewController.h"
#import "CICFinalCheckViewController.h"

@interface CICCarLocationViewController ()

@property (strong, nonatomic) NSMutableArray *locationList;

@end

@implementation CICCarLocationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.locationList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    self.sourceLocationList = [NSArray arrayWithContentsOfFile:path];
    
    [self.sourceLocationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.locationList[idx] = obj[@"State"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.locationList[indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICFinalCheckViewController *finalVC = segue.destinationViewController;
    
    
//    NSMutableArray *dataList = [[NSMutableArray alloc] init];
//    NSArray *carModelList = [self.carBrandService carModelListAtLineNumber:lineNumberForCarModeListData];
//    // 填充 section 的值
//    [carModelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"sectionName": obj[@"year"],
//                                                                                   @"cellList": [[NSMutableArray alloc] init]}];
//        dataList[idx] = dic;
//        
//        // 填充 cell 的值
//        [obj[@"cars"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            dic[@"cellList"][idx] = obj[@"name"];
//        }];
//    }];
//    
    
    NSArray *cityDicList = self.sourceLocationList[[self.tableView indexPathForSelectedRow].row][@"Cities"];
    NSMutableArray *cityNameList = [[NSMutableArray alloc] init];
    
    [cityDicList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        cityNameList[idx] = [NSMutableDictionary dictionaryWithDictionary:@{@"displayName": obj[@"city"]}];
    }];
    
    NSArray *dataList = @[@{@"sectionName": @"",
                            @"cellList": cityNameList}];
    
    finalVC.dataList = dataList;
    finalVC.title = self.locationList[[self.tableView indexPathForSelectedRow].row];
    finalVC.popToViewController = self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 2];
    finalVC.delegate = self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 2];
    finalVC.itemPrefix = self.locationList[[self.tableView indexPathForSelectedRow].row];
}

@end
