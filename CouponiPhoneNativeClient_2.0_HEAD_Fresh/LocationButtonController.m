//
//  LocationUpdater.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "LocationButtonController.h"
#import "LocationUpdater.h"
#import "RivePointAppDelegate.h"

@implementation LocationButtonController
@synthesize locationButton;

-(IBAction)updateLocation{
    mvController.navigationItem.leftBarButtonItem = nil;
    RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showActivityViewer];
//    [appDelegate progressHudView:mvController.view andText:@"Updating..."];
	[locationUpdater updateLocation:mvController];
}

-(void)setReferenceController:(UIViewController *) reference{
	mvController = (MainViewController *)reference;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	locationUpdater = [appDelegate getLocationUpdatorInstance];
}
- (void) dealloc {

	[super dealloc];
}

@end
