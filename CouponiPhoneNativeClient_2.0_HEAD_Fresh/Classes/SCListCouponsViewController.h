//
//  SCListCouponsViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Poi.h"
#import "Coupon.h"
//#import "ZXingWidgetController.h"
@class RivePointAppDelegate;
@class CouponViewController;
@class CouponViewCell;

@interface SCListCouponsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UITableView *uiTableView;
	IBOutlet UIImageView *poiDetailImageView;
	IBOutlet UILabel *vendorLabel;
	IBOutlet UILabel *addressLine1Label;
	IBOutlet UILabel *addressLine2Label;
    IBOutlet UILabel *userPointsLabel;
	IBOutlet UIButton *phoneBtn;
	IBOutlet UIImageView *bigLogoImageView;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UIButton *mapButton;
	Poi *poi;
	BOOL shouldReturnToRoot;
	NSMutableArray *couponsArray;
    CouponViewController *cvController;
    CouponViewCell *couponViewCell;
    Coupon *sharedCoupon;
    BOOL isLoyalty;
}
@property BOOL isLoyalty;
@property (nonatomic,retain) Coupon *sharedCoupon;
- (void) dontReturnToRoot;
-(IBAction)phoneClick;
-(IBAction)mapClick;
-(void)openZxingController;
-(void)setCouponViewCell:(CouponViewCell *)couponViewCell;
@end
