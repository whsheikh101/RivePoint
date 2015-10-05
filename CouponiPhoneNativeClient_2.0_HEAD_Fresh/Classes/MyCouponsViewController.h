//
//  BrowseViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/12/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "SavedViewController.h"
#import "SharedCouponInbox.h"
#import "DeleteAllShared.h"

@interface MyCouponsViewController : UIViewController<UIAlertViewDelegate> {
	IBOutlet RivePointAppDelegate *appDelegate;
	SavedViewController *sViewController;
	SharedCouponInbox *sCInbox;
	DeleteAllShared *deleteAllShared;
}
- (void)confirmForDeletionAll:(BOOL)isConfirmed;
-(void) deleteAllCoupons;
- (int)getTotalCouponsCount;
@end
