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
	
    [self.carInfoService noUploadCarInfoListWithBlock:^(NSArray *list, NSError *error) {
        self.carInfoList = list;
        
        if (!list && ![list count] > 0) {
            self.uploadButton.userInteractionEnabled = NO;
        }
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
    
    // 「上传中」动画的显示与隐藏
    if (self.isUploading && carInfoEntity.status == NoUpload) {
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
    
    [self.carInfoService uploadCarInfoList:self.carInfoList];
}

- (IBAction)cancelButtonPress:(id)sender
{
    if (self.isUploading) {
        [self showCustomTextAlert:@"正在上传车辆信息，请稍后"];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CICCarInfoServiceUploadCarInfoDelegate

- (void)carInfoDidUploadAtIndex:(NSInteger)index
{
    CICCarInfoEntity *carInfo = self.carInfoList[index];
    carInfo.status = Uploaded;
    
    CICUploadCell *cell = (CICUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                    inSection:0]];
    [cell.uploadActivityView stopAnimating];
    cell.uploadActivityView.hidden = YES;
    cell.carImageView.image = [UIImage imageNamed:@"upload_finish"];
    
    // 全部上传成功
    if ([self.carInfoList count] == (index + 1)) {
        self.isUploading = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"上传完成！"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)carInfoUploadDidFailAtIndex:(NSInteger)index
{
    CICUploadCell *cell = (CICUploadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                    inSection:0]];
    [cell.uploadActivityView stopAnimating];
    cell.uploadActivityView.hidden = YES;
    cell.carImageView.image = [UIImage imageNamed:@"upload_fail"];
}
@end
