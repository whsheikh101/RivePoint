//
//  OverlayViewController .h
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/29/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchVendorController;

@interface OverlayViewController : UIViewController {
	UIViewController *searchVendorController;
}
-(void) setSearchVendorController:(UIViewController *)svendorController;
@end
