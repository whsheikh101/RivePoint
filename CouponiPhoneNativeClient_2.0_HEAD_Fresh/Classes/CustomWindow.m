//
//  CustomWindow.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 8/7/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CustomWindow.h"
#import "COTDViewController.h"

@implementation CustomWindow
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ( event.subtype == UIEventSubtypeMotionShake ){
		tabBarController.selectedViewController = cvc;
	}
	
}
- (void)dealloc {
 	[super dealloc];
}
@end
