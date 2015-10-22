//
//  RivePointAppDelegate.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RivePointAppDelegate.h"
#import "DBManager.h"
#import <CoreLocation/CoreLocation.h>
#import "GeocodeAddress.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "ProcessViewController.h"
#import "EmailViewController.h"
#import "PoiManager.h"
#import "CouponManager.h"
#import "FileUtil.h"
#import "RivepointConstants.h"
#import "PoiFinderNew.h"
#import "XMLUtil.h"
#import "VersionManager.h"
#import "LocationUpdater.h"
#import "StartupSettingsViewController.h"
#import "LocationUtil.h"
#import "RivePointSetting.h"
#import "UserProfileViewController.h"
#import "mach/mach.h"
#import "MainViewController.h"
#import "SearchVendorController.h"
#import "Reachability.h"

@implementation RivePointAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize mainController;
@synthesize listCouponsViewController;
@synthesize navController;
@synthesize gpsAlertView;
@synthesize showGPSAlert;
@synthesize setting;
@synthesize sManager;
@synthesize zipCodeLabel;
@synthesize poiArray;
@synthesize couponArray;
@synthesize searchArray;
@synthesize poiId;
@synthesize couponId;
@synthesize keyword;
@synthesize categoryId;
@synthesize currentPoiCommand;
@synthesize isNewRequest;
@synthesize browseArray;
@synthesize externalArray;
@synthesize tabBar;
@synthesize tabBarItem;
@synthesize imageLogos;
@synthesize categoryNames;
@synthesize categoryIcons;
@synthesize couponIndex;
@synthesize optionIcons;
@synthesize optionNames;
@synthesize sharedInboxArray;
@synthesize sharedPoiArray;
@synthesize sharedCouponArray;
@synthesize cotdDictinary;
@synthesize cotdPoiArray;
@synthesize senderId;
@synthesize poiIndex,startupSettingsViewController,myCouponsController;
@synthesize excludePoiId,poi,terminateRequest,loadFromPersistantStore,lastKnownLocation, loyaltyArray;
@synthesize progressHud,twitter=_twitter,shouldBackToShare;
@synthesize facebook = _facebook;
@synthesize userLoginId = _userLoginId;
@synthesize shouldNotShareAlert;
@synthesize userSubsId;

UIActivityIndicatorView *activityWheel;
UIActivityIndicatorView *activityWheelLabelled;
UIView *activityView;
UIView *activityViewLabelled;
UIImageView *defaultImageView;
ProcessViewController *waitScreenView;

-(void)showActivityViewer
{ 
	if (activityView == nil)
	{
		activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
		activityView.backgroundColor = [UIColor blackColor];
		activityView.alpha = 0.5;
		activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
		activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										  UIViewAutoresizingFlexibleRightMargin |
										  UIViewAutoresizingFlexibleTopMargin |
										  UIViewAutoresizingFlexibleBottomMargin);
		[activityView addSubview:activityWheel];
		[window addSubview: activityView];
	}
	
	[window bringSubviewToFront:activityView];
	[activityWheel startAnimating];
}

-(void)showActivityViewer:(NSString *)message
{
	if (activityViewLabelled == nil)
	{
		activityViewLabelled = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
		activityViewLabelled.backgroundColor = [UIColor blackColor];
		activityViewLabelled.alpha = 0.5;
		//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(window.bounds.size.width / 2 - 76 , window.bounds.size.height / 2 - 50, 150, 30)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 60, window.bounds.size.width, 30)];
		label.textAlignment = UITextAlignmentCenter;
		
		label.text =message;
		label.backgroundColor = [UIColor blackColor];
		label.alpha = 0.5;
		label.textColor = [UIColor whiteColor];
		activityWheelLabelled = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
		activityWheelLabelled.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		activityWheelLabelled.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										  UIViewAutoresizingFlexibleRightMargin |
										  UIViewAutoresizingFlexibleTopMargin |
										  UIViewAutoresizingFlexibleBottomMargin);
		[activityViewLabelled addSubview:activityWheelLabelled];
		[activityViewLabelled addSubview:label];
		[window addSubview: activityViewLabelled];
	}
	
	[window bringSubviewToFront:activityViewLabelled];
	[activityWheelLabelled startAnimating];
}

-(void)hideActivityViewer
{
	[activityWheel stopAnimating];
	[activityWheelLabelled stopAnimating];
	if(activityView)
		[window sendSubviewToBack:activityView];
	if(activityViewLabelled)
		[window sendSubviewToBack:activityViewLabelled];
}


- (void) initializeSetting {
	VersionManager *vm = [[VersionManager alloc] init];
	shouldUpdateLocationAtStartup = NO  ;
	BOOL isVersionTableExist = [vm isTableExist];
	if(!isVersionTableExist){
		DBManager *dbManager = [[DBManager alloc] init];
		[dbManager replaceDatabase];
		[dbManager release];
		shouldUpdateLocationAtStartup = YES;
	}
	else{
		NSString *savedVersion =  [vm getVersion];
		if(![savedVersion isEqualToString:RIVEPOINT_CLIENT_VERSION]){
			shouldUpdateLocationAtStartup = YES;
			[vm update:RIVEPOINT_CLIENT_VERSION];
		}
	}
	[vm release];
	

	if(setting ==nil){
		setting = [Setting getDefaultSetting];
		BOOL inserted = [sManager save:setting];
		if(inserted){
			NSLog(@"Settings inserted ");
		}
		else{
			NSLog(@"Failed to insert settings ");
		}
	}
}


- (void)initializeComponents {
	
	DBManager *db = [[DBManager alloc]init];
	[db checkAndCreateDatabase] ;
	
	sManager = [[SettingManager alloc]init];
	setting = [sManager find];

	[db release];
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

}
/*
void uncaughtExceptionHandler(NSException *e) {
	[FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:e];
	NSLog(@"*****Caught %@: %@", [e name], [e  reason]);

	
}*/


//-(void) fetchUserProfile
//{
//    NSString * _nStr = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
//    NSString * _sStr = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
//    NSString * _aStr = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
//    NSString * _dStr = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
//    NSString * _iStr = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
//    if (_nStr == NULL)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"Name" forKey:k_User_Name];
//    }
//    if (_sStr == NULL)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"Marital Status" forKey:k_User_Status];
//    }
//    if (_aStr == NULL)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"Address" forKey:k_User_Address];
//    }
//    if (_dStr == NULL)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"profession" forKey:k_User_Prof];
//    }
//    if (_iStr == NULL)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"Intersts" forKey:k_User_Interst];
//    }
//}

-(void) fetchUserLogedInId
{
    NSString * _uID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (_uID && _uID.length > 0)
    {
        NSLog(@"Id Found");
        _userLoginId = _uID;
    }
}


-(void) report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

#pragma mark
#pragma mark applicationDidFinishLaunching

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    if (self.networkStatus) {
        if ([self checkApplicationVersion]){
            self.alert = [[UIAlertView alloc]initWithTitle:@"New Version!!" message:@"A new version of app is available to download" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            self.alert.tag = 1;
            [self.alert show];
        }
        // Add the tab bar controller's current view as a subview of the window
        _facebook = [[Facebook alloc]initWithAppId:@"219979578145441" andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        _twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _twitter.consumerKey = TWITTER_CONSUMER_KEY;
        _twitter.consumerSecret = TWITTER_CONSUMER_SECRATE;
        self.shouldBackToShare = NO;
        self.shouldNotShareAlert = NO;
        [self fetchUserLogedInId];
        [self loadRivepointServerURLString];
        [self createCouponPreviewImageDictionary];
        [self createLogoDictionary];
        tabBarController.delegate = (id)self;
        categoryNames = [[NSArray alloc] initWithObjects:@"Coffee Shops",@"American",@"Chinese",@"Italian", @"Fast Food", @"Mexican",@"Snacks And Pizza", nil];
        categoryIcons = [[NSArray alloc] initWithObjects:@"coffee.png",@"american.png",@"chinese.png",@"italian.png",@"fastfood.png",@"mexican.png",@"snacks.png",@"Automotive.png", nil];
        
        optionNames = [[NSArray alloc] initWithObjects:@"Saved Coupons",@"Shared Coupons",@"Saved Loyalty Coupons",@"Shared Loyalty Coupons",@"Delete All Shared",@"Delete All Saved", nil];
        optionIcons = [[NSArray alloc] initWithObjects:@"save-menu.png",@"share-menu.png",@"loilttyIphoneIcon.png",@"loilttyIphoneIcon.png",@"empty-shared-menu.png",@"delete-save-menu.png", nil];
        
        [window addSubview:navController.view];
        [window addSubview:tabBarController.view];
        
        //initialize instance variables
        [self initializeComponents];
        
        
        //initialize settings from db
        [self initializeSetting];
        
        if([setting.subsId isEqualToString:@"-1"]){
            waitScreenView = [[ProcessViewController alloc] initWithNibName:@"Processing" bundle:nil];
            [window addSubview:waitScreenView.view];
            [window bringSubviewToFront:waitScreenView.view];
        }
        NSLog(@"Location:%hhd",shouldUpdateLocationAtStartup);
        if(shouldUpdateLocationAtStartup){
            
            [FileUtil resetUserDefaults];
            tabBarController.selectedViewController = settingNavController;
            locationUpdater = [[LocationUpdater alloc] init];
            navController = getCouponsNavController;
            
            startupSettingsViewController = [[StartupSettingsViewController alloc] initWithNibName:@"Processing" bundle:nil];
            [window addSubview:startupSettingsViewController.view];
            [window bringSubviewToFront:startupSettingsViewController.view];
            [locationUpdater updateLocation];
        }
        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];
        
    }
    
    

}

-(LocationUpdater *) getLocationUpdatorInstance{
	if(!locationUpdater){
		locationUpdater = [[LocationUpdater alloc] init];
	}
	return locationUpdater;
	
}
-(void) setDefaultSettings{
	if(!sManager){
		sManager = [[SettingManager alloc]init];		
	}
	self.setting = [sManager find];

}

-(void) gotoFirstPOITabFromController:(UINavigationController *)controller
{
//    [controller popToRootViewControllerAnimated:YES];
    tabBarController.selectedIndex = 0;
    
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

-(BOOL) tabBarController:(UITabBarController *)tabBarController1 shouldSelectViewController:(UIViewController *)viewController
{
//   return (tabBarController1.selectedViewController != viewController);
    for (UINavigationController *nc in tabBarController.viewControllers){
        [nc popToRootViewControllerAnimated:YES];
    }
    return YES;
}


-(void) tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController
{
    MainViewController * _mainViewController = (MainViewController*) [[tabBarController1.viewControllers objectAtIndex:0] topViewController];
    SearchVendorController * _searchViewController = (SearchVendorController *)[[tabBarController1.viewControllers objectAtIndex:2] topViewController];
    
    switch (tabBarController1.selectedIndex) {
        case 0:
            {
                if (_searchViewController) {
                    [_searchViewController flushToRootOnTabChange];
                }
                [self removeAllFromLogoDictionary:BROWSE_POI_OPT_COMMAND];
            }
            break;
        case 1:
            {
                if (_mainViewController) {
                    [_mainViewController flushToRootOnTabChange];
                }
                if (_searchViewController) {
                    [_searchViewController flushToRootOnTabChange];
                }
            }
            break;
        case 2:
            {
                if (_mainViewController) {
                    [_mainViewController flushToRootOnTabChange];
                }
                [self removeAllFromLogoDictionary:BROWSE_POI_OPT_COMMAND];
            }
            break;
        case 3:
            {
                if (_searchViewController) {
                    [_searchViewController flushToRootOnTabChange];
                }
                if (_mainViewController) {
                    [_mainViewController flushToRootOnTabChange];
                }
                [self removeAllFromLogoDictionary:BROWSE_POI_OPT_COMMAND];
            }
            break;
        case 4:
            {
                if (_searchViewController) {
                    [_searchViewController flushToRootOnTabChange];
                }
                if (_mainViewController) {
                    [_mainViewController flushToRootOnTabChange];
                }
                [self removeAllFromLogoDictionary:BROWSE_POI_OPT_COMMAND];
            }
            break;
        default:
            break;
    }
}

-(NSString*) getLocationLabel{
	return [self getLocationLabel:setting.city State:setting.state Zip:setting.zip Latitude:setting.latitude Longitude:setting.longitute];
	
}
-(NSString*) getLocationLabel:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Latitude:(NSString*)latitude Longitude:(NSString*)longitude{
	
	NSString *address = [NSString stringWithString:@""];
	if(city){
		address = [address stringByAppendingString:city];
		address = [address stringByAppendingString:@", "];
	}
	if(state){
		address = [address stringByAppendingString:state];
		address = [address stringByAppendingString:@", "];
	}
	if(zip){
		address = [address stringByAppendingString:zip];
	}
	NSString *label = @"";
	label = [label stringByAppendingString:address];
//	label = [label stringByAppendingString:@"\nLatitude: "];
//	label = [label stringByAppendingString:latitude];
//	label = [label stringByAppendingString:@"\nLongitude: "];
//	label = [label stringByAppendingString:longitude];
	return label;
}

-(void) updateSettingFromGeoCode:(GeocodeAddress*)code{
    
//    setting = [Setting getDefaultSetting];
    
    NSLog(@"updateSettingFromGeoCode In");
    
	Setting *s = [sManager find];
	s.city=code.city;
	s.state =code.state;
	s.zip = code.postalcode;
	s.latitude = code.latitude;
	s.longitute = code.longitude;
	if(setting){
        NSLog(@"if(setting){  Came In");
		[setting release];
		setting = nil;	
	}
	setting = s;
	zipCodeLabel.title = s.zip;
//	browseScreenZIPBarButton.title = s.zip;
	[sManager update:s];
//    NSLog(@"updateSettingFromGeoCode Out");
}

//-(void) updateSettingFromReverseGeoCode:(GeocodeAddress*)code{
//	Setting *s = setting;
//	s.zip = code.postalcode;
//	s.latitude = code.latitude;
//	s.longitute = code.longitude;
//	zipCodeLabel.title = s.zip;
////	browseScreenZIPBarButton.title = s.zip;
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//		NSLog(@"OK pressed");
//		
//}

//-(void) updateZipCode:(GeocodeAddress*) code{
//	
//	if(code){
//		[self updateSettingFromReverseGeoCode:code];
//
//	}
//	else{
//		NSLog(@"zip not found from latitude and longitude");
//	}
//	
//}

-(void)resetGetCouponPoiList{
	//[poiArray release];
	self.poiArray = nil;
	if(couponArray){
		//[couponArray release];
		self.couponArray = nil;
	}
	
}
-(void)resetBrowsePoiList{
//	if(browseArray){
//		//[browseArray release];
//		self.browseArray = nil;
//	}
//	if(couponArray){
//		//[couponArray release];
//		self.couponArray = nil;
//	}
}

-(void) updateSetting:(NSString*)zip enableGps:(NSString*)enableGps gpsAccuracy:(NSString*)gpsAccuracy latitude:(NSString*)latitude longitude:(NSString*)longitude{
	setting.zip = zip;
	setting.enableGPS = enableGps;
	setting.gpsAccuracy = gpsAccuracy;
	setting.latitude = latitude;
	setting.longitute = longitude;
	
	[sManager update:setting];
}

-(IBAction)hideShowMethod{
	//[searchVendorController hideShowMethod];
}

-(void) setSearchVendorController:(SearchVendorController *)svController{
	searchVendorController = svController;
	
}
-(void)checkEmail{

	if([setting.email isEqualToString:@"NotAvailable"]){
		NSLog(@"Subscriber ID present.");
		NSLog(@"Email Address not present.");
		//[self askForUserEmail];
      
	}
	else{
		
		NSLog(@"Subscriber ID present.");
		NSLog(@"Email Address present.");
        
	}
}

-(void) askForUserEmail:(NSObject *)object{
	EmailViewController *emailController = [[EmailViewController alloc] initWithNibName:@"Email" bundle:nil];
    [emailController setShareIt:(ShareIt *)object];
	[window addSubview:emailController.view];
	[window bringSubviewToFront:emailController.view];
}
-(void)showViewController:(NSString *)nibName{
	waitScreenView = [[UIViewController alloc] initWithNibName:nibName bundle:nil];
	[window addSubview:waitScreenView.view];
	[window bringSubviewToFront:waitScreenView.view];
	
}

-(BOOL) saveCoupon:(Coupon*)cpn poi:(Poi*)thepoi{
//	BOOL saved = NO;
//	BOOL cpnSaved = NO ;
//	BOOL poiSaved = NO ;
//	
//	PoiManager *pm = [[PoiManager alloc]init];
//	CouponManager *cm = [[CouponManager alloc] init];
//	
//	//handle transaction here
//	//trans Start
//	poiSaved = [pm saveOrUpdate:thepoi];
//	
//	if(poiSaved){
//		cpn.poiId = thepoi.poiId;
//		
//		cpnSaved = [cm saveOrUpdate:cpn];
//		
//		if(cpnSaved){
//			saved = cpnSaved;
//		}
//	}
//	//trans end
//	
//	[pm release];
//	[cm release];
//	
//	return saved;

    return YES;
	
}

-(BOOL) poiCouponExists:(Coupon*)cpn poi:(Poi*)thepoi{
	BOOL exists = NO ;
	CouponManager *cm = [[CouponManager alloc] init];
	
	cpn.poiId = thepoi.poiId;
	
	exists = [cm poiCouponExists:cpn];
	
	[cm release];
	
	return exists;
}


+(double) getCurrentDate{
	double d = -1;

	NSTimeInterval secondsPerDay = -1 * 24 * 60 * 60;
	NSDate *today = [NSDate date];
	NSDate *yesterday;
	
	yesterday = [today addTimeInterval:secondsPerDay];
	d = [yesterday timeIntervalSince1970];
	
	double sec = 1000.00f;
	d = d*sec;
	
	return d ;
}
-(void)showAlert:(NSString *)messageKey delegate:(NSObject *)delegate {
    [self.progressHud removeFromSuperview];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(messageKey,EMPTY_STRING) delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	
	
}

-(void) showAlertWithHeading:(NSString *)heading andDesc:(NSString *)desc
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:heading message:desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void) updateSavedCouponsTabBarItem{
	/*CouponManager *cm = [[CouponManager alloc]init];
	savedCouponsTabBar.title = [NSString stringWithFormat:@"Saved (%d)", [cm getCouponsCount]];
	[cm release];*/
}
-(IBAction)zipCodeClickMethod{
	
	[self tabBarController].selectedIndex = 4;
	
}
-(void)resetCachedObjects{
	[self resetGetCouponPoiList];

	self.searchArray = nil;
	self.externalArray = nil;
	self.excludePoiId = nil;
	self.cotdPoiArray = nil;
	self.cotdDictinary = nil;
	self.couponArray = nil;
	self.loyaltyArray = nil;
	[self removeAllFromLogoDictionaries];
	[self removeAllFromCouponPreviewImageDictionary];
	
	
}
-(void) createCouponPreviewImageDictionary{
//	if(!couponPreviewImageDictionary){
//		couponPreviewImageDictionary = [[NSMutableDictionary alloc] init];
//		couponPreviewImageDictionaryLock = [[NSLock alloc] init];
//	}
}
-(void) setCouponPreviewImageInDictionary:(UIImage *)image key:(NSString *)key{
//	if(!image || !key){
//		return;
//	}
//	[couponPreviewImageDictionaryLock lock];
//	[couponPreviewImageDictionary setObject:image forKey:key];
//	[couponPreviewImageDictionaryLock unlock];	

}
-(UIImage *) getCouponPreviewImageFromDictionary:(NSString *)key{
//	[couponPreviewImageDictionaryLock lock];
//	UIImage *logoImage= [[couponPreviewImageDictionary objectForKey:key]retain];
//	[couponPreviewImageDictionaryLock unlock];
//	return [logoImage autorelease];
    return nil;
}
-(void) removeAllFromCouponPreviewImageDictionary{
//	[couponPreviewImageDictionaryLock lock];
//	[couponPreviewImageDictionary removeAllObjects];
//	[couponPreviewImageDictionaryLock unlock];
	
}
-(void) createLogoDictionary{
//	if(!logoDictionary){
//		logoDictionary = [[NSMutableDictionary alloc] init];
//		logoDictionaryLock = [[NSLock alloc] init];		
//	}
//	if(!browseLogoDictionary){
//		browseLogoDictionary = [[NSMutableDictionary alloc] init];
//		browseLogoDictionaryLock = [[NSLock alloc] init];
//	}
//	if(!searchLogoDictionary){
//		searchLogoDictionary = [[NSMutableDictionary alloc] init];
//		searchLogoDictionaryLock = [[NSLock alloc] init];
//	}
//	if(!getCouponsLogoDictionary){
//		getCouponsLogoDictionary = [[NSMutableDictionary alloc] init];
//		getCouponsLogoDictionaryLock = [[NSLock alloc] init];
//	}
	
	
}

-(void) setImageInLogoDictinary:(UIImage *)image key:(NSString *)key command:(NSString *)command{
//	if(!image || !key){
//		return;
//	}
//	
//	if(!command){
//		[logoDictionaryLock lock];
//		[logoDictionary	setObject:image forKey:key];
//		[logoDictionaryLock unlock];
//		return;
//	}
//	
//	if([command isEqualToString:BROWSE_POI_OPT_COMMAND]){
//		[browseLogoDictionaryLock lock];
//		[browseLogoDictionary setObject:image forKey:key];
//		[browseLogoDictionaryLock unlock];		
//	}
//	else if([command isEqualToString:SEARCH_POI_OPT_COMMAND]){
//		[searchLogoDictionaryLock lock];
//		[searchLogoDictionary setObject:image forKey:key];
//		[searchLogoDictionaryLock unlock];		
//	}
//	else if([command isEqualToString:GET_COUPONS_OPT_COMMAND]){
//		[getCouponsLogoDictionaryLock lock];
//		[getCouponsLogoDictionary setObject:image forKey:key];
//		[getCouponsLogoDictionaryLock unlock];		
//	}
	
}
-(UIImage *) getImageFromLogoDictionary:(NSString *)key command:(NSString *)command{
//	if(!command){
//		[logoDictionaryLock lock];
//		UIImage *logoImage= [[logoDictionary objectForKey:key]retain];
//		[logoDictionaryLock unlock];
//		return [logoImage autorelease];
//	}
//	if([command isEqualToString:BROWSE_POI_OPT_COMMAND]){
//		[browseLogoDictionaryLock lock];
//		UIImage *logoImage= [[browseLogoDictionary objectForKey:key]retain];
//		[browseLogoDictionaryLock unlock];
//		return [logoImage autorelease];
//	}
//	else if([command isEqualToString:SEARCH_POI_OPT_COMMAND]){
//		[searchLogoDictionaryLock lock];
//		UIImage *logoImage= [[searchLogoDictionary objectForKey:key]retain];
//		[searchLogoDictionaryLock unlock];
//		return [logoImage autorelease];
//		
//	}
//	else if([command isEqualToString:GET_COUPONS_OPT_COMMAND]){
//		[getCouponsLogoDictionaryLock lock];
//		UIImage *logoImage= [[getCouponsLogoDictionary objectForKey:key]retain];
//		[getCouponsLogoDictionaryLock unlock];
//		return [logoImage autorelease];
//	}
	return nil;
}
-(void) removeAllFromLogoDictionary:(NSString *)command{
//	if(!command){
//		[logoDictionaryLock lock];
//		[logoDictionary removeAllObjects];
//		[logoDictionaryLock unlock];
//		return;
//	}
//	if([command isEqualToString:BROWSE_POI_OPT_COMMAND]){
//		[browseLogoDictionaryLock lock];
//		[browseLogoDictionary removeAllObjects];
//		[browseLogoDictionaryLock unlock];
//	}
//	else if([command isEqualToString:SEARCH_POI_OPT_COMMAND]){
//		[searchLogoDictionaryLock lock];
//		[searchLogoDictionary removeAllObjects];
//		[searchLogoDictionaryLock unlock];
//	}
//	else if([command isEqualToString:GET_COUPONS_OPT_COMMAND]){
//		[getCouponsLogoDictionaryLock lock];
//		[getCouponsLogoDictionary removeAllObjects];
//		[getCouponsLogoDictionaryLock unlock];
//	}
}
-(void) loadRivepointServerURLString{
	if(!rivePointServerURL){
		NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
		NSString *urlFileName = @"url";
		NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
		rivePointServerURL = [[NSString alloc] initWithContentsOfFile:urlPathString];
	}
}
-(NSString *) getRivepointServerURLString{
	return rivePointServerURL;
	
}
-(void) removeAllFromLogoDictionaries{

//	[logoDictionaryLock lock];
//	[logoDictionary removeAllObjects];
//	[logoDictionaryLock unlock];
//
//	[browseLogoDictionaryLock lock];
//	[browseLogoDictionary removeAllObjects];
//	[browseLogoDictionaryLock unlock];
//
//	[searchLogoDictionaryLock lock];
//	[searchLogoDictionary removeAllObjects];
//	[searchLogoDictionaryLock unlock];
//
//	[getCouponsLogoDictionaryLock lock];
//	[getCouponsLogoDictionary removeAllObjects];
//	[getCouponsLogoDictionaryLock unlock];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
	[self removeAllFromLogoDictionaries];
	[self removeAllFromCouponPreviewImageDictionary];
}


-(void) SwitchToTabWithIndex:(int) index
{
    [self.tabBarController setSelectedIndex:index];
}


#pragma mark MBProgressHud Function

-(void) hudWasHidden
{
    //NSLog(@"hudWasHidden");
}

-(void) removeLoadingViewFromSuperView
{
    [self.progressHud removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void) progressHudView : (UIView *) view andText:(NSString *)message
{
    progressHud = [[MBProgressHUD alloc] initWithView:view];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = message;
    [view addSubview:progressHud];
    progressHud.delegate = self;
	[progressHud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    view.userInteractionEnabled = NO;
}


#pragma mark Facebook Session Delegate

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_FB_Share_Notification object:nil userInfo:nil];
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
    //NSLog(@"Facebook login fail to make session");
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"])
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    [self showAlertWithHeading:@"RivePoint" andDesc:@"Internet connection appears to be offline!"];
}

#pragma mark Twitter Session Delegate

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
    NSLog(@"storeCachedTwitterOAuthData User Name : %@",username);
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    NSLog(@"cachedTwitterOAuthDataForUsername User Name : %@",username);
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier
{
	//NSLog(@"Request %@ succeeded", requestIdentifier);
//    [self hideActivityViewer];
    [self.progressHud removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if (self.shouldNotShareAlert == NO)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Coupon tweet on your timeline" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release]; 
        [self showAlertWithHeading:@"Twitter" andDesc:@"Coupon tweet on your timeline."];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Tweet_Successful object:nil userInfo:nil];
    }
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
//    [self hideActivityViewer];
    [self.progressHud removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if (self.shouldNotShareAlert == NO) {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Coupon tweet on your timeline has fail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        [self showAlertWithHeading:@"Twitter" andDesc:@"Coupon tweet on your timeline has fail."];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Tweet_Fail object:nil userInfo:nil];
    }
}


#pragma mark - Check For Force Update
-(BOOL)checkApplicationVersion{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=03276338"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    NSString *itunesVersion;
    NSArray *configData = [json valueForKey:@"results"];
    if (configData == nil) {
        if (configData <= 0) {
            return NO;
        }else{
            for (id config in configData){
                itunesVersion = [config valueForKey:@"version"];
            }
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
            NSString *version = infoDictionary[@"CFBundleShortVersionString"];
            
            if ([version doubleValue]>=[itunesVersion doubleValue]) {
                return NO;
            }
            else{
                return YES;
            }
        }
        
    }else{
        return NO;
    }
    
}
/*
#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/id303276338";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    
}*/

//Checking the network status.....
- (BOOL)networkStatus {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus network = [reach currentReachabilityStatus];
    if (network == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The Internet connection appears to be offline." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //alert.tag = InternetAlertViewTag;
        [alert show];
        return NO;
    } else {
        return YES;
    }
}


- (void)dealloc {
	[rivePointServerURL release];
	
	[logoDictionaryLock release];
//	[logoDictionary release];
	
	[searchLogoDictionaryLock release];
//	[searchLogoDictionary release];
	
	[browseLogoDictionaryLock release];
//	[browseLogoDictionary release];
	
	[getCouponsLogoDictionaryLock release];
//	[getCouponsLogoDictionary release];
	
	[imageLogos release];
    [tabBarController release];
    [window release];
	[setting release];
	[sManager release];

	[lastKnownLocation release];
	[zipCodeLabel release];

	[poiArray release];

	[couponArray release];

	[browseArray release];

	[searchArray release];
	
	[loyaltyArray release];

	[sharedInboxArray release];
	[sharedPoiArray release];
	[sharedCouponArray release];
	[cotdDictinary release];
	[cotdPoiArray release];
	
	[poi release];
	
	[keyword release];
	[categoryId release];
	[categoryNames release];
	[categoryIcons release];
	[optionNames release];
	[optionIcons release];
	
	[excludePoiId release];
	[startupSettingsViewController release];
    [super dealloc];
}
@end

