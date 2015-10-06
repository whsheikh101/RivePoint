//
//  SavedViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SavedViewController.h"
#import "RivePointAppDelegate.h"
#import "VendorViewCell.h"
#import "PoiManager.h"
#import "CouponManager.h"
#import "Base64.h"
#import "FileUtil.h"

@implementation SavedViewController
@synthesize loyaltyPoi;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	VendorViewCell *cell;
	Poi *poi = [savedPoisArray objectAtIndex:indexPath.row];
	
		static NSString *couponCell = @"VendorViewCell";
		cell = (VendorViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
		if(nil == cell) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
			cell = (VendorViewCell *) c.view;
			[cell setBackGround];
			[c release];
		}
	
	[cell setPoiContent:poi];
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	return cell;

}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(savedPoisArray)
		return [savedPoisArray count];
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	Poi *p = [savedPoisArray objectAtIndex:indexPath.row];
	appDelegate.poiId = [p.poiId intValue]; 
	appDelegate.poi = p;
	appDelegate.currentPoiCommand = 7;
	
	if(slcvController == nil)
		slcvController = [[SavedListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
	[slcvController setIsLoyaltyPoi:loyaltyPoi];
	[[self navigationController] pushViewController:slcvController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Default row height
	return 63;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */
 - (void)viewDidLoad {
	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	 //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	 [GeneralUtil setRivepointLogo:self.navigationItem];
	 [super viewDidLoad];
 }
 
- (void)viewWillAppear:(BOOL)animated{
	//[self hideNavigationBar:YES animated:NO];
	[FileUtil resetUserDefaults];
	//	[FlurryUtil logSavedCoupon:appDelegate.setting.zip];
	PoiManager *poiManager = [[PoiManager alloc] init];
	if (loyaltyPoi) {
        savedPoisArray =  [poiManager findAllLoyaltyPoi];
    }else	
        savedPoisArray =  [poiManager findAllPois];
	[poiManager release];
	[uiTableView reloadData];
	if([savedPoisArray count]==0){
		[appDelegate showAlert:KEY_NO_SAVED_COUPON_FOUND delegate:self];
		
	}
	else{
		if(!appDelegate.imageLogos)
			appDelegate.imageLogos = [[[NSMutableDictionary alloc] init] autorelease];
		
		for (Poi *poi in savedPoisArray) {
			if(poi.imageBytes && [[poi.imageBytes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >0){
				NSData* base64Data = [[[NSData alloc] initWithBase64EncodedString:poi.imageBytes]autorelease];
				[appDelegate.imageLogos setObject:base64Data forKey:poi.name];
			}
		}
	}
}

- (void)viewDidDisappear:(BOOL)animated{
	if(savedPoisArray){
		[savedPoisArray release];
		savedPoisArray = nil;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Saved View Controller - Receive Memory Warning "); 
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[[self navigationController] popToViewController:(UIViewController *)appDelegate.myCouponsController animated:NO];
}

- (void) viewDidUnload {
    NSLog(@"Saved View Controller - View Did Unload "); 
    
    gpsView = nil;
	uiTableView = nil;
	nextButton = nil;
	previousButton = nil;
	paginationLabel = nil;
	zipCodeLabel = nil;
	toolbar = nil;
	slcvController = nil;
}

- (void)dealloc {
    
    [gpsView release];
	[uiTableView release];
	[nextButton release];
	[previousButton release];
	[paginationLabel release];
	[zipCodeLabel release];
	[toolbar release];
	[slcvController release];
    
    gpsView = nil;
	uiTableView = nil;
	nextButton = nil;
	previousButton = nil;
	paginationLabel = nil;
	zipCodeLabel = nil;
	toolbar = nil;
	slcvController = nil;
    
	[super dealloc];
}

@end
