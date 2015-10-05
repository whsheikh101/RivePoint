//
//  FirstViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "MainViewController.h"
#import "RivePointAppDelegate.h"
#import "ListCouponsViewController.h"
#import "Poi.h"
#import "ListCouponsViewController.h"
#import "MainViewController.h"
#import "GeneralUtil.h"
#import "PoiFinderNew.h"
#import "FileUtil.h"
#import "LocationButtonController.h"
#import "PoiUtil.h"
#import "MapButtonController.h"
#import "MapViewController.h"
#import "LocationUpdater.h"

@implementation MainViewController


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(!appDelegate.poiArray)
		return @"";
	//if(isRequestInProgress)
	//return @"Fetching...";
	int poisCount = [getCouponFinder.poiStringsArray count];
	
	return [NSString stringWithFormat:@"%d Vendors found near %@",poisCount,[GeneralUtil updateZipFromPOIList:appDelegate.poiArray]] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	@try {
		return [PoiUtil getAppropriateCell:tableView cellForRowAtIndexPath:indexPath poiFinder:getCouponFinder 
								  poiArray:appDelegate.poiArray command:GET_COUPONS_OPT_COMMAND  
						  actualPOISInList:actualPOISInList];
		
	}@catch (NSException * e) {
		NSLog(@"(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath: Caught %@: %@", [e name], [e  reason]);
	}
    
    
	return nil;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	
	if(appDelegate.poiArray){
//		if(isMoreClicked)
//			return actualPOISInList+1;
//		
//		return indexCount+1;
        return appDelegate.poiArray.count+1;
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	@try{
		if(indexPath.row == 0){/*************** It means that Get Latest Records Cell is clicked ************/
			[appDelegate progressHudView:self.view andText:@"updating..."];
            [appDelegate.poiArray removeAllObjects];
			appDelegate.poiArray = nil;
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldShowAlert"];
			[uiTableView reloadData];
			[self submitFirstRequest];
			return;
		}
		
		if(indexPath.row > actualPOISInList){/*************** It means that More Cell is clicked ************/
			//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
			isMoreClicked=YES;
			indexCount--;
			[uiTableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationNone];
			[getCouponFinder getPoisWithCoupons:FETCH_NEXT caller:self];
			
			return;
		}
		
		
		//Initialize the detail view controller and display it.
//		if(cvController == nil)
//			cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
        if (cvController) {
//            [cvController release];
            cvController = nil;
        }
        cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
		appDelegate.currentPoiCommand = GET_COUPONS;
		appDelegate.poiId = indexPath.row-1;
		[[self navigationController] pushViewController:cvController animated:YES];
        [cvController release];
        
	}
	@catch (NSException * e) {
		NSLog(@"(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath: Caught %@: %@", [e name], [e  reason]);
	}
	
}

- (void) startActivityViewerInNewThread{
    
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[appDelegate showActivityViewer];
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
    
    
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	isAtLoadState = YES;
	[super viewDidLoad];
	[GeneralUtil setRivepointLogo:self.navigationItem];
	[self setRightBarButton:0];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
    
}

-(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup {
	@try{
		isRequestInProgress = NO;
		[self setRightBarButton:0];
//        [appDelegate.progressHud removeFromSuperview];
        NSLog(@"MainViewController");
        [appDelegate removeLoadingViewFromSuperView];
		[appDelegate hideActivityViewer];
		if(!poiDtoGroup){
            
            NSLog(@"MainViewController Called From here ... !!!");
            
			[FileUtil resetUserDefaults];
			paginationLabel.text = @"";
            [appDelegate.progressHud removeFromSuperview];
            BOOL shouldShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldShowAlert"];
            if (shouldShow == YES) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry",nil];
                alert.tag = 95134;
                [alert show];	
                [alert release];
            }
            else
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldShowAlert"];
			
			//[FlurryUtil logGetCouponsError:appDelegate.setting.zip];
			return;
			
		}
		
		if([poiDtoGroup.vector count] > 0){
			
			[self setLeftBarButton];		
			if(appDelegate.poiArray){	// It means that the List is there and we are opting for pagination option 'More'			
				BOOL isOnlyOneElement = NO;
				if([poiDtoGroup.vector count] == 1){
					isOnlyOneElement = YES;
				}
				
				if(isOnlyOneElement)	
					[uiTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:actualPOISInList-1 inSection:0 ]] withRowAnimation:UITableViewRowAnimationBottom];
				
				[appDelegate.poiArray addObjectsFromArray:poiDtoGroup.vector];
				//[indexPathsArray removeLastObject];
				NSMutableArray *indexPathsArray = [[NSMutableArray alloc]init];
				int newPoiGroupSize = [poiDtoGroup.vector count];
				
				for(int i=(isOnlyOneElement?actualPOISInList-1:actualPOISInList); i<actualPOISInList+ newPoiGroupSize-1;i++){
					lastIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
					[indexPathsArray addObject:lastIndexPath ];			
				}
				actualPOISInList = [appDelegate.poiArray count];
				indexCount = actualPOISInList;
				isMoreClicked = NO;
				
				if((isNext = poiDtoGroup.next) && !appDelegate.loadFromPersistantStore){				
					[indexPathsArray addObject:[NSIndexPath indexPathForRow:indexCount++ inSection:0]];
				}
				
				[poiDtoGroup release];
                
//				[uiTableView insertRowsAtIndexPaths:[indexPathsArray autorelease] withRowAnimation:UITableViewRowAnimationNone];
				
				if(!appDelegate.loadFromPersistantStore){
					//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
					//[GeneralUtil fillWithVendorSmallLogo:appDelegate.poiArray];
					[self persistState];
					[appDelegate hideActivityViewer];
					[self setRightBarButton:0];
//					NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:(isNext?indexCount-1:indexCount) inSection:0];
//					[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    
				}
				else{
					int page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
					if(getCouponFinder.pageNumber <  page){
						[getCouponFinder getPoisWithCoupons:FETCH_NEXT caller:self];
					}
					else{
						//[FileUtil setPoiLogos:appDelegate.poiArray];
						int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
						if(noOfLevels ==1){
							appDelegate.loadFromPersistantStore = NO;
						}
					}
					
				}
				return;
			}
			else{// For the first request, this piece of code is executed.
				
				appDelegate.poiArray = nil;
				appDelegate.poiArray = poiDtoGroup.vector;
				if(!appDelegate.loadFromPersistantStore){
					//[FlurryAPI endTimedEvent:GET_COUPONS_EVENT];
					
					//[NSThread detachNewThreadSelector:@selector(startActivityViewerInNewThread) toTarget:self withObject:nil];
					//[GeneralUtil fillWithVendorSmallLogo:appDelegate.poiArray];
					[self persistState];
					[appDelegate hideActivityViewer];
					[self setRightBarButton:0];
					
				}
				/*else{
					[FileUtil setPoiLogos:appDelegate.poiArray];
				}*/			
			}
			actualPOISInList = [appDelegate.poiArray count];
			indexCount = actualPOISInList;
			poiDtoGroup.vector = nil;
			
			isNext = poiDtoGroup.next;
			isPrevious =poiDtoGroup.previous;
			
			paginationLabel.text = [NSString stringWithFormat:@"Displaying %@ - %@ of %@"
									,poiDtoGroup.fromSequenceNumber,poiDtoGroup.toSequenceNumber,poiDtoGroup.totalPois];
		}else {
			[FileUtil resetUserDefaults];
			paginationLabel.text = @"";
            [appDelegate.progressHud removeFromSuperview];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_NO_POIS_FOUND,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
			
			poiDtoGroup.vector = nil;
			return;
		}	
		
		[poiDtoGroup release];
		int page = 0;
		if(appDelegate.loadFromPersistantStore){
			page = [FileUtil getIntegerFromNSUserDefaultsPerfs:PAGE_NUMBER];
			if(getCouponFinder.pageNumber <  page){
				[getCouponFinder getPoisWithCoupons:FETCH_NEXT caller:self];
			}
			else{
				int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
				if(noOfLevels ==1){
					appDelegate.loadFromPersistantStore = NO;
				}
			}
			
		}
		[uiTableView reloadData];
//		NSIndexPath *myIndexPath =  [NSIndexPath indexPathForRow:indexCount inSection:0];
//		[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		
//		if(isNext){ 
//			NSIndexPath *moreIndexPath =  [NSIndexPath indexPathForRow:indexCount++ inSection:0];
//			
//			[uiTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:moreIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
//			[uiTableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//		}
	}
	@catch (NSException * e) {
		NSLog(@"(void)displayResultDto:(PoiDtoGroup *) poiDtoGroup: Caught %@: %@", [e name], [e  reason]);
	}
    [appDelegate.progressHud removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Main View Controller - Receive Memory Warning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)viewDidDisappear:(BOOL)animated{
	getCouponFinder.dontDisplay = YES;
	
}

- (void)viewWillAppear:(BOOL)animated{
	
	if(appDelegate.loadFromPersistantStore){
		isAtLoadState = NO;//to be removed.
		NSString *poisString =  [FileUtil getStringFromNSUserDefaultsPerfs:POI_LIST];
		if(poisString){
			getCouponFinder = [PoiFinderNew alloc];
			[getCouponFinder loadValueThroughString:poisString commandName:GET_COUPONS_COMMAND caller:self];
			int noOfLevels = [FileUtil getIntegerFromNSUserDefaultsPerfs:NO_OF_LEVELS];
			if(noOfLevels >1){
				
				if(cvController == nil)
					cvController = [[ListCouponsViewController alloc] initWithNibName:@"ListCouponsView" bundle:nil];
				appDelegate.currentPoiCommand = GET_COUPONS;
				appDelegate.poiId = [FileUtil getIntegerFromNSUserDefaultsPerfs:POI_ID];
				[[self navigationController] pushViewController:cvController animated:NO];								
			}
			return;
		}						
	}
	
	zipCodeLabel.title = appDelegate.setting.zip; 
    [appDelegate.couponArray removeAllObjects];
	appDelegate.couponArray = nil;
	appDelegate.currentPoiCommand = GET_COUPONS;
	
	if(!appDelegate.poiArray && !isRequestInProgress){
        [appDelegate progressHudView:self.view andText:@"Loading..."];
        [uiTableView reloadData];
        [appDelegate.couponArray removeAllObjects];
        appDelegate.couponArray = nil;
//        [appDelegate removeAllFromLogoDictionaries];
//        [appDelegate removeAllFromCouponPreviewImageDictionary];
		[self submitFirstRequest];
        
		self.navigationItem.leftBarButtonItem = nil;
	}
	else{
		[self persistState];
	}
}

-(void) flushToRootOnTabChange
{
    NSLog(@"flushToRootOnTabChange");
    [appDelegate.poiArray removeAllObjects];
    [uiTableView reloadData];
    appDelegate.poiArray = nil;
//    [appDelegate removeAllFromLogoDictionaries];
//    [appDelegate removeAllFromCouponPreviewImageDictionary];
        self.navigationItem.leftBarButtonItem = nil;
}

-(void)refreshRecords{
    
    [appDelegate.poiArray removeAllObjects];
    [uiTableView reloadData];
    appDelegate.poiArray = nil;
//    [appDelegate removeAllFromLogoDictionaries];
//    [appDelegate removeAllFromCouponPreviewImageDictionary];
	[self submitFirstRequest];
	self.navigationItem.leftBarButtonItem = nil;
}
-(void)submitFirstRequest{
	
    
	[appDelegate removeAllFromLogoDictionary:GET_COUPONS_OPT_COMMAND];
	paginationLabel.text = @"";
	[uiTableView reloadData];
	if(getCouponFinder){
		[getCouponFinder cancelRequest];
		[getCouponFinder dealloc];
	}
	getCouponFinder = [[PoiFinderNew alloc]init];
	[self setRightBarButton:1];
	[getCouponFinder getPoisWithCoupons:FETCH_FIRST caller:self];
	isRequestInProgress = YES;
	//[FlurryUtil logGetCoupons:appDelegate.setting.zip];
	
}

-(void) onLocationUpdateBtnClicked
{
    LocationUpdater * locationUpdater = [appDelegate getLocationUpdatorInstance];
    [locationUpdater updateLocation:self];
}

-(void)setLocationButton{
    
//    if (!locationBarItem) {
//        UIImage * _mapImage=[UIImage imageNamed:@"pointer.png"];
//        UIButton * _mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _mapBtn.bounds = CGRectMake( 0, 0, _mapImage.size.width, _mapImage.size.height );    
//        [_mapBtn setBackgroundImage:_mapImage forState:UIControlStateNormal];
//        [_mapBtn addTarget:self action:@selector(onLocationUpdateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        locationBarItem = [[UIBarButtonItem alloc]initWithCustomView:_mapBtn];
//        [self.navigationItem setRightBarButtonItem:locationBarItem];
//        [_mapBtn release];
//    }
//    else
//        [self.navigationItem setRightBarButtonItem:locationBarItem];
    
    
	if(!locationButtonControllerRef){
		LocationButtonController *locationButtonController = [[LocationButtonController alloc] initWithNibName:@"LocationButton" bundle:nil];
		[locationButtonController setReferenceController:self];
		locationButtonControllerRef = locationButtonController;
		
		UIImageView *imgView = (UIImageView *) locationButtonController.view ;
		imgView.image=[UIImage imageNamed:@"rigntBarItem_bg.png"];
		locationBarItem = [[UIBarButtonItem alloc] initWithCustomView:imgView];
		//[locationButtonController.locationButton addTarget:locationButtonController action:@selector(showGPSAlertDialog) forControlEvents:UIControlEventTouchUpInside];
	}
	self.navigationItem.rightBarButtonItem = locationBarItem;
	
}

-(void) onMapButtonClicked
{
    MapViewController * viewController = [[MapViewController alloc]initWithNibName:@"Maps" bundle:nil];
    [viewController setMainViewController:self];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}


-(void)setLeftBarButton{
    
    
    UIImage * _mapImage=[UIImage imageNamed:@"mapicon.png"];
    UIButton * _mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapBtn.bounds = CGRectMake( 0, 0, _mapImage.size.width, _mapImage.size.height );    
    [_mapBtn setBackgroundImage:_mapImage forState:UIControlStateNormal];
    [_mapBtn addTarget:self action:@selector(onMapButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    mapBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_mapBtn];
    self.navigationItem.leftBarButtonItem = mapBarButtonItem; 
//    [_mapBtn release];
    [mapBarButtonItem release];
    
//    
//	if(!mapButtonController){
//		mapButtonController = [[MapButtonController alloc]initWithNibName:@"MapButtonController" bundle:nil];
//	}
//	[mapButtonController setReferenceController:self]; 
//	UIImageView *mapImg = (UIImageView *) mapButtonController.view;
//	mapBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mapImg];
//	self.navigationItem.leftBarButtonItem = mapBarButtonItem; 
//	[mapBarButtonItem release];
}


-(void)setRightBarButton: (int)i{
	if(i==0){
		[self setLocationButton];
	}
	else{
		[GeneralUtil setActivityIndicatorView:self.navigationItem];
	}
}

-(void) viewWillDisappear:(BOOL)animated
{
    [appDelegate.progressHud removeFromSuperview];
    [super viewWillDisappear:YES];
}

- (void)persistState{
	[FileUtil setIntegerToNSUserDefaults:1 key:NO_OF_LEVELS];
	[FileUtil setStringToNSUserDefaults:getCouponFinder.poiStringsParamValue key:POI_LIST];
	[FileUtil setIntegerToNSUserDefaults:GET_COUPONS key:LEVEL1];
	[FileUtil setIntegerToNSUserDefaults:getCouponFinder.pageNumber key:PAGE_NUMBER];
	//[FileUtil persistPoiLogos:appDelegate.poiArray];
    
}

-(void) viewDidUnload {
    
    NSLog(@"Main View Controller - Going to unload");
    
    gpsView = nil;
	uiTableView = nil;
	paginationLabel = nil;
	zipCodeLabel = nil;
	toolbar = nil;
	cvController = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    
    [gpsView release];
	[uiTableView release];
	[paginationLabel release];
	[zipCodeLabel release];
	[toolbar release];
//	[cvController release];
    
    gpsView = nil;
	uiTableView = nil;
	paginationLabel = nil;
	zipCodeLabel = nil;
	toolbar = nil;
	cvController = nil;
    
	[locationButtonControllerRef release];
//	[locationBarItem release];	
	[mapButtonController release];
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 95134) {
        if (buttonIndex==1) {
            [appDelegate progressHudView:self.view andText:@"Loading..."];
			appDelegate.poiArray = nil;
			[self submitFirstRequest];
        }
    }
}



@end
