//
//  CICAddCustomItemViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-28.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICAddCustomItemViewController.h"

@interface CICAddCustomItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *customItemTextField;

@end

@implementation CICAddCustomItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.customItemTextField becomeFirstResponder];
}

#pragma mark - Action

- (IBAction)submitButtonPress:(id)sender
{
    [self.delegate newItemDidadded:self.customItemTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
