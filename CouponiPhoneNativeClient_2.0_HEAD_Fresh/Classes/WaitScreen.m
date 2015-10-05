//
//  WaitScreen.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/21/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "WaitScreen.h"


@implementation WaitScreen
- (void)viewWillAppear:(BOOL)animated{
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	//[appDelegate showActivityViewer];
	//[self sendCommandExecutionRequest];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:@"Do you want to restore last state" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];	
	[alert release];
	
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		[appDelegate.window bringSubviewToFront:self.view];
		//[appDelegate restoreState];
		
		//[self gpsOn];
	}
	else{
		[appDelegate.window sendSubviewToBack:self.view];
	}
	
}

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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
