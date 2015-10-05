//
//  CouponViewCell.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "RivePointAppDelegate.h"
#import "CouponViewController.h"
#import "ListCouponsViewController.h"
#import "ShareViewController.h"
#import "ShareIt.h"
#import "FeedbackManager.h"
#import "CouponDetailManager.h"
#import "XMLUtil.h"
#import "XMLPostRequest.h"
#import "SA_OAuthTwitterController.h"


@interface CouponViewCell : UITableViewCell<UIAlertViewDelegate, FBRequestDelegate,XMLPostRequestDelegates,SA_OAuthTwitterControllerDelegate,FBDialogDelegate> {
	
	ShareIt *shareIt;
	IBOutlet UILabel *couponLabel;
	IBOutlet UILabel *subTitleLabel;
	IBOutlet UILabel *expiryDateLabel;
	IBOutlet UIImageView *couponPrevPod;
	//IBOutlet UIImageView *couponPrevImage;
	IBOutlet UIButton *previewButton;
	
	IBOutlet UILabel *couponCountLabel;
	//IBOutlet UIImageView *couponCountImage;
	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *redeemButton;
	IBOutlet UIButton *deleteButton;
	Coupon *couponRef;
	RivePointAppDelegate *appDelegate;
	CouponViewController *cvController;
	ShareViewController *shareViewController;
	BOOL isSaved;
	BOOL isShared;
	int numberOfPOICoupons;
	UIViewController *viewController;
	int couponIndex;
	FeedbackManager *feedbackManager;
	CouponDetailManager *couponDetailManager;
	NSString *currCouponId;
    BOOL isCalled;
    XMLPostRequest * reqPost;
    BOOL isShouldSent;
	
}
@property int couponIndex;
@property BOOL isSaved;
@property BOOL isShared;
@property int numberOfPOICoupons;
@property (nonatomic, retain) IBOutlet UILabel *couponLabel;
@property (nonatomic, retain) NSString *currCouponId;

-(void) setCouponContent:(Coupon *) coupon;
-(void) setLabel:(NSString *) textStr; 
- (IBAction)saveButton;
- (IBAction)redeemButton;
- (IBAction)deleteButton;
-(IBAction)shareCouponAction;
-(IBAction)couponFeedbackAction;
-(IBAction)onPreviewClick;
- (void) setUIViewController: (UIViewController *) controller;
- (void)confirmForDeletion:(BOOL)isConfirmed;
-(void)setAttibutesOnLoad;

-(IBAction) onFacebookShareBtn;
-(IBAction) onTwitterShareBtn;
-(IBAction) onEmailBtn;

@end
