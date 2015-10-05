//
//  BrowseViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/12/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "RivePointAppDelegate.h"
#import "PoiRequestParams.h"
#import "BrowseViewCell.h"
#import "GeneralUtil.h"
#import "RightBarButtonItemsController.h"
#import "CouponManager.h"

@implementation MyCouponsViewController

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
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	[GeneralUtil setRivepointLogo:self.navigationItem];
	
	/*RightBarButtonItemsController *rBarButtonItemsController = [[RightBarButtonItemsController alloc] initWithNibName:@"RightBarButtonItems" bundle:nil];
	UIImageView *imgView = (UIImageView *) rBarButtonItemsController.view ;
	imgView.image=[[UIImage imageNamed:@"rigntBarItem_bg.png"] autorelease];
	[rBarButtonItemsController.nextButton setHidden:YES];
	[rBarButtonItemsController.prevButton setHidden:YES];
	UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:imgView] autorelease];
	[imgView release];
	[rBarButtonItemsController release];*/
	self.title = @"My Coupons";
	//self.navigationItem.rightBarButtonItem = rightTopBarItem;

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
- (void)viewWillAppear:(BOOL)animated{
	appDelegate.sharedInboxArray = nil;

}

- (void)dealloc {
	[sViewController release];
	[sCInbox release];
	[deleteAllShared release];
    [super dealloc];
}
- (int)getTotalCouponsCount{
	CouponManager *cm = [[CouponManager alloc]init];
	int totalCouponCount = [cm getCouponsCount];
	[cm release];
	return totalCouponCount;
	
  }

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	//NSLog(@"BrowseViewController:didSelectRowAtIndexPath cell clicked {%d, %d}}", indexPath.row, indexPath.section);
	switch (indexPath.row) {
		case 0:
			if(!sViewController)
				sViewController = [[SavedViewController alloc] initWithNibName:@"SavedVender" bundle:nil];
			[sViewController setLoyaltyPoi:NO];
			
			[[self navigationController] pushViewController:sViewController animated:YES];
			break;
		case 1:
			if(!sCInbox)
				sCInbox = [[SharedCouponInbox alloc] initWithNibName:@"GeneralTableView" bundle:nil];
			[sCInbox setIsLoyaltyPoi:NO];
			[[self navigationController] pushViewController:sCInbox animated:YES];
			
			break;
        case 2:
			if(!sViewController){
				sViewController = [[SavedViewController alloc] initWithNibName:@"SavedVender" bundle:nil];
                
            }
			[sViewController setLoyaltyPoi:YES];
			
			[[self navigationController] pushViewController:sViewController animated:YES];
			break;
		case 3:
			if(!sCInbox)
				sCInbox = [[SharedCouponInbox alloc] initWithNibName:@"GeneralTableView" bundle:nil];
			[sCInbox setIsLoyaltyPoi:YES];
			[[self navigationController] pushViewController:sCInbox animated:YES];
			
			break;
		case 4:
			if(!deleteAllShared)
				deleteAllShared = [[DeleteAllShared alloc]init];
			
			[deleteAllShared emptySharedInbox];
		//	[FlurryUtil logDeleteAllShared:appDelegate.setting.zip];
			break;
		case 5:
			if([self getTotalCouponsCount] > 0){
				[self deleteAllCoupons];
//[FlurryUtil logDeleteAllSaved:appDelegate.setting.zip];
			}
			else
				[appDelegate showAlert:@"No coupons found for deletion." delegate:appDelegate];
			break;
			
		default:
			break;
	}

	
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *browseCell = @"MyCouponsViewCell";
								 
	BrowseViewCell *cell = (BrowseViewCell *)[tv dequeueReusableCellWithIdentifier:browseCell];
	if(nil == cell) {
		UIViewController *cLstCellController = [[UIViewController alloc] initWithNibName:browseCell bundle:nil];
		cell = (BrowseViewCell *) cLstCellController.view;
		[cLstCellController release];
	}
	[cell setCellDataForMyCoupons:indexPath.row];

	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.optionNames count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;	
}
-(void) deleteAllCoupons{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CONFIRMATION_DELETE_ALL_COUPON_OPERATION,EMPTY_STRING) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];	
	[alert release];
}

- (void)confirmForDeletionAll:(BOOL)isConfirmed{
	if(isConfirmed){
		CouponManager *cm = [[CouponManager alloc]init];
		[cm deleteAll];
		[cm release];
		[appDelegate showAlert:NSLocalizedString(KEY_DELETE_ALL_COUPONS,EMPTY_STRING) delegate:appDelegate];
		
	}

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		NSLog(@"Retry/Yes pressed.. %d" , buttonIndex);
		[self confirmForDeletionAll:YES];
	}
	else{
		NSLog(@"Cancel pressed");
	}
	
}


@end
