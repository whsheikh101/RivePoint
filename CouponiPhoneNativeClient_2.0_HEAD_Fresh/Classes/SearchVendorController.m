//
//  SearchVendorController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/05/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//
#import "SearchVendorController.h"
#import "RivePointAppDelegate.h"
#import "ListCouponsViewController.h"
#import "PoiDtoGroup.h"
#import "Poi.h"
#import "ListCouponsViewController.h"
#import "LabelViewCell.h"
#import "FileUtil.h"
#import "PoiUtil.h"

@implementation SearchVendorController

@synthesize shouldReturnToRoot, suggestionArray;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(isSuggestionsAvailable){
		static NSString *couponListCell = @"LabelViewCell";
		LabelViewCell *cell = (LabelViewCell *)[tableView dequeueReusableCellWithIdentifier:couponListCell];
		
		if(nil == cell) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:couponListCell bundle:nil];
			cell = (LabelViewCell *) c.view;
			[c release];
		}
		
		if(self.suggestionArray){
			[cell setLabel:[self.suggestionArray objectAtIndex:indexPath.row]];		
		}
		return cell;
	}
	
	return [PoiUtil getAppropriateCell:tableView cellForRowAtIndexPath:indexPath poiFinder:finderForSearch 
							  poiArray:appDelegate.searchArray command:SEARCH_POI_OPT_COMMAND
					  actualPOISInList:actualPOISInList];	
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(isSuggestionsAvailable){
		return [self.suggestionArray count];
	}	
	
	if(appDelegate.searchArray){
		if(isMoreClicked)
			return actualPOISInList;
		
		return indexCount+1;
//       return appDelegate.searchArray.count;
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
@try{
	
	if(isSuggestionsAvailable){
		//NSString *tempStr = searchBar.text;
		///searchBar.text = nil;
		searchBar.text = [self.suggestionArray objectAtIndex:indexPath.row];
		//[tempStr autorelease];
		isSuggestionsAvailable = NO;
		
		[self submitFirstRequest];
		return;
	}
	
	if(indexPath.row == 0){/*************** It means that Get Latest Records Cell is clicked ************/
		appDelegate.searchArray = nil;
		[appDelegate progressHudView:self.view andText:@"Updating..."];
		[uiTableView reloadData];
		[self onClickUpdateRecords];
		return;
	}

	if(indexPath.row > actualPOISInList){/*************** It means that More Cell is clicked ************/
		//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
		isMoreClicked=YES;
		indexCount--;
		[finderForSearch getPoisWithCoupons:FETCH_NEXT caller:self];
		[uiTableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationNone];
		
		return;
	}
	
	//Initialize the detail view controller and display it.
	if(cvController)
        cvController = nil;
	cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
	Poi *poi = [appDelegate.searchArray objectAtIndex:indexPath.row-1];
	if([poi.couponCount intValue] > 0){ 
		appDelegate.poiId = indexPath.row-1;
		shouldReturnToRoot = NO;
		appDelegate.currentPoiCommand = SEARCH;
		[[self navigationController] pushViewController:cvController animated:YES];
        [cvController release];
	}
	else{
        [appDelegate.progressHud removeFromSuperview];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_NO_COUPON_FOUND,@"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
	}
}
@catch (NSException * e) {
	NSLog(@"(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath: Caught %@: %@", [e name], [e  reason]);
}

}
- (void) startActivityViewerInNewThread{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	[appDelegate showActivityViewer];
	[self setRightBarButton:1];
	[pool release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row > actualPOISInList || indexPath.row==0){
		return 48;
	}
	//Default row height
		return 63;
}

// Implement viewDidLoad if you need to do additional setup after loading the view.
 - (void)viewDidLoad {
     [super viewDidLoad];

	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	 [appDelegate setSearchVendorController:self];
	 [GeneralUtil setRivepointLogo:self.navigationItem];

	 [self setRightBarButton:0];
	 count =0;
    
 }
-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroupp {
@try{
	[self setRightBarButton:0];
//	[appDelegate hideActivityViewer];
    NSLog(@"SearchVenderController Called From here ... !!!");
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate.progressHud removeFromSuperview];
	if(!poiDtoGroupp){
        [appDelegate.progressHud removeFromSuperview];
		[FileUtil resetUserDefaults];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry",nil];
        alert.tag = 95134;
		[alert show];	
		[alert release];
		//[FlurryUtil logSearchPOISError:appDelegate.keyword zipCode:appDelegate.setting.zip];
		return;
	}
	if(poiDtoGroupp.vector && [poiDtoGroupp.vector count] > 0){
	
	
		if(appDelegate.searchArray){
			BOOL isOnlyOneElement = NO;
			if([poiDtoGroup.vector count] == 1){
				isOnlyOneElement = YES;
			}
			
			if(isOnlyOneElement)	
				[uiTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:actualPOISInList-1 inSection:0 ]] withRowAnimation:UITableViewRowAnimationBottom];
			
			[appDelegate.searchArray addObjectsFromArray:poiDtoGroupp.vector];
			NSMutableArray *indexPathsArray = [[NSMutableArray alloc]init];
			int newPoiGroupSize = [poiDtoGroupp.vector count];
			for(int i=(isOnlyOneElement?actualPOISInList-1:actualPOISInList); i<actualPOISInList+ newPoiGroupSize-1;i++){
				lastIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
				[indexPathsArray addObject:lastIndexPath ];
			}
			actualPOISInList = [appDelegate.searchArray count];
			indexCount = actualPOISInList;
			isMoreClicked = NO;
			if((isNextEnabled = poiDtoGroupp.next) && !appDelegate.loadFromPersistantStore){
				[indexPathsArray addObject:[NSIndexPath indexPathForRow:indexCount++ inSection:0]];
			}
			[poiDtoGroupp release];
			[uiTableView insertRowsAtIndexPaths:[indexPathsArray autorelease] withRowAnimation:UITableViewRowAnimationBottom];	

			if(!appDelegate.loadFromPersistantStore){
				//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
				//[GeneralUtil fillWithVendorSmallLogo:appDelegate.searchArray];

				[self persistState];
				[appDelegate hideActivityViewer];
				[self setRightBarButton:0];
				NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:indexCount-2 inSection:0];
				[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

			}
			else{
				int page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
				if(finderForSearch.pageNumber <  page){
					[finderForSearch getPoisWithCoupons:FETCH_NEXT caller:self];
				}
				else{
					int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
					if(noOfLevels ==1){
						appDelegate.loadFromPersistantStore = NO;
					}
					//[FileUtil setPoiLogos:appDelegate.searchArray];
				}
			}
			
			return;
            [appDelegate.progressHud removeFromSuperview];
		}
		else{
			
			appDelegate.searchArray = nil;
			appDelegate.searchArray = poiDtoGroupp.vector;
			if(!appDelegate.loadFromPersistantStore){
			//	[FlurryAPI endTimedEvent:SEARCH_COUPONS_EVENT];
				//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
				//[GeneralUtil fillWithVendorSmallLogo:poiDtoGroupp.vector];
				[self persistState];
				[appDelegate hideActivityViewer];
				[self setRightBarButton:0];
			}
			/*else{
				[FileUtil setPoiLogos:appDelegate.searchArray];
			}*/
		}

		[self setRightBarButton:0];
		actualPOISInList = [appDelegate.searchArray count];
		indexCount = actualPOISInList;

		poiDtoGroupp.vector = nil;
	
		nextButton.enabled = poiDtoGroupp.next;
		previousButton.enabled = poiDtoGroupp.previous;
		isNextEnabled = poiDtoGroupp.next;
		isPreviousEnabled =poiDtoGroupp.previous;
	}
	else {
        [appDelegate.progressHud removeFromSuperview];
		[FileUtil resetUserDefaults];
		nextButton.enabled = NO;
		previousButton.enabled = NO;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING)  message:NSLocalizedString(KEY_NO_POIS_FOUND,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];

		if(!finderForSearch || [finderForSearch.suggestedKeywords isEqualToString:@"null"] || 
		   [finderForSearch.suggestedKeywords isEqualToString:@""]){
			if(poiDtoGroupp.vector){
				poiDtoGroupp.vector = nil;
			}

			[uiTableView reloadData];
			return;
		}

		isSuggestionsAvailable = YES;
		self.suggestionArray =  [finderForSearch.suggestedKeywords componentsSeparatedByString:@","] ;
		if(poiDtoGroupp.vector){
			poiDtoGroupp.vector = nil;
		}
		[uiTableView reloadData];
        [appDelegate.progressHud removeFromSuperview];
		return;
	}

	[poiDtoGroupp release];
	int page = 0;
	if(appDelegate.loadFromPersistantStore){
		page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
		if(finderForSearch.pageNumber <  page){
			[finderForSearch searchPois:FETCH_NEXT keyword:appDelegate.keyword caller:self];
		}
		else{
			int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
			if(noOfLevels ==1){
				appDelegate.loadFromPersistantStore = NO;
			}
		}
	}
	[uiTableView reloadData];
//	NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:indexCount-1 inSection:0];
//	[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//
//	if(isNextEnabled){
//		[uiTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexCount++ inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//		[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//	}
    [appDelegate.progressHud removeFromSuperview];
}
@catch (NSException * e) {
	NSLog(@"(void)displayResultDto:(PoiDtoGroup *) poiDtoGroupp: Caught %@: %@", [e name], [e  reason]);
}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    NSLog(@"Search Vendor Controller - Recieve Memory Warning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)viewDidDisappear:(BOOL)animated{
	finderForSearch.dontDisplay = YES;
	nextButton.enabled = NO;
	previousButton.enabled = NO;
	if(shouldReturnToRoot)
		[[self navigationController] popToRootViewControllerAnimated:YES];
	self.shouldReturnToRoot = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [appDelegate.progressHud removeFromSuperview];
    [super viewWillDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated{
	
	if(appDelegate.loadFromPersistantStore){
		
		appDelegate.keyword = [FileUtil getStringFromNSUserDefaultsPerfs:SEARCH_KEYWORD];
		searchBar.text = appDelegate.keyword;
		isAtLoadState = NO;//to be removed.
		NSString *poisString =  [FileUtil getStringFromNSUserDefaultsPerfs:POI_LIST];
		if(poisString){
			finderForSearch = [PoiFinderNew alloc];
			[finderForSearch loadValueThroughString:poisString commandName:SEARCH_POI_OPT_COMMAND caller:self];
			int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
			if(noOfLevels >1){
				
				if(cvController == nil)
					cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
				appDelegate.currentPoiCommand = SEARCH;
				appDelegate.poiId = [FileUtil getIntegerFromNSUserDefaultsPerfs:POI_ID];
				[[self navigationController] pushViewController:cvController animated:NO];
			}

			return;
		}
	}
	[FileUtil setIntegerToNSUserDefaults:1 key:NO_OF_LEVELS];

 	self.shouldReturnToRoot = YES;
	appDelegate.couponArray = nil;

	if(appDelegate.searchArray){
		[self persistState];
		nextButton.enabled = isNextEnabled;
		previousButton.enabled = isPreviousEnabled;
	}
	else {
		[FileUtil resetUserDefaults];
		nextButton.enabled = NO;
		previousButton.enabled = NO;
		self.navigationItem.title =@"Search";

		[uiTableView reloadData];

		[searchBar becomeFirstResponder];
	}

}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:nil];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	[ovController setSearchVendorController:self];
	[self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarArg{
	[self hideOverlay];
	
	isSuggestionsAvailable = NO;
	appDelegate.currentPoiCommand = 3;
	[searchBar resignFirstResponder];
	[self submitFirstRequest];
}

-(void) flushToRootOnTabChange
{
    NSLog(@"Search flushToRootOnTabChange");
    appDelegate.keyword = nil;
    [appDelegate.searchArray removeAllObjects];
    appDelegate.searchArray = nil;
    [uiTableView reloadData];
}

-(void)submitFirstRequest{
@try{
	[appDelegate removeAllFromLogoDictionary:SEARCH_POI_OPT_COMMAND];
    [appDelegate progressHudView:self.view andText:@"Loading..."];
	[self setRightBarButton:1];

	appDelegate.keyword = nil;
	appDelegate.searchArray = nil;

	[uiTableView reloadData];
	if(finderForSearch){
		[finderForSearch cancelRequest];
		[finderForSearch dealloc];
	}

	finderForSearch = [[PoiFinderNew alloc]init];
	appDelegate.keyword =[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	searchBar.text = appDelegate.keyword ;

	[finderForSearch searchPois:FETCH_FIRST keyword:searchBar.text caller:self];
	//[FlurryUtil logSearchPOIS:searchBar.text zipCode:appDelegate.setting.zip];
}	 
@catch (NSException * e) {
	NSLog(@"(void)submitFirstRequest: Caught %@: %@", [e name], [e  reason]);
}
}

- (void)onClickUpdateRecords{
	@try{
		[self setRightBarButton:1];
		searchBar.text = nil;
		searchBar.text = appDelegate.keyword;
		appDelegate.searchArray = nil;

		[uiTableView reloadData];
		if(finderForSearch){
			[finderForSearch cancelRequest];
			[finderForSearch dealloc];
		}
		
		finderForSearch = [[PoiFinderNew alloc]init];
		[finderForSearch searchPois:FETCH_FIRST keyword:appDelegate.keyword caller:self];
		
	}	 
	@catch (NSException * e) {
		NSLog(@"(void)onClickUpdateRecords: Caught %@: %@", [e name], [e  reason]);
	}
}

-(void) viewDidUnload {
    
    NSLog(@"Search Vendor Controller - View Did Unload");
    
    gpsView = nil;
	uiTableView = nil;
	cvController = nil;
	searchBar = nil;
    suggestionArray = nil;
    
    [super viewDidUnload];
}
- (void)dealloc {
	[suggestionArray release];
    
    [gpsView release];
	[uiTableView release];
	[cvController release];
	[searchBar release];

    gpsView = nil;
	uiTableView = nil;
	cvController = nil;
	searchBar = nil;
    suggestionArray = nil;
    
	[super dealloc];
}
-(void)hideOverlay{
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	[searchBar resignFirstResponder];
	
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(isSuggestionsAvailable)
		return @"Did you mean?";
	if(!appDelegate.searchArray)
		return @"";
	
	int poisCount = [finderForSearch.poiStringsArray count];
	
	return [NSString stringWithFormat:@"%d Vendors found near %@",poisCount,[GeneralUtil updateZipFromPOIList:appDelegate.searchArray]] ;
}

-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
//	else{
//		[GeneralUtil setActivityIndicatorView:self.navigationItem];
//	}
}
-(void) persistState{
	[FileUtil setIntegerToNSUserDefaults:1 key:NO_OF_LEVELS];
	[FileUtil setStringToNSUserDefaults:finderForSearch.poiStringsParamValue key:POI_LIST];
	[FileUtil setStringToNSUserDefaults:finderForSearch.searchKeyword key:SEARCH_KEYWORD];
	[FileUtil setIntegerToNSUserDefaults:SEARCH key:LEVEL1];
	[FileUtil setIntegerToNSUserDefaults:finderForSearch.pageNumber key:PAGE_NUMBER];
	//[FileUtil persistPoiLogos:appDelegate.searchArray];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 95134) {
        if (buttonIndex==1) {
            [appDelegate progressHudView:self.view andText:@"Loading..."];
            appDelegate.searchArray = nil;
            [self onClickUpdateRecords];
        }
    }
}


@end
