//
//  ListCouponsViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "ListCouponsViewController.h"
#import "RivePointAppDelegate.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "GeneralUtil.h"
#import "FileUtil.h"
#import "PoiFinderNew.h"
#import "PoiUtil.h"
#import "MapViewController.h"

@implementation ListCouponsViewController
#define COUPON_LIST_CELL_HEIGHT 110
#define COUPON_ARRAY @"couponArray"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *couponCell = @"CouponViewCell";
	CouponViewCell *cell = (CouponViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
	
	if(nil == cell) {
		UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
		cell = (CouponViewCell *) c.view;
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		[cell setAttibutesOnLoad];
		[c release];
	}
	if(appDelegate.couponArray){
		[cell setCouponContent:[appDelegate.couponArray objectAtIndex:indexPath.row]];
		cell.couponIndex = indexPath.row;
	}
		
	
	[cell setUIViewController:self];
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.couponArray)
		return [appDelegate.couponArray count];
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return COUPON_LIST_CELL_HEIGHT;
}

/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
 */
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 self.title = @"Coupons List";
	 self.navigationItem.leftBarButtonItem.title = @"List";
	 poiDetailImageView.image = [UIImage imageNamed:@"POI-Detail-pod-bg.png"];
	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	 [GeneralUtil setRivepointLogo:self.navigationItem];
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

	if(appDelegate.loadFromPersistantStore){
		appDelegate.couponArray = [FileUtil restoreArrayOfCustomObjects:COUPON_ARRAY];
		[NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
	}	
	appDelegate.terminateRequest = NO;
	poi = [GeneralUtil getPoi];
	vendorLabel.text = poi.name;
	
	
	NSArray *array = [poi.completeAddress componentsSeparatedByString:@","];
	int addressComponentCount = [array count];
	NSString *string;
	switch (addressComponentCount) {

		case 2:
			string = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
			break;
		case 3:
			string = [NSString stringWithFormat:@"%@,%@",[array objectAtIndex:1],
														[array objectAtIndex:2]];
			break;
		case 6:
		case 5:
		case 4:
			string = [NSString stringWithFormat:@"%@,%@,%@",[array objectAtIndex:1],
					  [array objectAtIndex:2],[array objectAtIndex:3]];
			break;
		default:
			string = [NSString stringWithFormat:@""];
			break;
	}
	
	if(addressComponentCount > 0)
		addressLine1Label.text = [array objectAtIndex:0];

	if(addressComponentCount > 1){
		addressLine2Label.text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		[phoneBtn setTitle:poi.phoneNumber forState:UIControlStateNormal];
	}
	if([poi.isSponsored isEqualToString:@"true"])
		distanceLabel.text = @"";		
	else{
		distanceLabel.text = [NSString stringWithFormat:@"%@ miles", (poi.distance = [GeneralUtil truncateDecimal:poi.distance])];
	}	
	shouldReturnToRoot = YES;
	[uiTableView reloadData];
	if(	appDelegate.loadFromPersistantStore){
		appDelegate.loadFromPersistantStore = NO;
		return;
	}
	
	if(!appDelegate.couponArray){
		bigLogoImageView.image = nil;
		[NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
		if(adaptor){
			[adaptor cancelRequest];
			[adaptor release];
		}
		
		adaptor = [[HttpTransportAdaptor alloc]init];
		NSString *string;
		
		if(appDelegate.currentPoiCommand == 4)
			string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId couponType:EXTERNAL_COUPON];
		else if(appDelegate.currentPoiCommand ==  GET_LOYALTY_POIS)
			string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId 
												couponType:nil loyaltyFlag:YES];
		else
			string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId];
		
		[adaptor sendXMLRequest:string referenceOfCaller:self];
		[self setRightBarButton:1];
	}

}
- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[GeneralUtil setBigLogo:bigLogoImageView poiId:poi.poiId];
	
	[pool release];
}

- (void)processHttpResponse:(NSData *)response{
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"Coupon" parseError:nil];

	appDelegate.couponArray =nil;
	appDelegate.couponArray = [[parser getArray]autorelease];

	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	[uiTableView reloadData];
	[response release];
	[appDelegate hideActivityViewer];
	[self setRightBarButton:0];
	if(!appDelegate.couponArray || [appDelegate.couponArray count] == 0){
		[appDelegate showAlert:NSLocalizedString(KEY_NO_COUPON_FOUND,EMPTY_STRING) delegate:self];
	}
	else{
		[self persistToNSUserDefaults];
	}
	
}
- (void) persistToNSUserDefaults{
	if(appDelegate.currentPoiCommand == BROWSE){
		[FileUtil setIntegerToNSUserDefaults:3 key:NO_OF_LEVELS];
		[FileUtil setIntegerToNSUserDefaults:appDelegate.poiId key:POI_ID];
		[FileUtil setIntegerToNSUserDefaults:COUPON_LIST key:LEVEL3];
	}
	else if(appDelegate.currentPoiCommand == GET_COUPONS ||appDelegate.currentPoiCommand == SEARCH){
		[FileUtil setIntegerToNSUserDefaults:2 key:NO_OF_LEVELS];
		[FileUtil setIntegerToNSUserDefaults:appDelegate.poiId key:POI_ID];
		[FileUtil setIntegerToNSUserDefaults:COUPON_LIST key:LEVEL2];
	}
	
	[FileUtil persistArrayOfCustomObjects:appDelegate.couponArray key:COUPON_ARRAY]; 
	
}
- (void)viewDidDisappear:(BOOL)animated{
	appDelegate.terminateRequest = YES;
	if(shouldReturnToRoot){
		if(browseVendorController && !isMapClick){
			[[self navigationController] popToViewController:browseVendorController animated:YES];
		}else if(isMapClick){
			isMapClick = NO; 
		}

		else{
			[[self navigationController] popToRootViewControllerAnimated:YES];
		}
		[appDelegate removeAllFromCouponPreviewImageDictionary];
	}
	shouldReturnToRoot = YES;
}

-(void)communicationError{
	[self setRightBarButton:0];
	[appDelegate hideActivityViewer];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	[adaptor release];
	adaptor = nil;

}

-(IBAction)phoneClick{
	/*if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}*/
	[PoiUtil dialPhoneNumber:poi];
}
-(IBAction)mapClick{
	/*if([poi.completeAddress length] > 0){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:NSLocalizedString(GOOGLE_MAPS_URL,EMPTY_STRING) ,poi.completeAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_MAPS_CANT_OPEN,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	 }*/
	
	poi = [GeneralUtil getPoi];
	if(!mapViewController){
		mapViewController = [[MapViewController alloc] initWithNibName:@"Maps" bundle:nil];
	}
		
	[mapViewController setListCouponViewController:self];
	[self.navigationController presentModalViewController:mapViewController animated:YES];
	isMapClick = YES;
		
	
}

-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
		[GeneralUtil setActivityIndicatorView:self.navigationItem];
	}
}

- (void) dontReturnToRoot{
	shouldReturnToRoot = NO;
	
}
 
-(void)setBrowseVendorController:(BrowseVendorController *)controller{
	browseVendorController = controller;
	
}
- (void)dealloc {
	[mapViewController release];
	[poi release];
	[super dealloc];
}

@end
