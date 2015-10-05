//
//  COTDViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/8/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "Coupon.h"
#import "Poi.h"
#import "CouponViewController.h"
#import "COTDOtherPoiViewController.h"
#import "ShareViewController.h"
#import "ShareIt.h"
#import "FeedbackManager.h"
#import "CouponDetailManager.h"


@interface COTDViewController : UIViewController <HTTPSupport,UIAlertViewDelegate> {
	RivePointAppDelegate *appDelegate;
	IBOutlet UIButton *previewButton;
	IBOutlet UIImageView *poiLogo;
	IBOutlet UILabel *vendorLabel;
	IBOutlet UILabel *addressLine1Label;
	IBOutlet UILabel *addressLine2Label;
	IBOutlet UILabel *couponTitleLabel;
	IBOutlet UILabel *couponSubTitleLabel;
	IBOutlet UILabel *redemtionLabel;
	IBOutlet UIButton *phoneBtn;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UIButton *alsoAvailableAtBtn;
	IBOutlet UIButton *mapButton;
	IBOutlet UIButton *redeemButton;
	IBOutlet UIButton *shareButton;
	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *feedBack;
	Poi *poi;
	Coupon *coupon;
	CouponViewController *cvController;
	COTDOtherPoiViewController *otherPoisvController;
	ShareViewController *shareViewController;
	HttpTransportAdaptor *adaptor;
	ShareIt *shareIt;
	FeedbackManager *feedbackManager;
	CouponDetailManager *couponDetailManager;
	
	IBOutlet UITabBarController *tabBarController;
	IBOutlet UINavigationController *browseNavigationController;
}
-(IBAction)phoneClick;
-(IBAction)mapClick;
-(IBAction)saveButton;
-(IBAction)redeemButton;
-(IBAction)otherPoisButton;
-(IBAction)shareCouponAction;
-(IBAction)couponFeedbackAction;
-(IBAction)onPreviewClick;
-(void)displayContent;
-(void) setPOI;
-(void) setCouponRedemptionDetails;
@end
