//
//  FirstViewController.h
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

@interface ExternalPoiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
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
}
-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup;
- (IBAction)nextOption;
- (IBAction)previousOption;
- (IBAction)testClick;
-(void)setRightBarButton: (int)i;
-(void)setButtonsEnabled: (BOOL)previous nextButton:(BOOL)next;

//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end
