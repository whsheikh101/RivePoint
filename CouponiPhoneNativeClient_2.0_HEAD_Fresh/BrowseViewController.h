//
//  BrowseViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/12/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "BrowseVendorController.h"


@interface BrowseViewController : UIViewController {
	IBOutlet RivePointAppDelegate *appDelegate;
	IBOutlet BrowseVendorController *mvController;
}
-(IBAction) coffeeClick;
-(IBAction) americanClick;
-(IBAction) chineseClick;
-(IBAction) italianClick;
-(IBAction) ffoodClick;
-(IBAction) mexicanClick;
-(IBAction) snacksClick;
- (void) setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
-(void) runCatgoryAndGoForSelectedRow:(NSInteger )rowSelected;
@end
