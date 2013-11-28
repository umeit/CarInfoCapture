//
//  CICUploadViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-27.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICUploadViewController.h"
#import "CICCarInfoService.h"
#import "CICUploadCell.h"
#import "CICCarInfoEntity.h"

@interface CICUploadViewController () <UITableViewDataSource, UIAlertViewDelegate, CICCarInfoServiceUploadCarInfoDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *cancelButton;

@property (strong, nonatomic) CICCarInfoService *carInfoService;

@property (strong, nonatomic) NSArray *carInfoList;

@property (nonatomic) BOOL isUploading;
@end

@implementation CICUploadViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.carInfoService = [[CICCarInfoService alloc] init];
        self.carInfoService.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.carInfoService nouploadCarInfoListWithBlock:^(NSArray *list, NSError *error) {
        self.carInfoList = list;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.carInfoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICUploadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:(CICUploadCell *)cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Previte

- (void)configureCell:(CICUploadCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CICCarInfoEntity *carInfoEntity = self.carInfoList[indexPath.row];
    cell.carNameLabel.text = carInfoEntity.carName;
    
    if (self.isUploading) {
        [cell.uploadActivityView startAnimating];
        cell.uploadActivityView.hidden = NO;
    }
    else {
        [cell.uploadActivityView stopAnimating];
        cell.uploadActivityView.hidden = YES;
    }
}

#pragma mark - Action

- (IBAction)uploadButtonPress:(id)sender
{
    self.isUploading = YES;
    
    self.uploadButton.userInteractionEnabled = NO;
    
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CICUploadCell *cell = obj;
        
        [cell.uploadActivityView startAnimating];
        cell.uploadActivityView.hidden = NO;
    }];
    
    [self.carInfoService uploadCarInfoWithBlock:^(NSError *error) {
        if (!error) {
            
            
        }
    }];
}

- (IBAction)cancelButtonPress:(id)sender
{
    if (self.isUploading) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"正在上传车辆信息，您确定要取消上传吗？"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"继续等待"
//                                                  otherButtonTitles:@"取消上传", nil];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"正在上传车辆信息，请稍后"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 取消上传
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - CICCarInfoServiceUploadCarInfoDelegate

- (void)carInfoDidUploadAtIndex:(NSInteger)index
{
    CICUploadCell *cell = (CICUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                    inSection:0]];
    [cell.uploadActivityView stopAnimating];
    cell.uploadActivityView.hidden = YES;
    cell.carImageView.image = [UIImage imageNamed:@"uploadSuccess"];
}

- (void)carInfoDidUploadForAll
{
    
}

- (void)carInfoUploadDidFailAtIndex:(NSInteger)index
{
    CICUploadCell *cell = (CICUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                    inSection:0]];
    [cell.uploadActivityView stopAnimating];
    cell.uploadActivityView.hidden = YES;
    cell.carImageView.image = [UIImage imageNamed:@"uploadFail"];
}
@end
