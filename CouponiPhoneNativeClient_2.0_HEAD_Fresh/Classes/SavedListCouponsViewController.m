//
//  ListCouponsViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SavedListCouponsViewController.h"
#import "RivePointAppDelegate.h"
#import "CouponViewCell.h"
#import "CouponManager.h"
#import "PoiManager.h"

@implementation SavedListCouponsViewController
@synthesize poi;

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
	cell.isSaved = YES;
	if(savedCouponsArray){
		Coupon *coupon = [savedCouponsArray objectAtIndex:indexPath.row];
		coupon.poiId = [NSString stringWithFormat:@"%d", appDelegate.poiId];
		[cell setCouponContent:coupon];		
	}
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[cell setUIViewController:self];
	cell.numberOfPOICoupons = [savedCouponsArray count];
	cell.couponIndex = indexPath.row;
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(savedCouponsArray)
		return [savedCouponsArray count];
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 110;
}

/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
 */
 - (void)viewDidLoad {
	 
	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	 [super viewDidLoad];
	 self.title = @"Coupons List";
	 self.navigationItem.leftBarButtonItem.title = @"List";
	 poiDetailImageView.image = [UIImage imageNamed:@"POI-Detail-pod-bg.png"];
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
	appDelegate.terminateRequest = NO;
	PoiManager *pm = [[PoiManager alloc] init];
	Poi *tempPoi = [pm findByPoiId:appDelegate.poiId];
	self.poi = tempPoi;
	[tempPoi release];
	[pm release];
	shouldReturnToRoot = YES;
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
	//distanceLabel.text = [NSString stringWithFormat:@"%@ miles", poi.distance];
	distanceLabel.text = @"";
	
	CouponManager *cm = [[CouponManager alloc]init];
	savedCouponsArray = [cm findByPoiId:appDelegate.poiId];
	[cm release];
	
	if(savedCouponsArray){
		[uiTableView reloadData];
	}
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
	if(shouldReturnToRoot){
		[[self navigationController] popToRootViewControllerAnimated:YES];
		[appDelegate removeAllFromCouponPreviewImageDictionary];
	}
	shouldReturnToRoot = YES;
	[savedCouponsArray release];
	savedCouponsArray = nil;
}

- (void) setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	[[self navigationController] setNavigationBarHidden:hidden animated:NO];

	CGRect frame = self.navigationController.navigationBar.frame;
	int height = [[UIScreen mainScreen] bounds].size.height  - frame.size.height;
	int width = frame.size.width;
	self.view.bounds = CGRectMake(0, 0, width, height);
	
	self.view.center = CGPointMake(width/2, height/2 );
	
	if (animated) {
		[UIView commitAnimations];
	}
}
- (void) deleteCouponAtIndex:(int)index{
	Coupon *coupon = [savedCouponsArray objectAtIndex:index];
	CouponManager *cm = [[CouponManager alloc] init];
	BOOL isDeleted = [cm deleteCoupon:coupon];
	[cm release];
	if(isDeleted){
		[appDelegate showAlert:KEY_COUPON_DELETED_SUCCESSFULLY delegate:self];
		[savedCouponsArray removeObject:coupon];
		[uiTableView reloadData];
		[appDelegate updateSavedCouponsTabBarItem];
	}
	else
		[appDelegate showAlert:KEY_ERROR_DELETE_COUPON delegate:self];
	
}
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		Coupon *coupon = [savedCouponsArray objectAtIndex:indexPath.row];
		CouponManager *cm = [[CouponManager alloc] init];
		BOOL isDeleted = [cm deleteCoupon:coupon];
		[cm release];
		if(isDeleted){
			[appDelegate showAlert:KEY_COUPON_DELETED_SUCCESSFULLY delegate:self];
			[savedCouponsArray removeObject:coupon];
			[uiTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[appDelegate updateSavedCouponsTabBarItem];
		}
		else
			[appDelegate showAlert:KEY_ERROR_DELETE_COUPON delegate:self];
		
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
 
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Show the disclosure indicator if editing.
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if([savedCouponsArray count] == 0 ){
		[self setEditing:NO animated:NO];
		[[self navigationController] popViewControllerAnimated:YES];
	}
	
	
}
-(IBAction)phoneClick{
	if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
		
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
	
	[poi release];
	[super dealloc];
}

@end
