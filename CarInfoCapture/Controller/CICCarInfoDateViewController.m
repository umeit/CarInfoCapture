//
//  CICCarInfoDateViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoDateViewController.h"
#import "CICFinalCheckViewController.h"

@interface CICCarInfoDateViewController ()

@property (strong, nonatomic) NSArray *yearList;

@end

@implementation CICCarInfoDateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.yearList = [self pastYearList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yearList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICCarInfoDateViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.yearList[indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICFinalCheckViewController *finalVC = segue.destinationViewController;
    
    NSArray *dataList;
    
    if ([self.tableView indexPathForSelectedRow].row != 0) {
        dataList = @[@{@"sectionName": @"",
                                @"cellList": [self monthList]}];
    } else {
        dataList = @[@{@"sectionName": @"",
                                @"cellList": [self pastMonthList]}];
    }
    
    finalVC.dataList = dataList;
    finalVC.title = @"月";
    finalVC.popToViewController = self.navigationController.viewControllers[1];
    finalVC.delegate = self.navigationController.viewControllers[1];
    finalVC.itemPrefix = [NSString stringWithFormat:@"%@-", self.yearList[[self.tableView indexPathForSelectedRow].row]];
}

#pragma mark - Private

- (NSArray *)pastYearList
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year = comps.year + 1;
    
    NSMutableArray *yearList = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 20; i++) {
        yearList[i] = [NSString stringWithFormat:@"%ld", (long)(year -= 1)] ;
    }
    
    return yearList;
}

- (NSArray *)pastMonthList
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger month = comps.month;
    
    NSMutableArray *monthList = [[NSMutableArray alloc] init];
    
    NSInteger surplusMonth = (12 - month) + 1;
    
    for (NSInteger i = 0; i < surplusMonth; i++) {
        monthList[i] = [NSString stringWithFormat:@"%ld", (long)month ++] ;
    }
    
    return monthList;
}

- (NSArray *)monthList
{
    NSMutableArray *monthList = [[NSMutableArray alloc] init];
    
    NSInteger month = 1;
    
    for (NSInteger i = 0; i < 12; i++) {
        monthList[i] = [NSString stringWithFormat:@"%ld", (long)month ++] ;
    }
    
    return monthList;
}

@end
