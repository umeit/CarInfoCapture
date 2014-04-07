//
//  CICCarInfoCell.h
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICCarInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MainTime;
@property (weak, nonatomic) IBOutlet UILabel *subTime;
@property (weak, nonatomic) IBOutlet UILabel *infoStatus;

- (void)setCarName:(NSString *)carName
           mileage:(NSString *)mileage
      firstRegTime:(NSString *)firstRegTime
         salePrice:(NSString *)salePrice
          carImage:(UIImage *)carImage
             carID:(NSString *)carID;

@end
