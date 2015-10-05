//
//  QRCodeViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 6/6/11.
//  Copyright 2011 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZXingWidgetController.h"
#import "Poi.h"
#import "CouponViewCell.h"
#import "Coupon.h"
#import "CouponViewController.h"

@class RivePointAppDelegate;

@interface QRCodeViewController : UIViewController{
    
    RivePointAppDelegate *appDelegate;
    CouponViewController *cvController;
    Poi *poi;
    Coupon *coupon;
    CouponViewCell *couponViewCell;
    
}
@property(nonatomic,retain) Coupon *coupon;
-(void)openZxingController;
-(void)setCouponViewCell:(CouponViewCell *)couponViewCell;

@end
