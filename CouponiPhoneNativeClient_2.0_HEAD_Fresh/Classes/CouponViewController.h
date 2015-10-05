//
//  CouponViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/3/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "HTTPSupport.h"
#import "CustomUIImageView.h"
#import "ZBarReaderController.h"
#import "ZBarHelpController.h"
#import "XMLPostRequest.h"

@interface CouponViewController : UIViewController <HTTPSupport,UIAlertViewDelegate ,ZBarReaderDelegate,XMLPostRequestDelegates> {
	IBOutlet UIImageView *imageView;
	IBOutlet RivePointAppDelegate *appDelegate;
	BOOL isSaved;
	//IBOutlet UIButton *saveUIButton;
	//IBOutlet UIButton *deleteUIButton;
	//IBOutlet UILabel *redemptionCodeLabel;
	IBOutlet UIView *parentView;
	IBOutlet CustomUIImageView *couponView;
	IBOutlet CustomUIImageView *detailView;
	IBOutlet CustomUIImageView *reflectedView;
	IBOutlet UIView *containerView;
	
	IBOutlet UILabel *titleLbl;
	IBOutlet UILabel *subTitle1Lbl;
	IBOutlet UILabel *subTitle2Lbl;
	IBOutlet UILabel *expiryLabel;
	IBOutlet UILabel *vendorNameLbl;
	IBOutlet UILabel *addressLbl;
	IBOutlet UILabel *redeemLbl;
	//IBOutlet UILabel *phoneNoLbl;
	IBOutlet UIButton *phoneButton;
	
	
	UIButton *flipIndicatorButton;
	BOOL isDelete;
	BOOL frontViewIsVisible;
	int numberOfPOICoupons;
	HttpTransportAdaptor *adaptor;
	Coupon *selectedCoupon;
	Poi *redeemPoi;	
    BOOL isLoyaltyPoi;
    BOOL isShared;
    IBOutlet UIButton * redeemCoupBtn;
    Coupon * couponToRedeem;
    BOOL isRedeemScreenCall;
    BOOL isQRRedeem;
    UIImage * curQRImage;
    XMLPostRequest * postReq;
}
@property BOOL isSaved;
@property BOOL isShared;
@property int numberOfPOICoupons;
@property BOOL isLoyaltyPoi;
@property (nonatomic , retain) Coupon * currCoupon;
@property (nonatomic , retain) Poi * curPOI;

@property (nonatomic,retain) UIButton *flipIndicatorButton;
@property (nonatomic,retain) IBOutlet UIButton *phoneButton; 
-(IBAction)saveButtonAction;
-(IBAction)deleteCoupon;
-(IBAction)phoneNumberClicked;
- (void)flipCurrentView;
-(void) loadDetails;
-(void) clearDetailLabels;

-(IBAction) onRedeemCouponBtn;

@end
