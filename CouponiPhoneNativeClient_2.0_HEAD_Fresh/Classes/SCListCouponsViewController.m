//
//  SCListCouponsViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SCListCouponsViewController.h"
#import "RivePointAppDelegate.h"
#import "CouponViewCell.h"
#import "HttpTransportAdaptor.h"
#import "CommandUtil.h"
#import "CouponPoiXMLParser.h"
#import "GeneralUtil.h"

@implementation SCListCouponsViewController
#define COUPON_LIST_CELL_HEIGHT 110

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *couponCell = @"CouponViewCell";
	CouponViewCell *cell = (CouponViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
	
	if(nil == cell) 
	{
		UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
		cell = (CouponViewCell *) c.view;
		[cell setAttibutesOnLoad];
		[c release];
	}
	cell.isShared=YES;
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

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return COUPON_LIST_CELL_HEIGHT;
}

/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
 */
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [mapButton setImage:[UIImage imageNamed:@"map-button-ov.png"] forState:UIControlStateHighlighted];
	 self.title = @"Coupons List";
	 self.navigationItem.leftBarButtonItem.title = @"List";
	 poiDetailImageView.image = [UIImage imageNamed:@"POI-Detail-pod-bg.png"];
	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
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
	appDelegate.terminateRequest = NO;
	NSMutableArray *tempArray =  [[NSMutableArray alloc] init];
	appDelegate.couponArray  = tempArray;
	[tempArray release];
	tempArray = nil;
	for (Coupon *coupon in appDelegate.sharedCouponArray) {
		Poi *poi2 = coupon.poi;
		if([poi2.poiId intValue] == appDelegate.poiId){
			[appDelegate.couponArray addObject:coupon];
			poi = poi2;
		}
	}
		
	vendorLabel.text = poi.name;
	distanceLabel.text= @"";
	
	NSArray *array = [poi.completeAddress componentsSeparatedByString:@","];
	
	if([array count] > 4){
		addressLine1Label.text = [array objectAtIndex:0];
		NSString *string = [[NSString stringWithFormat:@"%@,%@,%@",[array objectAtIndex:1],
							[array objectAtIndex:2],[array objectAtIndex:3] ]
							stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		addressLine2Label.text = string;
	}
	if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		[phoneBtn setTitle:poi.phoneNumber forState:UIControlStateNormal];
	}

	
	shouldReturnToRoot = YES;
	[uiTableView reloadData];
	
	bigLogoImageView.image = nil;
	[NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
}
- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[GeneralUtil setBigLogo:bigLogoImageView poiId:poi.poiId];
	
	[pool release];
}
- (void)viewDidDisappear:(BOOL)animated{
	appDelegate.terminateRequest = YES;
	if(shouldReturnToRoot)
		[[self navigationController] popToRootViewControllerAnimated:YES];
	shouldReturnToRoot = YES;
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


- (void) dontReturnToRoot{
	shouldReturnToRoot = NO;
	
}

- (void)dealloc {
	[super dealloc];
}

@end
