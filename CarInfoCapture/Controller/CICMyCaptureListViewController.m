//
//  CICMyCaptureListViewController.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICMyCaptureListViewController.h"
#import "CICCarInfoService.h"
#import "CICCarInfoCell.h"
#import "CICCarInfoEntity.h"

@interface CICMyCaptureListViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtton;

@property (weak, nonatomic) IBOutlet UILabel *captureSum;

@property (weak, nonatomic) IBOutlet UILabel *noUploadNumber;

@property (strong, nonatomic) NSArray *carInfoList;

@property (strong, nonatomic) CICCarInfoService *carInfoService;

- (IBAction)uploadButtonPress:(id)sender;

@end

@implementation CICMyCaptureListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.carInfoService = [[CICCarInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.carInfoService carInfoListWithBlock:^(NSArray *list, NSError *error) {
        if (!error && list && [list count] > 0) {
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.carInfoService sumOfCarInfoAndNeedUploadCarInfoWithBlock:^(NSInteger sum, NSInteger needUpload) {
        self.captureSum.text = [NSString stringWithFormat:@"%d", sum];
        self.noUploadNumber.text = [NSString stringWithFormat:@"%d", needUpload];
        
        if (needUpload == 0) {
            self.uploadBtton.hidden = YES;
        } else {
            self.uploadBtton.hidden = NO;
        }
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
    static NSString *CellIdentifier = @"CarInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Previte

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CICCarInfoCell *carInfoCell = (CICCarInfoCell *)cell;
    CICCarInfoEntity *carInfoEntity = self.carInfoList[indexPath.row];

    NSString *infoStatus;
    switch (carInfoEntity.status) {
        case 0:
            infoStatus = @"已上传";
            break;

        case 1:
            infoStatus = @"未上传";
            break;

        default:
            infoStatus = @"异常状态";
            break;
    }

    [carInfoCell setCarName:carInfoEntity.carName
                    mileage:[NSString stringWithFormat:@"%lu", (unsigned long)carInfoEntity.mileage]
               firstRegTime:carInfoEntity.firstRegTime
                  salePrice:[NSString stringWithFormat:@"%f", carInfoEntity.salePrice]
                   carImage:carInfoEntity.carImage
                 infoStatus:infoStatus];
}

- (void)updateView
{
    [self.carInfoService uploadCarInfoWithBlock:^(NSError *error) {
        [self.tableView reloadData];
    }];
    
    [self.carInfoService sumOfCarInfoAndNeedUploadCarInfoWithBlock:^(NSInteger sum, NSInteger needUpload) {
        self.captureSum.text = [NSString stringWithFormat:@"%d", sum];
        self.noUploadNumber.text = [NSString stringWithFormat:@"%d", needUpload];
        
        if (needUpload == 0) {
            self.uploadBtton.hidden = YES;
        } else {
            self.uploadBtton.hidden = NO;
        }
    }];
}

#pragma mark - Action

- (IBAction)uploadButtonPress:(id)sender
{
    [self.carInfoService uploadCarInfoWithBlock:^(NSError *error) {
        if (!error) {
            [self updateView];
        }
    }];
}
@end
