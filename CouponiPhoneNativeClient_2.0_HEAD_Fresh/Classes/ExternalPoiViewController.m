//
//  FirstViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "MainViewController.h"
#import "RivePointAppDelegate.h"
#import "VendorViewCell.h"
#import "ListCouponsViewController.h"
#import "Poi.h"
#import "ListCouponsViewController.h"
#import "RightBarButtonItemsController.h"
#import "ExternalPoiViewController.h"

@implementation ExternalPoiViewController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
		VendorViewCell *cell;
		Poi *poi = [appDelegate.externalArray objectAtIndex:indexPath.row];

			static NSString *couponCell = @"VendorViewCell";
			cell = (VendorViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
			if(nil == cell) 
			{
				UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
				cell = (VendorViewCell *) c.view;
				[cell setBackGroundWithPod];

				[c release];
			}
		
			[cell setPoiContent:poi];
			[cell showDistanceLabel:poi];
	
	
	        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
			return cell;
}




- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.externalArray)
		return [appDelegate.externalArray count];
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[appDelegate recipeClicked:[[tableView cellForRowAtIndexPath:indexPath] text]];
	NSLog(@"Row selected");
	
	//Initialize the detail view controller and display it.
	if(cvController == nil)
		cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
		appDelegate.currentPoiCommand = EXTERNAL_COUPON_POIS;
		appDelegate.poiId = indexPath.row;
		[[self navigationController] pushViewController:cvController animated:YES];
//®®	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Default row height
	return 50;
}



 //Implement loadView if you want to create a view hierarchy programmatically
/*
 - (void)loadView {
	 self.parentViewController.title = @"Categories";
 }
*/


// Implement viewDidLoad if you need to do additional setup after loading the view.
 - (void)viewDidLoad {
     [super viewDidLoad];
	 //self.navigationItem.title = @"Vendor List";
	 [GeneralUtil setRivepointLogo:self.navigationItem];
	 [self setRightBarButton:0];
	 self.title = @"External Pois";
	 [self setButtonsEnabled:NO nextButton:NO];
	 
 }
-(void)setButtonsEnabled: (BOOL)previous nextButton:(BOOL)next{
	nextButton.enabled = next;
	previousButton.enabled = previous;
}


-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup {
	isRequestInProgress = NO;
	[self setRightBarButton:0];
	[appDelegate hideActivityViewer];
	if(!poiDtoGroup){
		paginationLabel.text = @"";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	//	[FlurryUtil logExternalCouponError:appDelegate.setting.zip];
		[alert show];	
		[alert release];
		[self setButtonsEnabled:NO nextButton:NO];
		//array = nil;
		
		return;
		
	}
	if([poiDtoGroup.vector count] > 0){

		appDelegate.externalArray = poiDtoGroup.vector;

		poiDtoGroup.vector = nil;
			
		isNext = poiDtoGroup.next;
		isPrevious =poiDtoGroup.previous;
		
		[self setButtonsEnabled:isPrevious nextButton:isNext];
		
		
		paginationLabel.text = [NSString stringWithFormat:@"Displaying %@ - %@ of %@"
							,poiDtoGroup.fromSequenceNumber,poiDtoGroup.toSequenceNumber,poiDtoGroup.totalPois];
	}else {
		paginationLabel.text = @"";
		[self setButtonsEnabled:NO nextButton:NO];
		
		/*
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_NO_POIS_FOUND,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
		*/
		 
		[self setButtonsEnabled:NO nextButton:NO];
		poiDtoGroup.vector = nil;
		[poiDtoGroup release];
		[uiTableView reloadData];
		return;
	}

	[uiTableView reloadData];
	[poiDtoGroup release];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (IBAction)nextOption{
	[self setRightBarButton:1];
	
	appDelegate.externalArray = nil;
	
	[uiTableView reloadData];
	[self setButtonsEnabled:NO nextButton:NO];
	[finder getExternalCouponPois: FETCH_NEXT caller:self];
	isRequestInProgress = YES;
}
- (IBAction)previousOption{
	[self setRightBarButton:1];
	
	appDelegate.externalArray = nil;
	
	[uiTableView reloadData];
	[self setButtonsEnabled:NO nextButton:NO];
	
	[finder getExternalCouponPois: FETCH_PREVIOUS caller:self];
	
	isRequestInProgress = YES;

}
- (void)viewDidDisappear:(BOOL)animated{
	//finder.dontDisplay = YES;
	[self setButtonsEnabled:NO nextButton:NO];
}

- (void)viewWillAppear:(BOOL)animated{
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	//self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	zipCodeLabel.title = appDelegate.setting.zip; 
	
	appDelegate.couponArray = nil;
		

	appDelegate.currentPoiCommand = 4;
		
	if(!appDelegate.externalArray && !isRequestInProgress){
		
		paginationLabel.text = @"";
		[uiTableView reloadData];
		if(finder){
			[finder dealloc];
		}
		finder = [[PoiFinderNew alloc]init];
		[self setRightBarButton:1];
		//[FlurryUtil logExternalCoupons:appDelegate.setting.zip];
		[finder getExternalCouponPois: FETCH_FIRST caller:self];
		isRequestInProgress = YES;
	}
	else{
		[self setButtonsEnabled:isPrevious nextButton:isNext];
	}
}
- (IBAction)testClick{
	
}

-(void)setRightBarButton: (int)i{
	if(i==0){
		RightBarButtonItemsController *rBarButtonItemsController = [[RightBarButtonItemsController alloc] initWithNibName:@"RightBarButtonItems" bundle:nil];
		UIImageView *imgView = (UIImageView *) rBarButtonItemsController.view ;
		imgView.image=[UIImage imageNamed:@"rigntBarItem_bg.png"];
		[rBarButtonItemsController.nextButton addTarget:self action:@selector(nextOption) forControlEvents:UIControlEventTouchUpInside];
		[rBarButtonItemsController.prevButton addTarget:self action:@selector(previousOption) forControlEvents:UIControlEventTouchUpInside];
		nextButton = rBarButtonItemsController.nextButton;
		previousButton = rBarButtonItemsController.prevButton;
		[nextButton setImage:[UIImage imageNamed:@"rightBarItem_next_btn_disable.png"] forState:UIControlStateDisabled];
		[previousButton setImage:[UIImage imageNamed:@"rightBarItem_prev_btn_disable.png"] forState:UIControlStateDisabled];
		
		
		UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:imgView] autorelease];	
		//[imgView release];
		[rBarButtonItemsController release];
		
		self.navigationItem.rightBarButtonItem = rightTopBarItem;
	}
	else{
		[GeneralUtil setActivityIndicatorView:self.navigationItem];
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(appDelegate.externalArray)
		return @"";
	if(isRequestInProgress)
		return @"Fetching...";
	return NSLocalizedString(KEY_NO_POIS_FOUND,EMPTY_STRING);
	/*else
	 return @"Star 1 - 5";*/
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//tabBarController.selectedViewController = browseNavigationController;
	[[self navigationController] popToRootViewControllerAnimated:YES];
}
- (void)dealloc {
	
	[super dealloc];
}

@end
