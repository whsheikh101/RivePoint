//
//  FirstViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/05/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//
#import "BrowseVendorController.h"
#import "RivePointAppDelegate.h"
#import "ListCouponsViewController.h"
#import "PoiDtoGroup.h"
#import "Poi.h"
#import "ListCouponsViewController.h"
#import "GeneralUtil.h"
#import "FileUtil.h"
#import "PoiUtil.h"


@implementation BrowseVendorController

@synthesize shouldReturnToRoot;
	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(!appDelegate.browseArray)
		return @"";

	int poisCount = [finderForBrowse.poiStringsArray count];
	
	return [NSString stringWithFormat:@"%d Vendors found near %@",poisCount,[GeneralUtil updateZipFromPOIList:appDelegate.browseArray]];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [PoiUtil getAppropriateCell:tableView cellForRowAtIndexPath:indexPath poiFinder:finderForBrowse 
							  poiArray:appDelegate.browseArray command:BROWSE_POI_OPT_COMMAND 
					  actualPOISInList:actualPOISInList];	
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.browseArray){
//		if(isMoreClicked)
//			return actualPOISInList+1;
//		
//		return indexCount+1;
        return appDelegate.browseArray.count+1;
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.row == 0){/*************** It means that Get Latest Records Cell is clicked ************/
		//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
		appDelegate.browseArray = nil;
        NSLog(@"Create Three");
		[appDelegate progressHudView:self.view andText:@"updating..."];
		[uiTableView reloadData];
		[self submitFirstRequest];
		return;
	}
	
	if(indexPath.row > actualPOISInList ){/*************** It means that More Cell is clicked ************/

		//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
		isMoreClicked=YES;
		indexCount--;
		[uiTableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationNone];

		[finderForBrowse getPoisWithCoupons:FETCH_NEXT caller:self];
		
		return;
	}
	
	
	//Initialize the detail view controller and display it.
	if(cvController)
        cvController = nil;
    cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
	Poi *poi = [appDelegate.browseArray objectAtIndex:indexPath.row-1];
	if([poi.couponCount intValue] > 0){ 
		appDelegate.currentPoiCommand = BROWSE;
		appDelegate.poiId = indexPath.row-1;
		shouldReturnToRoot = NO;
        isGoingForword = YES;
		[cvController setBrowseVendorController:self];
		[[self navigationController] pushViewController:cvController animated:YES];
        [cvController release];
	}
	else{
		[appDelegate showAlert:NSLocalizedString(KEY_NO_COUPON_FOUND,EMPTY_STRING) delegate:appDelegate];
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
	 self.navigationItem.title = @"Vendor List";
     isGoingForword = NO;
 }

-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup {
    
     NSLog(@"BrowseVenderController Called From here ... !!!");
	[self setRightBarButton:0];
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
	if(!poiDtoGroup){
        [appDelegate.progressHud removeFromSuperview];
		[FileUtil resetUserDefaults];
		paginationLabel.text = @"";
//		[appDelegate showAlert:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:appDelegate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry",nil];
        alert.tag = 95134;
        [alert show];	
        [alert release];
		//[FlurryUtil logBrowsePOISError:appDelegate.categoryId zipCode:appDelegate.setting.zip];
		return;
	}
	if([poiDtoGroup.vector count] > 0){
		
		if(appDelegate.browseArray){
			BOOL isOnlyOneElement = NO;
			if([poiDtoGroup.vector count] == 1){
				isOnlyOneElement = YES;
			}
			
			if(isOnlyOneElement)	
				[uiTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:actualPOISInList-1 inSection:0 ]] withRowAnimation:UITableViewRowAnimationBottom];
			[appDelegate.browseArray addObjectsFromArray:poiDtoGroup.vector];
			NSMutableArray *indexPathsArray = [[NSMutableArray alloc]init];
			int newPoiGroupSize = [poiDtoGroup.vector count];
			for(int i=(isOnlyOneElement?actualPOISInList-1:actualPOISInList); i<actualPOISInList+ newPoiGroupSize-1;i++){
				lastIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
				[indexPathsArray addObject:lastIndexPath ];
			}
			actualPOISInList = [appDelegate.browseArray count];
			indexCount = actualPOISInList;
			isMoreClicked = NO;
			if((isNextRecord = poiDtoGroup.next) && !appDelegate.loadFromPersistantStore){
				
				[indexPathsArray addObject:[NSIndexPath indexPathForRow:indexCount++ inSection:0]];
			}
			[poiDtoGroup release];
			
			[uiTableView insertRowsAtIndexPaths:[indexPathsArray autorelease] withRowAnimation:UITableViewRowAnimationBottom];	

			if(!appDelegate.loadFromPersistantStore){
				
				//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
				//[GeneralUtil fillWithVendorSmallLogo:appDelegate.browseArray];

				[self persistState];
				[appDelegate hideActivityViewer];
				[self setRightBarButton:0];
				NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:(isNextRecord?indexCount-1:indexCount) inSection:0];
				[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
			}
			else{
				int page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
				if(finderForBrowse.pageNumber <  page){
					[finderForBrowse browsePois:FETCH_NEXT categoryId:appDelegate.categoryId caller:self];
				}
				else{
					int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
					if(noOfLevels ==2){
						appDelegate.loadFromPersistantStore = NO;
					}
					//[FileUtil setPoiLogos:appDelegate.browseArray];
				}
			}
            [appDelegate.progressHud removeFromSuperview];
			return;
		}
		else{
			
			appDelegate.browseArray = nil;
			appDelegate.browseArray = poiDtoGroup.vector;
			if(!appDelegate.loadFromPersistantStore){
				//[FlurryAPI endTimedEvent:BROWSE_COUPONS_EVENT];
				//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
				//[GeneralUtil fillWithVendorSmallLogo:poiDtoGroup.vector];
				[self persistState];
				[appDelegate hideActivityViewer];
				[self setRightBarButton:0];
			}
			/*else{
				[FileUtil setPoiLogos:appDelegate.browseArray];
			}*/
		}

		poiDtoGroup.vector = nil;
		actualPOISInList = [appDelegate.browseArray count];
		indexCount = actualPOISInList;
		isNextRecord = poiDtoGroup.next;
		isPreviousRecord =poiDtoGroup.previous;
		paginationLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ of %@",self.navigationItem.title,
							poiDtoGroup.fromSequenceNumber,poiDtoGroup.toSequenceNumber,poiDtoGroup.totalPois];
	}
	else {
		[FileUtil resetUserDefaults];
		paginationLabel.text = @"";
		[appDelegate showAlert:NSLocalizedString(KEY_NO_POIS_FOUND,EMPTY_STRING) delegate:appDelegate];
		[[self navigationController] popToRootViewControllerAnimated:YES];
		return;
	}
	int page = 0;
	if(appDelegate.loadFromPersistantStore){
		page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
		if(finderForBrowse.pageNumber <  page){
			[finderForBrowse browsePois:FETCH_NEXT categoryId:appDelegate.categoryId caller:self];
		}
		else{
			int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
			if(noOfLevels ==2){
				appDelegate.loadFromPersistantStore = NO;
			}
		}
	}
	[poiDtoGroup release];
	[uiTableView reloadData];
//	NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:indexCount inSection:0];
//	[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//	if(isNextRecord){
//		[uiTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexCount++ inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//		[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//	}	
    
    [appDelegate.progressHud removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    NSLog(@"Browse View Controller - Receive Memory Warning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)viewDidDisappear:(BOOL)animated{
	finderForBrowse.dontDisplay = YES;
}

- (void)viewWillAppear:(BOOL)animated{
	
    NSLog(@"viewWillAppear");
    
 	self.shouldReturnToRoot = YES;
    isGoingForword = NO;
	appDelegate.couponArray = nil;
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
	appDelegate.currentPoiCommand = 1;
	if([appDelegate.categoryId isEqualToString:@"9996"])
		self.navigationItem.title = @"Coffee Shops";
	else if([appDelegate.categoryId isEqualToString:@"4"])
		self.navigationItem.title = @"American Food";
	else if([appDelegate.categoryId isEqualToString:@"3"])
		self.navigationItem.title = @"Chinese Food";
	else if([appDelegate.categoryId isEqualToString:@"9"])
		self.navigationItem.title = @"Italian Food";
	else if([appDelegate.categoryId isEqualToString:@"27"])
		self.navigationItem.title = @"Fast Food";
	else if([appDelegate.categoryId isEqualToString:@"47"])
		self.navigationItem.title = @"Mexican Food";
	else if([appDelegate.categoryId isEqualToString:@"58"])
		self.navigationItem.title = @"Snacks & Pizza";
    else if([appDelegate.categoryId isEqualToString:@"7538"])
		self.navigationItem.title = @"Automotive";

	
	if(appDelegate.loadFromPersistantStore){
		isAtLoadState = NO;//to be removed.

		NSString *poisString =  [FileUtil getStringFromNSUserDefaultsPerfs:POI_LIST];
		if(poisString){
			finderForBrowse = [PoiFinderNew alloc];
			[finderForBrowse loadValueThroughString:poisString commandName:BROWSE_POI_OPT_COMMAND caller:self];
			int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
			if(noOfLevels >2){
				//[appDelegate showAlert:@"Last Saved State is being restored." delegate:self];
				if(cvController == nil)
					cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
				appDelegate.currentPoiCommand = BROWSE;
				appDelegate.poiId = [FileUtil getIntegerFromNSUserDefaultsPerfs:POI_ID];
				shouldReturnToRoot = NO;
				[cvController setBrowseVendorController:self];
				[[self navigationController] pushViewController:cvController animated:NO];
				
			}
			return;
		}
	}
	else
        [appDelegate.progressHud removeFromSuperview];
	if(!appDelegate.browseArray || appDelegate.browseArray.count == 0){
        NSLog(@"Create Four");
        [appDelegate progressHudView:self.view andText:@"Loading..."];
		[self submitFirstRequest];
	}
	else{
		[self persistState];
		[self setRightBarButton:0];
	}
}

-(void)submitFirstRequest{
	[appDelegate removeAllFromLogoDictionary:BROWSE_POI_OPT_COMMAND];
//	[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
	paginationLabel.text = @"";
	[uiTableView reloadData];
	if(finderForBrowse){
		[finderForBrowse cancelRequest];
		[finderForBrowse dealloc];
	}
	finderForBrowse = [[PoiFinderNew alloc]init];
//	[self setRightBarButton:1];
	[finderForBrowse browsePois:FETCH_FIRST categoryId:appDelegate.categoryId caller:self];
	//[FlurryUtil logBrowsePOIS:appDelegate.categoryId zipCode:appDelegate.setting.zip];
}
-(void)setRightBarButton: (int)i{
	if(i==0){
        [appDelegate.progressHud removeFromSuperview];
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
//		[GeneralUtil setActivityIndicatorView:self.navigationItem];
        NSLog(@"Create One");
        [appDelegate progressHudView:self.view andText:@"Loading..."];
	}
}

-(void) viewWillDisappear:(BOOL)animated
{
    [appDelegate.progressHud removeFromSuperview];
    if (isGoingForword == NO) {
        [appDelegate.browseArray removeAllObjects];
        [uiTableView reloadData];
    }
    [super viewWillDisappear:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 95134) {
        if (buttonIndex==1) {
            
            appDelegate.browseArray = nil;
            NSLog(@"Create Two");
            [appDelegate progressHudView:self.view andText:@"Loading..."];
            [self submitFirstRequest];
        }
    }
    else
    {
        if(buttonIndex == 0){
            if(appDelegate.loadFromPersistantStore){
                isAtLoadState = NO;//to be removed.
                
                int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
                if(noOfLevels >2){
                    
                    if(cvController == nil)
                        cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
                    appDelegate.currentPoiCommand = BROWSE;
                    appDelegate.poiId = [FileUtil getIntegerFromNSUserDefaultsPerfs:POI_ID];
                    shouldReturnToRoot = NO;
                    [cvController setBrowseVendorController:self];
                    [[self navigationController] pushViewController:cvController animated:YES];
                }
            }		
            return;
        }
    }
    alertView.delegate = nil;
}
-(void) persistState{
	[FileUtil setIntegerToNSUserDefaults:2 key:NO_OF_LEVELS];
	[FileUtil setStringToNSUserDefaults:finderForBrowse.poiStringsParamValue key:POI_LIST];
	[FileUtil setIntegerToNSUserDefaults:BROWSE key:LEVEL1];
	[FileUtil setIntegerToNSUserDefaults:finderForBrowse.pageNumber key:PAGE_NUMBER];
	//[FileUtil persistPoiLogos:appDelegate.browseArray];
	[FileUtil setStringToNSUserDefaults:appDelegate.categoryId key:CATEGORY_ID];
	
}

-(void) viewDidUnload {
    
    NSLog(@"Browse View Controller - View Did Unload");
    [super viewDidUnload];
//    gpsView = nil;
	uiTableView = nil;
	paginationLabel = nil;
//	toolbar = nil;
	cvController = nil;
    
}

- (void)dealloc {
    NSLog(@"Browse View Controller dealloc In");
//    [gpsView release];
	[uiTableView release];
	[paginationLabel release];
//	[toolbar release];
	[cvController release];
    [finderForBrowse release];

//	gpsView = nil;
	uiTableView = nil;
	paginationLabel = nil;
//	toolbar = nil;
	cvController = nil;
    finderForBrowse = nil;
	
	[super dealloc];
    NSLog(@"Browse View Controller dealloc Out");
}

@end
