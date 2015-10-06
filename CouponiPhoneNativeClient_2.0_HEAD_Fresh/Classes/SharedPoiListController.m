//
//  SharedPoiListController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SharedPoiListController.h"
#import "RivePointAppDelegate.h"
#import "VendorViewCell.h"
#import "CouponPoiXMLParser.h"
#import "Base64.h"
#import "CommandUtil.h"


@implementation SharedPoiListController
@synthesize isLoyalty;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	VendorViewCell *cell;
	Poi *poi = [appDelegate.sharedPoiArray objectAtIndex:indexPath.row];
	
	
	//if([poi.isSponsored isEqualToString:@"0"]){
		static NSString *couponCell = @"VendorViewCell";
		cell = (VendorViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
		if(nil == cell) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
			cell = (VendorViewCell *) c.view;
			[cell setBackGround];
			[c release];
		}
/*	}
	else{
		static NSString *couponCell = @"VendorCellSponsored";
		cell = (VendorViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
		if(nil == cell) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
			cell = (VendorViewCell *) c.view;
			[c release];
		}
	}*/
	
	
	
	[cell setPoiContent:poi];
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	return cell;

}




- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.sharedPoiArray)
		return [appDelegate.sharedPoiArray count];
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[appDelegate recipeClicked:[[tableView cellForRowAtIndexPath:indexPath] text]];
	//CouponManager *cm = [[CouponManager alloc] init];
	Poi *poi = [appDelegate.sharedPoiArray objectAtIndex:indexPath.row];
	appDelegate.poiId = [poi.poiId intValue]; 
	appDelegate.poiIndex = indexPath.row;
	appDelegate.currentPoiCommand = 5;
	
	
	if(slcvController == nil)
		slcvController = [[SCListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
	[slcvController setIsLoyalty:isLoyalty];
	[[self navigationController] pushViewController:slcvController animated:YES];
	
	
	
	//NSMutableArray *cpns = [cm findByPoiId:p.poiId];
	
	//[cm release];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Default row height
	return 50;
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
	[uiTableView reloadData];
	if(!appDelegate.sharedCouponArray){
		
		if(adaptor){
			[adaptor cancelRequest];
			[adaptor release];
		}
		
		adaptor = [[HttpTransportAdaptor alloc]init];
		NSString *string;
		
		//string = [CommandUtil getXMLForGetSenderSharedCouponsCommmand:[NSString stringWithFormat:@"%d",appDelegate.senderId]];
		string = [CommandUtil getXMLForGetSenderSharedCouponsCommmand:[NSString stringWithFormat:@"%d",appDelegate.senderId] loyaltyFlag:isLoyalty];
        
		[adaptor sendXMLRequest:string referenceOfCaller:self];
		//[FlurryAPI logEvent:SHARED_COUPON_EVENT timed:YES];
		[self setRightBarButton:1];
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
		
		
		
- (void)viewDidDisappear:(BOOL)animated{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}
- (void)processHttpResponse:(NSData *)response{
	
	CouponPoiXMLParser *parser = [[CouponPoiXMLParser alloc]init];
	[parser parseXMLFromData:response parseError:nil];
	//[appDelegate.couponArray release];
	appDelegate.sharedCouponArray = [parser getArray];
	int i = 0, couponCount;
	BOOL isProcessedPreviously = NO;
	NSMutableArray *poiArray = [[NSMutableArray alloc] init];
	for (Coupon *coupon in appDelegate.sharedCouponArray) {
		isProcessedPreviously = NO;
		Poi *poi = coupon.poi;
		couponCount = 1;
		for (int j = i+1 ; j < [appDelegate.sharedCouponArray count]; j++) {
			Coupon *coupon2 = [appDelegate.sharedCouponArray objectAtIndex:j];
			Poi *poi2 = coupon2.poi;
			if([poi.poiId isEqualToString:poi2.poiId])
			   couponCount++;
		}
		for(int j = 0; j< i ; j++){
			Coupon *coupon2 = [appDelegate.sharedCouponArray objectAtIndex:j];
			Poi *poi2 = coupon2.poi;
			if([poi.poiId isEqualToString:poi2.poiId])
			   isProcessedPreviously = YES;
		}
		if(!isProcessedPreviously){
			poi.couponCount = [NSString stringWithFormat:@"%d",couponCount];
			[poiArray addObject:poi];				
		}
		i++;
	}
	appDelegate.sharedPoiArray = poiArray;
          
	[poiArray release];
	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	//[FlurryAPI endTimedEvent:SHARED_COUPON_EVENT];
	[uiTableView reloadData];
	[response release];
	//[appDelegate hideActivityViewer];
	[self setRightBarButton:0];
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


- (void)dealloc {
	[super dealloc];
}

@end
