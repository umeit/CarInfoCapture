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

@interface CICCarBaseInfoViewController () <UITextFieldDelegate>

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

@property (strong, nonatomic) UITextField *currentEditTextField;

@end

@implementation CICCarBaseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.mileageTextField.inputAccessoryView = numberToolbar;
    self.salePriceTextField.inputAccessoryView = numberToolbar;
    
    self.mileageTextField.delegate = self;
    self.salePriceTextField.delegate = self;
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
    
    // 监听键盘弹出/隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.currentEditTextField = textField;
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentEditTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentEditTextField = nil;
}

#pragma mark - Private

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.currentEditTextField.frame.origin) ) {
        [self.tableView scrollRectToVisible:self.currentEditTextField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.f, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)cancelNumberPad {
    [self.currentEditTextField resignFirstResponder];
    self.currentEditTextField.text = @"";
    
    if (self.currentEditTextField == self.salePriceTextField) {
        self.carInfoEntity.salePrice = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.mileageTextField) {
        self.carInfoEntity.mileage = self.currentEditTextField.text;
    }
    
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)doneWithNumberPad {
    if (self.currentEditTextField == self.salePriceTextField) {
        self.carInfoEntity.salePrice = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.mileageTextField) {
        self.carInfoEntity.mileage = self.currentEditTextField.text;
    }
    [self.self.currentEditTextField resignFirstResponder];
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

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
