//
//  CICCarBaseInfoViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-22.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarBaseInfoViewController.h"
#import "CICCarInfoEntity.h"

#define CarNameCellTag           30
#define CarLocationCellTag       31
#define FirstRegCellTag          32
#define InsuranceExpireCellTag   33
#define YearExamineExpireCellTag 34
#define CarSourceCellTag         35
#define DealTimeCellTag          36
#define MileageCellTag           37
#define SalePriceCellTag         38

// 当前正在编辑的信息类型
typedef enum EditItemType : NSInteger{
    carName,
    carLocation,
    firstRegTime,
    insuranceExpire,
    yearExamineExpire,
    carSource,
    dealTime,
    mileage,
    salePrice
}EditItemType;

@interface CICCarBaseInfoViewController ()

// 当前正在编辑的信息类型
@property (nonatomic) EditItemType currentEditItem;

@property (weak, nonatomic) IBOutlet UILabel *carNameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLocationDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstRegTimeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceExpireDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearExamineExpireDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *carSourceDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeDetailLabel;
@property (weak, nonatomic) IBOutlet UITextField *mileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *salePriceTextField;

@end

@implementation CICCarBaseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.carNameDetailLabel.text = self.carInfoEntity.carName;
    self.carLocationDetailLabel.text = self.carInfoEntity.location;
    self.firstRegTimeDetailLabel.text = self.carInfoEntity.firstRegTime;
    self.insuranceExpireDetailLabel.text = self.carInfoEntity.insuranceExpire;
    self.yearExamineExpireDetailLabel.text = self.carInfoEntity.yearExamineExpire;
    self.carSourceDetailLabel.text = self.carInfoEntity.carSource;
    self.dealTimeDetailLabel.text = self.carInfoEntity.dealTime;
    self.mileageTextField.text = self.carInfoEntity.mileage;
    self.salePriceTextField.text = self.carInfoEntity.salePrice;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    CICFinalCheckViewController *finalVC;
    switch (cell.tag) {
        case CarNameCellTag:
            self.currentEditItem = carName;
            break;
            
        case CarLocationCellTag:
            self.currentEditItem = carLocation;
            break;

        case FirstRegCellTag:
            self.currentEditItem = firstRegTime;
            break;

        case InsuranceExpireCellTag:
            self.currentEditItem = insuranceExpire;
            break;

        case YearExamineExpireCellTag:
            self.currentEditItem = yearExamineExpire;
            break;

        case CarSourceCellTag:
            self.currentEditItem = carSource;
            finalVC = segue.destinationViewController;
            
            finalVC.title = @"车辆来源";
            finalVC.popToViewController = self;
            finalVC.delegate = self;
            finalVC.dataList = [self carSourceList];
            break;

        case DealTimeCellTag:
            self.currentEditItem = dealTime;
            finalVC = segue.destinationViewController;
            
            finalVC.title = @"过户次数";
            finalVC.popToViewController = self;
            finalVC.delegate = self;
            finalVC.dataList = [self dealTimeList];
            break;
            
        default:
            break;
    }
}

#pragma mark - CICFinalCheckViewControllerDelegate

- (void)selecatItem:(id)item
{
    [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text = item;
    
    [self updateCarInfo:item];
}

#pragma mark - Private

- (void)updateCarInfo:(NSString *)editedItem
{
    switch (self.currentEditItem) {
        case carLocation:
            self.carInfoEntity.location = editedItem;
            break;
            
        case carName:
            self.carInfoEntity.carName = editedItem;
            break;
            
        case firstRegTime:
            self.carInfoEntity.firstRegTime = editedItem;
            break;
            
        case insuranceExpire:
            self.carInfoEntity.insuranceExpire = editedItem;
            break;
            
        case yearExamineExpire:
            self.carInfoEntity.yearExamineExpire = editedItem;
            break;
            
        case carSource:
            self.carInfoEntity.carSource = editedItem;
            break;
            
        case dealTime:
            self.carInfoEntity.dealTime = editedItem;
            break;
            
//        case mileage:
//            self.carInfoEntity.mileage = editedItem;
//            break;
//            
//        case salePrice:
//            self.carInfoEntity.salePrice = editedItem;
//            break;
            
        default:
            break;
    }
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (NSArray *)carSourceList
{
    #warning 使用 plist
    return @[@{@"sectionName": @"",
        @"cellList": @[@"亚运村", @"花乡", @"个人"]}];
}

- (NSArray *)dealTimeList
{
    #warning 使用 plist
    return @[@{@"sectionName": @"",
               @"cellList": @[@"1", @"2", @"3", @"4", @"5", @"6"]}];
}

@end
