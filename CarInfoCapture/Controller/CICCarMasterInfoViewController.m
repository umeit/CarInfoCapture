//
//  CICCarMasterInfoViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarMasterInfoViewController.h"
#import "CICCarInfoEntity.h"

@interface CICCarMasterInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *masterNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *masterTelTextField;
@end

@implementation CICCarMasterInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViewWithCarInfo];
    
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.masterTelTextField.inputAccessoryView = numberToolbar;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.carInfoEntity.masterName = self.masterNameTextField.text;
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self updateCarInfoEntity];
    
    return YES;
}

#pragma mark - Private

- (void)updateCarInfoEntity
{
    self.carInfoEntity.masterName = self.masterNameTextField.text;
    self.carInfoEntity.masterTel = self.masterTelTextField.text;
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)cancelNumberPad{
    [self.masterTelTextField resignFirstResponder];
    self.masterTelTextField.text = @"";
    self.carInfoEntity.masterTel = self.masterTelTextField.text;
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)doneWithNumberPad{
    self.carInfoEntity.masterTel = self.masterTelTextField.text;
    [self.masterTelTextField resignFirstResponder];
    
    [self.delegate carInfoDidChange:self.carInfoEntity];
}

- (void)updateViewWithCarInfo
{
    self.masterNameTextField.text = self.carInfoEntity.masterName;
    self.masterTelTextField.text = self.carInfoEntity.masterTel;
}

@end
