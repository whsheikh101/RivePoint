#import "CouponDetailViewController.h"
#import "GeneralUtil.h"
#import "PoiUtil.h"

@implementation CouponDetailViewController
@synthesize phoneButton;

- (void) setDetails:(Coupon *) coupon withPoi:(Poi *)poi {
	
	if([poi.isSponsored isEqualToString:@"true"]){
		distanceLabel.text = @"";
		distanceShowLabel.text = @"";
	}
	else{
		distanceShowLabel.text = @"Distance:";
        if (poi.distance.length > 4) {
            distanceLabel.text = [NSString stringWithFormat:@"%@ miles", [poi.distance substringToIndex:4]];
        }
        else
            distanceLabel.text = [NSString stringWithFormat:@"%@ miles", poi.distance];
	}
	addressLabel.text = poi.completeAddress;
//	expiryLabel.text = [GeneralUtil getLongFormatDate:coupon.validTo];
    
    if ([coupon.validTo rangeOfString:@"/"].location == NSNotFound) {
        expiryLabel.text = [GeneralUtil getLongFormatDate:coupon.validTo];
    } else {
        expiryLabel.text = coupon.validTo;
    }
    
	phoneLabel.text = poi.phoneNumber;
	//[self.phoneButton setTitle:poi.phoneNumber forState:UIControlStateNormal];
	NSMutableString *title = [[NSMutableString alloc] initWithString:@""];
	BOOL onlyTitle = NO;
	if(coupon.title && ![coupon.title isEqualToString:@"null"]){
		[title appendString:coupon.title];
		onlyTitle = YES;
	}

	if(coupon.subTitleLineOne && ![coupon.subTitleLineOne isEqualToString:@"null"] && [coupon.subTitleLineOne length] != 0){
		[title appendString:@" "];
		[title appendString:coupon.subTitleLineOne];
		onlyTitle = NO;
	}
	
	if(coupon.subTitleLineTwo && ![coupon.subTitleLineTwo isEqualToString:@"null"] && [coupon.subTitleLineTwo length] != 0){
		[title appendString:@" "];
		[title appendString:coupon.subTitleLineTwo];
		onlyTitle = NO;
	}
	//if(onlyTitle)
		[title appendString:@"\n "];
	
	titleLabel.text = title;
	
	[title release];
	
	vendorLabel.text = poi.name;
	
}

- (void) setDetailsForSavedAndShared:(Coupon *) coupon withPoi:(Poi *)poi {
	
	distanceLabel.text = @"";
	distanceShowLabel.text = @"";
	addressLabel.text = poi.completeAddress;
    if ([coupon.validTo rangeOfString:@"/"].location == NSNotFound) {
        expiryLabel.text = [GeneralUtil getLongFormatDate:coupon.validTo];
    } else {
        expiryLabel.text = coupon.validTo;
    }
    
	
	phoneLabel.text = poi.phoneNumber;
	//[self.phoneButton setTitle:poi.phoneNumber forState:UIControlStateNormal];
	NSMutableString *title = [[NSMutableString alloc] initWithString:@""];
	BOOL onlyTitle = NO;
	if(coupon.title && ![coupon.title isEqualToString:@"null"]){
		[title appendString:coupon.title];
		onlyTitle = YES;
	}
	
	if(coupon.subTitleLineOne && ![coupon.subTitleLineOne isEqualToString:@"null"] && [coupon.subTitleLineOne length] != 0){
		[title appendString:@" "];
		[title appendString:coupon.subTitleLineOne];
		onlyTitle = NO;
	}
	
	if(coupon.subTitleLineTwo && ![coupon.subTitleLineTwo isEqualToString:@"null"] && [coupon.subTitleLineTwo length] != 0){
		[title appendString:@" "];
		[title appendString:coupon.subTitleLineTwo];
		onlyTitle = NO;
	}
	//if(onlyTitle)
	[title appendString:@"\n "];
	
	titleLabel.text = title;
	
	[title release];
	
	vendorLabel.text = poi.name;
	
}

-(IBAction) phoneNumberClicked{

	[PoiUtil dialPhoneNumber:[GeneralUtil getPoi]];
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
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
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
    NSLog(@"UIAlert CouponDetailViewControiller did Receive Memory Warning");
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
     NSLog(@"UIAlert CouponDetailViewControiller viewDidUnload");
    titleLabel = nil;
    expiryLabel = nil;
    vendorLabel = nil;
    addressLabel = nil;
    distanceLabel = nil;
    distanceShowLabel = nil;
    phoneLabel = nil;
}


- (void)dealloc {
    
    [titleLabel release];
    [expiryLabel release];
    [vendorLabel release];
    [addressLabel release];
    [distanceLabel release];
    [distanceShowLabel release];
    [phoneLabel release];
	[phoneButton release];
    
    titleLabel = nil;
    expiryLabel = nil;
    vendorLabel = nil;
    addressLabel = nil;
    distanceLabel = nil;
    distanceShowLabel = nil;
    phoneLabel = nil;
    
    [super dealloc];
}

@end
