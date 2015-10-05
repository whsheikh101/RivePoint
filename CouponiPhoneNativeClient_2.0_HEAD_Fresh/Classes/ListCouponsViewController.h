//
//  ListCouponsViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Poi.h"
#import "HTTPSupport.h"
#import "CouponViewCell.h"
#import "BrowseVendorController.h"
#import "XMLPostRequest.h"
//#import "ZXingWidgetController.h"
@class RivePointAppDelegate;
@class MapViewController;
@class CouponViewController;
@class CouponViewCell;
#import "SA_OAuthTwitterController.h"
#import "ReviewRatingViewController.h"

@interface ListCouponsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPSupport,UIAlertViewDelegate,NSURLConnectionDelegate,XMLPostRequestDelegates,SA_OAuthTwitterControllerDelegate,ReviewAddedDelegate> {
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
	Poi *poi;
	BOOL shouldReturnToRoot;
	HttpTransportAdaptor *adaptor;
	BrowseVendorController *browseVendorController;
	MapViewController *mapViewController;
	BOOL isMapClick;
    Coupon *coupon;
    CouponViewController *cvController;
    CouponViewCell *couponViewCell;
    BOOL isArranged;
    IBOutlet UIImageView * ratingImageView;

}
@property (nonatomic)BOOL isFavoritePOI;
@property (nonatomic,retain) Coupon *coupon;
@property (nonatomic , retain) Poi * curPOI;
@property (nonatomic, retain) IBOutlet UILabel * reviewCountLbl;

-(void)setRightBarButton: (int)i;
- (void) dontReturnToRoot;
-(IBAction)phoneClick;
-(IBAction)mapClick;
- (void) persistToNSUserDefaults;
-(void)setBrowseVendorController:(BrowseVendorController *)controller;
-(void)openZxingController;
-(void)setCouponViewCell:(CouponViewCell *)couponViewCell;

-(IBAction) onSharePhotoClick;
-(IBAction) onFavoriteClick;
-(IBAction) onRatingClick;
-(void) callLoginPageToRP;

@end
