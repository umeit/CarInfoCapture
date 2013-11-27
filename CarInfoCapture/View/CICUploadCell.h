//
//  CICUploadCell.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-27.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICUploadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *uploadActivityView;

@end
