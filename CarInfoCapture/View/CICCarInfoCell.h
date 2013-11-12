//
//  CICCarInfoCell.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICCarInfoCell : UITableViewCell

- (void)setCarName:(NSString *)carName mileage:(NSString *)mileage firstRegTime:(NSString *)firstRegTime salePrice:(NSString *)salePrice carImage:(UIImage *)carImage infoStatus:(NSString *)infoStatus;

@end
