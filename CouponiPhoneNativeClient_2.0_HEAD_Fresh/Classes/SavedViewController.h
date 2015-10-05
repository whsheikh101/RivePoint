//
//  SavedViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SavedListCouponsViewController.h"
@class RivePointAppDelegate;

@interface SavedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
   IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet UIView *gpsView;
	IBOutlet UITableView *uiTableView;
	IBOutlet UIBarButtonItem *nextButton;
	IBOutlet UIBarButtonItem *previousButton;
	IBOutlet UILabel *paginationLabel;
	IBOutlet UIBarButtonItem *zipCodeLabel;
	IBOutlet UIToolbar *toolbar;
	SavedListCouponsViewController *slcvController;
	NSArray *savedPoisArray;
    BOOL loyaltyPoi;
}
@property BOOL loyaltyPoi;
@end
