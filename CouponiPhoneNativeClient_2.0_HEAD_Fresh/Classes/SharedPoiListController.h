//
//  SharedPoiListController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "SCListCouponsViewController.h"
@class RivePointAppDelegate;


@interface SharedPoiListController : UIViewController <UITableViewDataSource, UITableViewDelegate, HTTPSupport> {
   IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	IBOutlet UIBarButtonItem *nextButton;
	IBOutlet UIBarButtonItem *previousButton;
	IBOutlet UILabel *paginationLabel;
	IBOutlet UIBarButtonItem *zipCodeLabel;
	IBOutlet UIToolbar *toolbar;
	SCListCouponsViewController *slcvController;
	HttpTransportAdaptor *adaptor;
    BOOL isLoyalty;
}
@property BOOL isLoyalty;
-(void)setRightBarButton: (int)i;

@end
