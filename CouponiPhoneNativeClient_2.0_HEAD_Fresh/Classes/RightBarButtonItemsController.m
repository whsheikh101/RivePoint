//
//  RightBarItemController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "RightBarButtonItemsController.h"


@implementation RightBarButtonItemsController

@synthesize nextButton;
@synthesize prevButton;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[nextButton setImage:[UIImage imageNamed:@"rigntBarItem_next_btn_ov.png"] forState:UIControlStateHighlighted];
	[prevButton setImage:[UIImage imageNamed:@"rigntBarItem_prev_btn_ov.png"] forState:UIControlStateHighlighted];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
