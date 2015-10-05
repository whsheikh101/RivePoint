//
//  ListCouponsViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Poi.h"
#import "Coupon.h"
//#import "ZXingWidgetController.h"
#import "HTTPSupport.h"


@class RivePointAppDelegate;
@class CouponViewCell;
@class CouponViewController;
@interface SavedListCouponsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
	int numberOfPOICoupons;
	
	
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UITableView *uiTableView;
	IBOutlet UIImageView *poiDetailImageView;
	IBOutlet UILabel *vendorLabel;
	IBOutlet UILabel *addressLine1Label;
	IBOutlet UILabel *addressLine2Label;
	IBOutlet UIButton *phoneBtn;
	IBOutlet UIImageView *bigLogoImageView;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UIButton *mapButton;
    IBOutlet UILabel *userPointsLabel;
	//Poi *poi;
    Coupon *savedCoupon;
	BOOL shouldReturnToRoot;
	NSMutableArray *savedCouponsArray;
    CouponViewController *cvController;
    CouponViewCell *couponViewCell;
	BOOL isLoyaltyPoi;
}
@property (nonatomic,retain) Poi *poi;
@property (nonatomic,retain) Coupon *savedCoupon;
@property BOOL isLoyaltyPoi;
- (void) dontReturnToRoot;
- (void) deleteCouponAtIndex: (int) index;
-(void)openZxingController;
-(void)setCouponViewCell:(CouponViewCell *)couponViewCell;
@end
