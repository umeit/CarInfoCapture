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
#define CarColorCellTag          37
//#define VINCellTag               38
//#define LicencePlateCellTag      39

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
    salePrice,
    carColor,
    vin,
    licencePlate
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
@property (weak, nonatomic) IBOutlet UITextField *vinTextField;
@property (weak, nonatomic) IBOutlet UITextField *licencePlateTextField;
@property (weak, nonatomic) IBOutlet UILabel *carColorDetailLabel;

@property (strong, nonatomic) UITextField *currentEditTextField;

@end

@implementation CICCarBaseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidSelect:)
                                                 name:@"BaseInfoItemDidSelect"
                                               object:nil];
    
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
    self.vinTextField.inputAccessoryView = numberToolbar;
    self.licencePlateTextField.inputAccessoryView = numberToolbar;
    
    self.mileageTextField.delegate = self;
    self.salePriceTextField.delegate = self;
    self.vinTextField.delegate = self;
    self.licencePlateTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.carNameDetailLabel.text = self.carInfoEntity.carName;
    self.carLocationDetailLabel.text = self.carInfoEntity.location;
    self.firstRegTimeDetailLabel.text = [self.carInfoEntity.firstRegTime substringToIndex:7];
    self.insuranceExpireDetailLabel.text = [self.carInfoEntity.insuranceExpire substringToIndex:7];
    self.yearExamineExpireDetailLabel.text = [self.carInfoEntity.yearExamineExpire substringToIndex:7];
    self.carSourceDetailLabel.text = self.carInfoEntity.carSource;
    self.dealTimeDetailLabel.text = self.carInfoEntity.dealTime;
    self.mileageTextField.text = self.carInfoEntity.mileage;
    self.salePriceTextField.text = self.carInfoEntity.salePrice;
    self.carColorDetailLabel.text = self.carInfoEntity.carColor;
    self.vinTextField.text = self.carInfoEntity.vin;
    self.licencePlateTextField.text = self.carInfoEntity.licencePlate;
    
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
            
        case CarColorCellTag:
            self.currentEditItem = carColor;
            finalVC = segue.destinationViewController;
            
            finalVC.title = @"车身颜色";
            finalVC.popToViewController = self;
            finalVC.delegate = self;
            finalVC.dataList = [self carColorList];
            break;
            
        default:
            break;
    }
}

#pragma mark - CICFinalCheckViewControllerDelegate

- (void)selecatItem:(id)item
{
    if ([item isKindOfClass:[NSString class]]) {
        [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text = item;
        [self updateCarInfo:item];
    }
    else if ([item isKindOfClass:[NSDictionary class]]) {
        [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text = item[@"displayName"];
        
        if (self.currentEditItem == carName) {
            [self updateCarInfo:item];
        }
        else {
            [self updateCarInfo:item[@"displayName"]];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentEditTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.currentEditTextField == self.salePriceTextField) {
        self.carInfoEntity.salePrice = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.mileageTextField) {
        self.carInfoEntity.mileage = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.vinTextField) {
        self.carInfoEntity.vin = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.licencePlateTextField) {
        self.carInfoEntity.licencePlate = self.currentEditTextField.text;
    }
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}


#pragma mark - NSNotification

- (void)itemDidSelect:(NSNotification *)notification
{
//    NSInteger index = [[notification userInfo][@"SelectIndex"] integerValue];
    
    switch (self.currentEditItem) {
        case carLocation:
            break;
            
        case carName:
            break;
            
        case firstRegTime:
            break;
            
        case insuranceExpire:
            break;
            
        case yearExamineExpire:
            break;
            
        case carSource:
            break;
            
        case dealTime:
            break;
            
        default:
            break;
    }
}


#pragma mark - Private

- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.currentEditTextField.frame.origin) ) {
//        [self.tableView scrollRectToVisible:self.currentEditTextField.frame animated:YES];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.f, 0.0, 260.f, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)cancelNumberPad
{
    [self.currentEditTextField resignFirstResponder];
    self.currentEditTextField.text = @"";
    
    if (self.currentEditTextField == self.salePriceTextField) {
        self.carInfoEntity.salePrice = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.mileageTextField) {
        self.carInfoEntity.mileage = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.vinTextField) {
        self.carInfoEntity.vin = self.vinTextField.text;
    }
    else if (self.currentEditTextField == self.licencePlateTextField) {
        self.carInfoEntity.licencePlate = self.licencePlateTextField.text;
    }
    
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)doneWithNumberPad
{
    if (self.currentEditTextField == self.salePriceTextField) {
        self.carInfoEntity.salePrice = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.mileageTextField) {
        self.carInfoEntity.mileage = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.vinTextField) {
        self.carInfoEntity.vin = self.currentEditTextField.text;
    }
    else if (self.currentEditTextField == self.licencePlateTextField) {
        self.carInfoEntity.licencePlate = self.currentEditTextField.text;
    }
    
    [self.self.currentEditTextField resignFirstResponder];
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)updateCarInfo:(id)editedItem
{
    switch (self.currentEditItem) {
        case carLocation:
            self.carInfoEntity.location = editedItem;
            break;
            
        case carName:
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            self.carInfoEntity.carName = [NSString stringWithFormat:@"%@ %@ %@",
                                          [userDefaults stringForKey:@"CurrentSelecteBrandName"],
                                          [userDefaults stringForKey:@"CurrentSelecteModelName"],
                                          editedItem[@"displayName"]];
            self.carInfoEntity.modelID = editedItem[@"value"];
        }
            break;
            
        case firstRegTime:
            if ([editedItem length] < 7) {
                NSString *s1 = [editedItem substringToIndex:5];
                NSString *s2 = [editedItem substringFromIndex:5];
                editedItem = [NSString stringWithFormat:@"%@0%@", s1, s2];
            }
            self.carInfoEntity.firstRegTime = [NSString stringWithFormat:@"%@-01", editedItem];
            break;
            
        case insuranceExpire:
            if ([editedItem length] < 7) {
                NSString *s1 = [editedItem substringToIndex:5];
                NSString *s2 = [editedItem substringFromIndex:5];
                editedItem = [NSString stringWithFormat:@"%@0%@", s1, s2];
            }
            self.carInfoEntity.insuranceExpire = [NSString stringWithFormat:@"%@-01", editedItem];
            break;
            
        case yearExamineExpire:
            if ([editedItem length] < 7) {
                NSString *s1 = [editedItem substringToIndex:5];
                NSString *s2 = [editedItem substringFromIndex:5];
                editedItem = [NSString stringWithFormat:@"%@0%@", s1, s2];
            }
            self.carInfoEntity.yearExamineExpire = [NSString stringWithFormat:@"%@-01", editedItem];
            break;
            
        case carSource:
            self.carInfoEntity.carSource = editedItem;
            break;
            
        case dealTime:
            self.carInfoEntity.dealTime = editedItem;
            break;
            
        case carColor:
            self.carInfoEntity.carColor = editedItem;
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
               @"cellList": @[@{@"displayName": @"亚运村"},
                              @{@"displayName": @"花乡"},
                              @{@"displayName": @"个人"}]}];
}

- (NSArray *)carColorList
{
    return @[@{@"sectionName": @"",
               @"cellList": @[@{@"displayName": @"黑色"},
                              @{@"displayName": @"白色"},
                              @{@"displayName": @"银色"},
                              @{@"displayName": @"灰色"},
                              @{@"displayName": @"栗色"},
                              @{@"displayName": @"红色"},
                              @{@"displayName": @"蓝色"},
                              @{@"displayName": @"绿色"},
                              @{@"displayName": @"黄色"},
                              @{@"displayName": @"橙色"},
                              @{@"displayName": @"棕色"},
                              @{@"displayName": @"紫色"},
                              @{@"displayName": @"金色"},
                              @{@"displayName": @"其它"}]}];
}

- (NSArray *)dealTimeList
{
    #warning 使用 plist
    return @[@{@"sectionName": @"",
               @"cellList": @[@{@"displayName": @"1"},
                              @{@"displayName": @"2"},
                              @{@"displayName": @"3"},
                              @{@"displayName": @"4"},
                              @{@"displayName": @"5"},
                              @{@"displayName": @"6"}]}];
}

@end
