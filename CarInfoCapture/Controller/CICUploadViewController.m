//
//  CICUploadViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-27.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUploadViewController.h"

@interface CICUploadViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *cancelButton;

@end

@implementation CICUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadButtonPress:(id)sender
{
}
- (IBAction)cancelButtonPress:(id)sender
{
}
@end
