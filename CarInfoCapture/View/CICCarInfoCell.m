//
//  CICCarInfoCell.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-11.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "CICCarInfoCell.h"

@interface CICCarInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *mileage;
@property (weak, nonatomic) IBOutlet UILabel *firstRegTime;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carID;
@end

@implementation CICCarInfoCell

- (void)setCarName:(NSString *)carName
           mileage:(NSString *)mileage
      firstRegTime:(NSString *)firstRegTime
         salePrice:(NSString *)salePrice
          carImage:(UIImage *)carImage
             carID:(NSString *)carID
{
    self.carName.text = carName;
    self.mileage.text = mileage;
    self.firstRegTime.text = firstRegTime;
    self.salePrice.text = salePrice;
    self.carImage.image = carImage;
    self.carID.text = carID;
}

@end
