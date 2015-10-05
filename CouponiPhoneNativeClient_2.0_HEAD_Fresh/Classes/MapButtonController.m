//
//  MapButtonController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/24/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "MapButtonController.h"
#import "MapViewController.h"

@implementation MapButtonController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)setReferenceController:(UIViewController *) reference{
	mvController = (MainViewController *)reference;
}

-(IBAction)mapAllPois{
	if(mapViewController){
		mapViewController = nil;
	}
    mapViewController = [[MapViewController alloc] initWithNibName:@"Maps" bundle:nil];
	[mapViewController setMainViewController:mvController];
	[[mvController navigationController] presentModalViewController:mapViewController animated:YES];
    [mapViewController release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    NSLog(@"MapViewButton  didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    NSLog(@"MapViewButton  viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[mapViewController release];
	[mvController release];
    [super dealloc];
}


@end
