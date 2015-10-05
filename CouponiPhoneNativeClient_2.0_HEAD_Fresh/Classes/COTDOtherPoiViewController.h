//
//  COTDOtherPoiViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiDtoGroup.h"
#import "PoiFinderNew.h"
#import "PoiDtoGroup.h"
@class RivePointAppDelegate;
@class ListCouponsViewController;

@interface COTDOtherPoiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
	//ListCouponsViewController *cvController;
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	IBOutlet UILabel *paginationLabel;
	IBOutlet UIBarButtonItem *zipCodeLabel;
	IBOutlet UIToolbar *toolbar;
	IBOutlet ListCouponsViewController *cvController;
	PoiFinderNew *finder;
	BOOL isNext;
	BOOL isPrevious;
	//PoiDtoGroup *poiDtoGroup;
	UIButton *nextButton;
	UIButton *previousButton;
	BOOL isRequestInProgress;
	int index;
}
-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup;
- (IBAction)nextOption;
- (IBAction)previousOption;
- (IBAction)testClick;
-(void)setButtonsEnabled: (BOOL)previous nextButton:(BOOL)next;
-(void)setRightBarButton: (int)i;



@end
