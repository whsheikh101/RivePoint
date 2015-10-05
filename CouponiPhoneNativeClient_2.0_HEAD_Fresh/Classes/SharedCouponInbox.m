//
//  SharedCouponInbox.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SharedCouponInbox.h"
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "LabelViewCell.h"
#import "SharedCoupon.h"



@implementation SharedCouponInbox
#define COUPON_LIST_CELL_HEIGHT 50
@synthesize isLoyaltyPoi;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *couponListCell = @"LabelViewCell";
	LabelViewCell *cell = (LabelViewCell *)[tableView dequeueReusableCellWithIdentifier:couponListCell];
	
	if(nil == cell) 
	{
		UIViewController *c = [[UIViewController alloc] initWithNibName:couponListCell bundle:nil];
		cell = (LabelViewCell *) c.view;
		[c release];
	}
	
	if(appDelegate.sharedInboxArray){
		SharedCoupon *sharedCoupon = (SharedCoupon *) [appDelegate.sharedInboxArray objectAtIndex:indexPath.row];
		[cell setLabel:[NSString stringWithFormat:@"%@ (%@)",sharedCoupon.sndrEmail,sharedCoupon.tCntSUsr]];		
	}
	
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.backgroundColor = [UIColor clearColor];
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod.png"]];
	cell.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod_ov.png"]];
	cell.selectedBackgroundView = view;
	[view release]; 
	return cell;
	
}




- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.sharedInboxArray)
		return [appDelegate.sharedInboxArray count];
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	SharedCoupon *sharedCoupon = (SharedCoupon *) [appDelegate.sharedInboxArray objectAtIndex:indexPath.row];
	appDelegate.senderId =  [sharedCoupon.sndrId intValue];
	

	if(splController == nil)
		splController = [[SharedPoiListController alloc] initWithNibName:@"ListVendorView" bundle:nil];
	
	[splController setIsLoyalty:isLoyaltyPoi];
    shouldReturnToRoot = NO;
	[[self navigationController] pushViewController:splController animated:YES];
 
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
	 self.title = @"Sender List";
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
	appDelegate.sharedCouponArray = nil;
	appDelegate.sharedPoiArray = nil;
	[uiTableView reloadData];
	if(!appDelegate.sharedInboxArray){
	
		if(adaptor){
			[adaptor cancelRequest];
			[adaptor release];
		}
		
	adaptor = [[HttpTransportAdaptor alloc]init];
	NSString *string;
	
    
//    string = [CommandUtil getXMLForSharedInboxCommmand];
    string = [CommandUtil getXMLForSharedInboxCommmand:isLoyaltyPoi];
		
	[adaptor sendXMLRequest:string referenceOfCaller:self];
	[self setRightBarButton:1];
		[appDelegate showActivityViewer];
	}

}
- (void)processHttpResponse:(NSData *)response{
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"SharedCoupon" parseError:nil];

	appDelegate.sharedInboxArray = [[parser getArray]autorelease];
	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	[uiTableView reloadData];
	[response release];
	[appDelegate hideActivityViewer];
	if([appDelegate.sharedInboxArray count]==0)
		[appDelegate  showAlert:NSLocalizedString(KEY_SHARED_INBOX_IS_EMPTY,@"") delegate:self];
	
	[self setRightBarButton:0];
}
- (void)viewDidDisappear:(BOOL)animated{
	//if(shouldReturnToRoot)
	//	[[self navigationController] popToRootViewControllerAnimated:YES];
	//shouldReturnToRoot = YES;
}

-(void)communicationError:(NSString *)errorMsg{
	[self setRightBarButton:0];
	[appDelegate hideActivityViewer];
	[appDelegate  showAlert:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,@"") delegate:self];
	[adaptor release];
	adaptor = nil;

}
-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
		[GeneralUtil setActivityIndicatorView:self.navigationItem];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[[self navigationController] popToViewController:(UIViewController *)appDelegate.myCouponsController animated:NO];
}


- (void) dontReturnToRoot{
	shouldReturnToRoot = NO;
}

- (void)dealloc {
	[super dealloc];
}

@end
