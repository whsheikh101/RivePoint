//
//  ListCouponsViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/1/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "COTDCouponList.h"
#import "RivePointAppDelegate.h"
#import "CouponViewCell.h"
#import "HttpTransportAdaptor.h"
#import "CommandUtil.h"
#import "XMLParser.h"

@implementation COTDCouponList
#define COUPON_LIST_CELL_HEIGHT 110

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *couponCell = @"CouponViewCell";
	CouponViewCell *cell = (CouponViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
	
	if(nil == cell) 
	{
		UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
		cell = (CouponViewCell *) c.view;
		[c release];
	}
	if(appDelegate.couponArray){
		[cell setCouponContent:[appDelegate.couponArray objectAtIndex:indexPath.row]];
		cell.couponIndex = indexPath.row;
	}
		
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[cell setUIViewController:self];
	return cell;
	
}




- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.couponArray)
		return [appDelegate.couponArray count];
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
	if(cdController == nil)
		cdController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetail" bundle:nil];
	
	appDelegate.couponId = indexPath.row;
	shouldReturnToRoot = NO;
	[[self navigationController] pushViewController:cdController animated:YES];
 */
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return COUPON_LIST_CELL_HEIGHT;
}


/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */

/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
 */
 - (void)viewDidLoad {
	 [super viewDidLoad];
//	 [mapButton setImage:[UIImage imageNamed:@"map-button-ov.png"] forState:UIControlStateHighlighted];
	 self.title = @"Coupons List";
	 self.navigationItem.leftBarButtonItem.title = @"List";
	 poiDetailImageView.image = [UIImage imageNamed:@"POI-Detail-pod-bg.png"];
 }
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)viewWillAppear:(BOOL)animated{
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if(appDelegate.currentPoiCommand == 2)
		poi = [appDelegate.poiArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == 1)
		poi = [appDelegate.browseArray objectAtIndex:appDelegate.poiId];
	else 
		poi = [appDelegate.searchArray objectAtIndex:appDelegate.poiId];
	vendorLabel.text = poi.name;
//	
//	if(!poi.bigLogo){
//	
//	NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
//	NSString *urlFileName = @"url";
//	NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
//	NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
//	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=1&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,poi.poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	NSData *receivedData =  [[[NSData alloc] initWithContentsOfURL:url] autorelease];
//		if(receivedData && [receivedData length] > 0)
//			poi.bigLogo=receivedData;
//		
//		//poi.bigLogo = receivedData;
//		//[receivedData release];
//	}
//	if(poi.bigLogo && [poi.bigLogo length] > 0)
//		bigLogoImageView.image = [UIImage imageWithData:poi.bigLogo]; 
//	
	
	NSArray *array = [poi.completeAddress componentsSeparatedByString:@","];
	
	if([array count] == 4){
		addressLine1Label.text = [array objectAtIndex:0];
		//cityLabel.text = [array objectAtIndex:1];
		NSString *string = [NSString stringWithFormat:@"%@,%@,%@",[array objectAtIndex:1],
							[array objectAtIndex:2],[[array objectAtIndex:3] substringToIndex:([[array objectAtIndex:3]length]-3)]];
		addressLine2Label.text = string;
	}
	if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		[phoneBtn setTitle:poi.phoneNumber forState:UIControlStateNormal];
		//[phoneBtn setTitle:poi.phoneNumber forState:UIControlStateHighlighted];
	}
	if([poi.isSponsored isEqualToString:@"0"])
		distanceLabel.text = [NSString stringWithFormat:@"%@ miles", poi.distance];
	else
		distanceLabel.text = @"";
	//array = nil;
	shouldReturnToRoot = YES;
	[uiTableView reloadData];
	if(!appDelegate.couponArray){
	
		if(adaptor){
			[adaptor cancelRequest];
			[adaptor release];
		}
		
	adaptor = [[HttpTransportAdaptor alloc]init];

	NSString *string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId];
	[adaptor sendXMLRequest:string referenceOfCaller:self];
	[self setRightBarButton:1];
	}

}
- (void)processHttpResponse:(NSData *)response{
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"Coupon" parseError:nil];

	appDelegate.couponArray =nil;
		

	//[appDelegate.couponArray release];
	appDelegate.couponArray = [parser getArray];
	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	[uiTableView reloadData];
	[response release];
	[appDelegate hideActivityViewer];
	[self setRightBarButton:0];
}
- (void)viewDidDisappear:(BOOL)animated{
	if(shouldReturnToRoot)
		[[self navigationController] popToRootViewControllerAnimated:YES];
	shouldReturnToRoot = YES;
}

-(void)communicationError:(NSString *)errorMsg{
	[self setRightBarButton:0];
	[appDelegate hideActivityViewer];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	[adaptor release];
	adaptor = nil;

}

-(IBAction)phoneClick{
	if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
		
	}
	else{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_NO_PHONE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
		
	}
	
}
-(IBAction)mapClick{
	if([poi.completeAddress length] > 0){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:NSLocalizedString(GOOGLE_MAPS_URL,EMPTY_STRING) ,poi.completeAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_MAPS_CANT_OPEN,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}
}
-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
		UIActivityIndicatorView *uiActivityIndicatorView;
		uiActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0, 24, 24)];
		uiActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		uiActivityIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
													UIViewAutoresizingFlexibleRightMargin |
													UIViewAutoresizingFlexibleTopMargin |
													UIViewAutoresizingFlexibleBottomMargin);
		[uiActivityIndicatorView autorelease]; 
		UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:uiActivityIndicatorView] autorelease];	
		
		self.navigationItem.rightBarButtonItem = rightTopBarItem;
		[uiActivityIndicatorView startAnimating];
	}
}

- (void) dontReturnToRoot{
	
	shouldReturnToRoot = NO;
	
}

- (void)dealloc {
	[super dealloc];
}

@end
