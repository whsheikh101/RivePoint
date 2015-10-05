//
//  FirstViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/05/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.

#import <UIKit/UIKit.h>
#import "PoiDtoGroup.h"
#import "PoiFinderNew.h"

@class RivePointAppDelegate;
@class ListCouponsViewController;

@interface BrowseVendorController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
	
	IBOutlet RivePointAppDelegate *appDelegate;
//	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	IBOutlet UILabel *paginationLabel;
//	IBOutlet UIToolbar *toolbar;
	ListCouponsViewController *cvController;
	
	BOOL shouldReturnToRoot;
	UIButton *nextButton;
	UIButton *previousButton;
	BOOL isNextRecord;
	BOOL isPreviousRecord;
	PoiFinderNew *finderForBrowse;
	
	int actualPOISInList;
	int indexCount;
	BOOL isAtLoadState;
	BOOL isMoreClicked;
	NSIndexPath *lastIndexPath;
    BOOL isGoingForword;
}

@property BOOL shouldReturnToRoot;
-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup;
-(void)setRightBarButton: (int)i;
-(void)submitFirstRequest;
- (void)persistState;
@end
