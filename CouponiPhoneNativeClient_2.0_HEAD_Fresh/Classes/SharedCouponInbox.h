//
//  SharedCouponInbox.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Poi.h"
#import "SharedPoiListController.h"
#import "HTTPSupport.h"
@class RivePointAppDelegate;

@interface SharedCouponInbox : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPSupport,UIAlertViewDelegate> {
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UITableView *uiTableView;
	//Poi *poi;
	//CouponDetailViewController *cdController;
	//SCListCouponsViewController *sclController;
	SharedPoiListController *splController;
	BOOL shouldReturnToRoot;
	HttpTransportAdaptor *adaptor;
     BOOL isLoyaltyPoi;

}
@property BOOL isLoyaltyPoi;
-(void)setRightBarButton: (int)i;
- (void) dontReturnToRoot;
@end
