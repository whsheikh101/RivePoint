//
//  FeedbackAlertController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "FeedbackAlertController.h"
#import "FeedbackManager.h"

@implementation FeedbackAlertController

@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize rate;
@synthesize rateType;
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
	star1.backgroundColor = [UIColor clearColor];
	star2.backgroundColor = [UIColor clearColor];
	star3.backgroundColor = [UIColor clearColor];
	star4.backgroundColor = [UIColor clearColor];
	star5.backgroundColor = [UIColor clearColor];
	reportButton.backgroundColor =[UIColor clearColor];
	[star1 addTarget:self action:@selector(onStar1Clicked) forControlEvents:UIControlEventTouchUpInside];
	[star2 addTarget:self action:@selector(onStar2Clicked) forControlEvents:UIControlEventTouchUpInside];
	[star3 addTarget:self action:@selector(onStar3Clicked) forControlEvents:UIControlEventTouchUpInside];
	[star4 addTarget:self action:@selector(onStar4Clicked) forControlEvents:UIControlEventTouchUpInside];
	[star5 addTarget:self action:@selector(onStar5Clicked) forControlEvents:UIControlEventTouchUpInside];
	[reportButton addTarget:self action:@selector(onBrokenClicked) forControlEvents:UIControlEventTouchUpInside];
	
	
	
	//[nextButton setImage:[UIImage imageNamed:@"rigntBarItem_next_btn_ov.png"] forState:UIControlStateHighlighted];
	//[prevButton setImage:[UIImage imageNamed:@"rigntBarItem_prev_btn_ov.png"] forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated{
	[self setImageRating:rate];
	ratingLabel.text = [NSString stringWithFormat:@"%d",rate];
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
-(IBAction) onStar1Clicked{
	rate = 1;
	rateType = 1;
	[self setImageRating:rate];
	//[feedbackManager sendCommandExecutionRequest:@"1" rating:@"1"];
	
}
-(IBAction) onStar2Clicked{
	rate = 2;
	rateType = 1;
	[self setImageRating:rate];
	//[feedbackManager sendCommandExecutionRequest:@"1" rating:@"2"];
	
}
-(IBAction) onStar3Clicked{
	rate = 3;
	rateType = 1;
	[self setImageRating:rate];
	//[feedbackManager sendCommandExecutionRequest:@"1" rating:@"3"];
	
}
-(IBAction) onStar4Clicked{
	rate = 4;
	rateType = 1;
	[self setImageRating:rate];
	//[feedbackManager sendCommandExecutionRequest:@"1" rating:@"4"];
	
}
-(IBAction) onStar5Clicked{
	rate = 5;
	rateType = 1;
	[self setImageRating:rate];
	//[feedbackManager sendCommandExecutionRequest:@"1" rating:@"5"];
	
}
-(IBAction) onBrokenClicked{
	//rate = 0;
	rateType = 2;
	//[self setImageRating:rate];
	[feedbackManager sendCommandExecutionRequest:@"2" rating:@"0"];
}
-(void) setImageRating:(int)rating{
	
	switch (rating) {
		case 1:
			
			star1.imageView.image = [UIImage imageNamed:@"star_yellow_voted.png"];
			star2.imageView.image = star3.imageView.image = star4.imageView.image = star5.imageView.image
			= [UIImage imageNamed:@"star_grey_empty.png"];
			
			break;
		case 2:
			
			star1.imageView.image = star2.imageView.image
			= [UIImage imageNamed:@"star_yellow_voted.png"];
			
			star3.imageView.image = star4.imageView.image = star5.imageView.image
			= [UIImage imageNamed:@"star_grey_empty.png"];
			break;
		case 3:
			
			star1.imageView.image = star2.imageView.image = star3.imageView.image
			= [UIImage imageNamed:@"star_yellow_voted.png"];
			
			star4.imageView.image = star5.imageView.image 
			= [UIImage imageNamed:@"star_grey_empty.png"];
			
			break;
		case 4:
			
			star1.imageView.image = star2.imageView.image = star3.imageView.image = star4.imageView.image
			= [UIImage imageNamed:@"star_yellow_voted.png"];
			
			star5.imageView.image = [UIImage imageNamed:@"star_grey_empty.png"];
			
			break;
		case 5:
			
			star1.imageView.image = star2.imageView.image = star3.imageView.image 
			= star4.imageView.image = star5.imageView.image
			= [UIImage imageNamed:@"star_yellow_voted.png"];
			break;
			
		default:
			star1.imageView.image = star2.imageView.image = star3.imageView.image 
			= star4.imageView.image = star5.imageView.image
			= [UIImage imageNamed:@"star_grey_empty.png"];;
	}
}

-(void) setFeedbackManagerRef:(FeedbackManager *)fm{
	feedbackManager = fm;
	
}
- (void)dealloc {
    [super dealloc];
}


@end
