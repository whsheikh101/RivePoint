//
//  FirstViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiDtoGroup.h"

@class RivePointAppDelegate;
@class ListCouponsViewController;
@class PoiFinderNew;
@class LocationButtonController;
@class MapViewController;
@class MapButtonController;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	IBOutlet UILabel *paginationLabel;
	IBOutlet UIBarButtonItem *zipCodeLabel;
	IBOutlet UIToolbar *toolbar;
	IBOutlet ListCouponsViewController *cvController;
	PoiFinderNew *getCouponFinder;
	BOOL isNext;
	BOOL isPrevious;
	//PoiDtoGroup *poiDtoGroup;
	UIButton *nextButton;
	UIButton *previousButton;
	BOOL isRequestInProgress;
	int actualPOISInList;
	int indexCount;
	BOOL isAtLoadState;
	BOOL isMoreClicked;
	NSIndexPath *lastIndexPath;
	LocationButtonController *locationButtonControllerRef;
	UIBarButtonItem *locationBarItem;
	UIBarButtonItem *mapBarButtonItem;
	MapButtonController *mapButtonController;
		
	
}


-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup;

-(void)setRightBarButton: (int)i;
-(void)submitFirstRequest;
-(void)setLocationButton;
- (void)persistState;
-(void)refreshRecords;
-(void)setLeftBarButton;
-(void) flushToRootOnTabChange;

@end
