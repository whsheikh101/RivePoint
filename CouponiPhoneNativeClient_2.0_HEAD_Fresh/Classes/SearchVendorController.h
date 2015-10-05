//
//  SearchVendorController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/05/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.

#import <UIKit/UIKit.h>
#import "PoiDtoGroup.h"
#import "OverlayViewController.h"
#import "PoiFinderNew.h"
@class RivePointAppDelegate;
@class ListCouponsViewController;


@interface SearchVendorController : UIViewController <UITableViewDataSource, UITableViewDelegate,
				UITextFieldDelegate, UISearchBarDelegate> {

	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	UIButton *nextButton;
	UIButton *previousButton;
	IBOutlet ListCouponsViewController *cvController;
	BOOL shouldReturnToRoot;
	IBOutlet UISearchBar *searchBar;
	OverlayViewController *ovController ;
	PoiFinderNew *finderForSearch;
	BOOL isNextEnabled;
	BOOL isPreviousEnabled;
	BOOL isSuggestionsAvailable;
	PoiDtoGroup *poiDtoGroup;
	NSArray *suggestionArray;
	int count;
	int actualPOISInList;
	int indexCount;
	BOOL isAtLoadState;
	BOOL isMoreClicked;
	
	NSIndexPath *lastIndexPath;
}
@property (nonatomic,retain) NSArray *suggestionArray;
@property BOOL shouldReturnToRoot;

- (void)displayResultDto:(PoiDtoGroup *) poiDtoGroup;
- (void)submitFirstRequest;
- (void)hideOverlay;
- (void)setRightBarButton: (int)i;
- (void)onClickUpdateRecords;
- (void)persistState;
-(void) flushToRootOnTabChange;
@end
