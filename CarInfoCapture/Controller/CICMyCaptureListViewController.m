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
#import "CICMainCaptureViewController.h"
#import "UIViewController+Prompt.h"
#import "CICUserService.h"

@interface CICMyCaptureListViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtton;

@property (weak, nonatomic) IBOutlet UILabel *captureSum;

@property (weak, nonatomic) IBOutlet UILabel *noUploadNumber;

@property (strong, nonatomic) NSArray *carInfoList;

@property (strong, nonatomic) CICCarInfoService *carInfoService;
@property (strong, nonatomic) CICUserService *userService;

@property (strong, nonatomic) NSString *currentShowMainDate;
@property (strong, nonatomic) NSString *currentShowSubDate;

@end

@implementation CICMyCaptureListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userService = [[CICUserService alloc] init];
        self.carInfoService = [[CICCarInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self autoLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showLodingViewWithText:@"正在获取您的历史采集记录"];
    [self.carInfoService carInfoListWithBlock:^(NSArray *list, NSError *error) {
        [self hideLodingView];
        
        if (!error && list && [list count] > 0) {
            self.carInfoList = list;
            
            self.currentShowMainDate = @"";
            self.currentShowSubDate = @"";
            [self.tableView reloadData];
        }
        
        [self.carInfoService sumOfCarInfoAndNeedUploadCarInfoWithBlock:^(NSInteger sum, NSInteger needUpload) {
            self.captureSum.text = [NSString stringWithFormat:@"%ld", (long)sum];
            self.noUploadNumber.text = [NSString stringWithFormat:@"%ld", (long)needUpload];
            
            if (needUpload == 0) {
                self.uploadBtton.hidden = YES;
            } else {
                self.uploadBtton.hidden = NO;
            }
        }];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CICMainCaptureViewController class]]) {
        CICMainCaptureViewController *mainCaptureViewController = segue.destinationViewController;
        mainCaptureViewController.carInfoEntity = self.carInfoList[[self.tableView indexPathForSelectedRow].row];
    }
}

- (void)toLoginView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"currentLoginedUserID"];
    [userDefaults removeObjectForKey:@"currentLoginedPassword"];
    
    self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CICLoginViewController"];
}

#pragma mark - Configure Cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CICCarInfoCell *carInfoCell = (CICCarInfoCell *)cell;
    CICCarInfoEntity *carInfoEntity = self.carInfoList[indexPath.row];
    
    [self configureCarInfoStatusWithCell:carInfoCell carInfoEntity:carInfoEntity];
    [self configureCarInfoDateWithCell:carInfoCell carInfoEntity:carInfoEntity atIndexPath:indexPath];
    
    [carInfoCell setCarName:carInfoEntity.carName
                    mileage:carInfoEntity.mileage
               firstRegTime:carInfoEntity.firstRegTime
                  salePrice:carInfoEntity.salePrice
                   carImage:carInfoEntity.carImage];
}

- (void)configureCarInfoStatusWithCell:(CICCarInfoCell *)carInfoCell carInfoEntity:(CICCarInfoEntity *)carInfoEntity
{
    switch (carInfoEntity.status) {
        case Uploaded:
            carInfoCell.infoStatus.text = @"已上传";
            carInfoCell.infoStatus.textColor = [UIColor greenColor];
            carInfoCell.accessoryType = UITableViewCellAccessoryNone;
            carInfoCell.userInteractionEnabled = NO;
            break;
            
        case NoUpload:
            carInfoCell.infoStatus.text = @"未上传";
            carInfoCell.infoStatus.textColor = [UIColor redColor];
            carInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            carInfoCell.userInteractionEnabled = YES;
            break;
            
        default:
            carInfoCell.infoStatus.text = @"异常状态";
            carInfoCell.accessoryType = UITableViewCellAccessoryNone;
            carInfoCell.userInteractionEnabled = NO;
            break;
    }
}

- (void)configureCarInfoDateWithCell:(CICCarInfoCell *)carInfoCell
                       carInfoEntity:(CICCarInfoEntity *)carInfoEntity
                         atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0
        || row == ([self.carInfoList count]-1)) {
        self.currentShowMainDate = @"";
    }
    
    NSString *showMainDate;
    NSString *showSubDate;
    
    // 处理「今天」的
    if ([self isToday:carInfoEntity.addTime]) {
        showMainDate = @"今天";
        
        if ([self.currentShowMainDate isEqualToString:showMainDate]) {
            carInfoCell.MainTime.text = @"";
            carInfoCell.subTime.text = @"";
        }
        else {
            carInfoCell.MainTime.text = showMainDate;
            carInfoCell.subTime.text = @"";
            
            self.currentShowMainDate = showMainDate;
        }
        
        // 处理本年本月的
    } else if ([self isThisMonth:carInfoEntity.addTime]) {
        showMainDate = [self getDay:carInfoEntity.addTime];
        showSubDate = [self getMonth:carInfoEntity.addTime];
        
        if ([self.currentShowMainDate isEqualToString:showMainDate]) {
            carInfoCell.MainTime.text = @"";
            carInfoCell.subTime.text = @"";
        }
        else {
            carInfoCell.MainTime.text = showMainDate;
            carInfoCell.subTime.text = [NSString stringWithFormat:@"%@月", showSubDate];
            
            self.currentShowMainDate = showMainDate;
        }
    }
    
}

#pragma mark - Login

- (void)autoLogin
{
    if (self.userID && self.password) {
        
        [self showLodingView];
        
        [self.userService loginWithUserID:self.userID
                                 password:self.password
                                    block:^(CICUserServiceRetCode retCode) {
                                        
                                        [self hideLodingView];
                                        
                                        switch (retCode) {
                                            case CICUserServiceNetworkingError:
                                                [self showCustomTextAlert:@"登录失败，您暂时只能采集信息，不能上传信息"];
                                                break;
                                                
                                            case CICUserServiceServerError:
                                                [self showCustomTextAlert:@"登录出错，您暂时只能采集信息，不能上传信息"];
                                                break;
                                                
                                            case CICUserServiceUserIDError:
                                            {
                                                [self showCustomTextAlert:@"请重新登录" withBlock:^{
                                                    [self toLoginView];
                                                }];
                                            }
                                                break;
                                                
                                            case CICUserServicePasswordError:
                                            {
                                                [self showCustomTextAlert:@"请重新登录" withBlock:^{
                                                    [self toLoginView];
                                                }];
                                            }
                                                break;
                                                
                                            default:
                                                [self showCustomTextAlert:@"登录出错，您暂时只能采集信息，不能上传信息"];
                                                break;
                                        }
                                    }];
    }
}

#pragma mark - Previte

- (BOOL)isToday:(NSString *)dateStr
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger today = comps.day;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger addDay = comps.day;
    
    return (today == addDay);
}

- (BOOL)isThisMonth:(NSString *)dateStr
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger thisMonth = comps.month;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger addMonth = comps.month;
    
    return (thisMonth == addMonth);
}

- (NSString *)getDay:(NSString *)dateStr
{
    NSString *str = [dateStr componentsSeparatedByString:@" "][0];
    return [str componentsSeparatedByString:@"-"][2];
}

- (NSString *)getMonth:(NSString *)dateStr
{
    NSString *str = [dateStr componentsSeparatedByString:@" "][0];
    return [str componentsSeparatedByString:@"-"][1];
}
- (void)updateView
{
    self.currentShowMainDate = @"";
    self.currentShowSubDate = @"";
    
    [self.tableView reloadData];
    
    [self.carInfoService sumOfCarInfoAndNeedUploadCarInfoWithBlock:^(NSInteger sum, NSInteger needUpload) {
        self.captureSum.text = [NSString stringWithFormat:@"%ld", (long)sum];
        self.noUploadNumber.text = [NSString stringWithFormat:@"%ld", (long)needUpload];
        
        if (needUpload == 0) {
            self.uploadBtton.hidden = YES;
        } else {
            self.uploadBtton.hidden = NO;
        }
    }];
}
@end
