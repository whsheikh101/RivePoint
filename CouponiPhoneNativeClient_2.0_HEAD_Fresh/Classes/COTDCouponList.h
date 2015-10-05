//
//  ListCouponsViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/1/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Poi.h"
#import "HTTPSupport.h"
@class RivePointAppDelegate;

@interface COTDCouponList : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPSupport> {
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
	Poi *poi;
	BOOL shouldReturnToRoot;
	HttpTransportAdaptor *adaptor;

}
-(void)setRightBarButton: (int)i;
- (void) dontReturnToRoot;
-(IBAction)phoneClick;
-(IBAction)mapClick;
@end
