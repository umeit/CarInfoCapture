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
    
    NSArray *cityDicList = self.sourceLocationList[[self.tableView indexPathForSelectedRow].row][@"Cities"];
    NSMutableArray *cityNameList = [[NSMutableArray alloc] init];
    
    [cityDicList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        cityNameList[idx] = obj[@"city"];
    }];
    
    finalVC.dataList = cityNameList;
    finalVC.title = self.locationList[[self.tableView indexPathForSelectedRow].row];
    finalVC.popToViewController = self.navigationController.viewControllers[1];
    finalVC.delegate = self.navigationController.viewControllers[1];
    finalVC.itemPrefix = self.locationList[[self.tableView indexPathForSelectedRow].row];
}

@end
