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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CICFinalCheckViewController *finalVC = segue.destinationViewController;
    
    if ([self.tableView indexPathForSelectedRow].row != 0) {
        finalVC.dataList = [self monthList];
    } else {
        finalVC.dataList = [self pastMonthList];
    }
    
    finalVC.title = @"月";
    finalVC.popToViewController = self.navigationController.viewControllers[1];
    finalVC.delegate = self.navigationController.viewControllers[1];
}

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
        yearList[i] = [NSString stringWithFormat:@"%ld", year -= 1] ;
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
        monthList[i] = [NSString stringWithFormat:@"%ld", month ++] ;
    }
    
    return monthList;
}

- (NSArray *)monthList
{
    return @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12)];
}

@end
