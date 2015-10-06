//
//  SettingsViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/11/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "Setting.h"
#import "SettingManager.h"
#import "GeocodeAddress.h"
#import "SettingsView.h"
#import "MapViewController.h"
#import "FileUtil.h"
#import "RivepointConstants.h"
@class AppDelegate;

@implementation SettingsViewController




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
- (IBAction) zipCodeChanged:(id) sender 
{
//	NSLog(@"ZipCode Changed");
//	NSLog(@"%@", zipCode.text);
	if (zipCode.text.length == 5)
	{
		//FlurryUtil logSettings:zipCode.text];
		[zipCode resignFirstResponder];
//		cancelBarButtonItem.enabled = NO;
		[self getGeoCodeAddress:zipCode.text];
		[FileUtil resetUserDefaults];
		
	}
	
	

}

-(void) updateZipCode:(GeocodeAddress*) code{
	
	if( ![code.resultcode isEqualToString:@"A1XAX"] ){
		
		SettingsView *sview = (SettingsView *)self.view;
		[sview setOverlayViewController:ovController];
		UITextView *geoCode =  sview.geoCode;

		NSString *latitude = [NSString stringWithString:code.latitude];
		NSString *longitude = [NSString stringWithString:code.longitude];
		
		NSString *label = [appDelegate getLocationLabel:code.city State:code.state Zip:code.postalcode Latitude:latitude Longitude:longitude];
		
//		NSLog(@"latitude %@" , latitude) ;
//		NSLog(@"longitude %@" , longitude) ;
//		NSLog(@"label %@" , label) ;
//		
		geoCode.text = label ;
		
//		NSLog(@"done....");

		[appDelegate updateSettingFromGeoCode:code];

	}
	else{
		[self showInvalidZipAlert];
//		NSLog(@"invalid zip code");
	}

}

- (void)showInvalidZipAlert{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_INVALID_ZIP_CODE, EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	
}
- (void)showErrorAlert{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	
}

-(void) processHttpResponse:(NSData *) response{
	NSError *error;
	XMLParser *p = [[XMLParser alloc] parseXMLFromData:response className:@"GeocodeAddress" parseError:error];
	
	NSMutableArray *arr = [p getArray];
	GeocodeAddress *code = [arr objectAtIndex:0];
	if(!([code.latitude length]==0)  || !([code.longitude length] == 0)){
		[self updateZipCode: code];
		[self resetCachedObjects];
	}else {
		[self communicationError:@""];
	}

	[adaptor release];
	[p release];
	[response release];
		
//	[appDelegate hideActivityViewer];
    NSLog(@"SettingViewController");
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
	[self removeOverlay];
	//[FlurryAPI endTimedEvent:SETTINGS_EVENT];
}

-(void)communicationError:(NSString *)errorMsg{

	//[FlurryUtil logSettingsError:zipCode.text];
//	[appDelegate hideActivityViewer];
//    [appDelegate.progressHud removeFromSuperview];
     NSLog(@"SettingViewController");
    [appDelegate removeLoadingViewFromSuperView];
	[self showErrorAlert];
}

- (void) getGeoCodeAddress:(NSString*)newZip{
	
	[self removeOverlay];
//	[appDelegate showActivityViewer];
    [appDelegate progressHudView:self.view andText:@"updating"];
	adaptor = [[HttpTransportAdaptor alloc]init];
	NSString* reqXML = [CommandUtil getXMLForGeoCodeAdressCommand:newZip userId:appDelegate.setting.subsId];
	[adaptor sendXMLRequest:[reqXML copy] referenceOfCaller:self];
	
	[reqXML release];

}

- (void)initializeComponents {
	appDelegate  = (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	//Setting *s = appDelegate.setting;
	Setting *s = [appDelegate.sManager find];
	
	zipCode.text = s.zip ;
	
	SettingsView *sview = (SettingsView *)self.view;
//	sview.cancelBarButtonItem = cancelBarButtonItem;
	UITextView *geoCode =  sview.geoCode;
	sview.overlayViewController =  ovController;
	NSString *label = [appDelegate getLocationLabel:s.city State:s.state Zip:s.zip Latitude:s.latitude Longitude:s.longitute];
	geoCode.text = label ;
	
	//[appDelegate.sManager update:s];
	[s release];

}

- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    // This key must match the key in postNotificationWithString: exactly.
    if ([appDelegate.facebook isSessionValid]) {
        [btnFB setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    }
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.parentViewController.title = @"Settings";
//	UIImageView *imgView = (UIImageView *) self.view ;
//	imgView.image=[UIImage imageNamed:@"settingBg.png"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    
//	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RivePoint-topBar-logo.png"]];
//	self.navigationItem.titleView = view;
//	[view release];
	
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(useNotificationWithString:) 
	 name:@"facebookloginnotification"
	 object:nil];

	//[imgView release];
    
    bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, 450);

}

-(void) viewDidUnload{
    appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
    btnEmail = nil;
    btnFB = nil;
    btnTwtr = nil;
    zipCode = nil;
    bgScrollView = nil;
    logoutBtn = nil;
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	[self initializeComponents];
	SettingsView *settingsViewRef = (SettingsView *)self.view;
	[settingsViewRef initializeComponents];
	//self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	//UITabBarItem *tabItem =  appDelegate.tabBarItem;
	//tabItem.title = @"Saved (10)";
    NSString * _userLID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (_userLID && _userLID.length > 0 ) {
        [logoutBtn setHidden:NO];
    }
    else
        [logoutBtn setHidden:YES];
    
    if ([appDelegate.facebook isSessionValid]) {
        [btnFB setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    }
    else
        [btnFB setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    
    BOOL _isEmai = [[NSUserDefaults standardUserDefaults] boolForKey:k_Email_Enable];
    
    if (_isEmai == YES) {
        [btnEmail setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    }
    else
        [btnEmail setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        
    if ([appDelegate.twitter isAuthorized])
    {
        [btnTwtr setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnTwtr setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }

    
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

- (void)viewDidDisappear:(BOOL)animated{
	zipCode.text = [NSString stringWithString:appDelegate.setting.zip];
}

- (IBAction) onClickToChange{
//	cancelBarButtonItem.enabled = YES;
	//Add the overlay view.
	[self placeOverlayController];
	SettingsView *sview = (SettingsView *)self.view;
	[sview setOverlayViewController:ovController];
	[self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	
}
- (IBAction) onClickCancelButton{
	[self removeOverlay];
//	cancelBarButtonItem.enabled = NO;
	[zipCode resignFirstResponder];
	zipCode.text = appDelegate.setting.zip;
}
-(void) removeOverlay{
	if(nil!=ovController){
		[ovController.view removeFromSuperview];
		[ovController release];
		ovController = nil;
	}
}

-(void)hideOverlay{
	[self onClickCancelButton];
//	[searchBar resignFirstResponder];
	
}

-(void) placeOverlayController{
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:nil];
	
	//CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 0, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	//ovController.rvController = self;
	[ovController setSearchVendorController:self];
}
-(void)resetCachedObjects{
	[appDelegate resetGetCouponPoiList];
	if(appDelegate.searchArray){
		appDelegate.searchArray = nil;
		
	}
	appDelegate.externalArray = nil;
	appDelegate.excludePoiId = nil;
	appDelegate.cotdPoiArray = nil;
	appDelegate.cotdDictinary = nil;
	appDelegate.couponArray = nil;
	
	[appDelegate removeAllFromLogoDictionaries];
	[appDelegate removeAllFromCouponPreviewImageDictionary];
	
}
- (IBAction) showCurrentLocation{
	if(!mapViewController){
		
		mapViewController = [[MapViewController alloc] initWithNibName:@"Maps" bundle:nil];
		
	}
	/*else{
		
		[mapViewController setMapPosition:[appDelegate.setting.latitude doubleValue] 
								longitude:[appDelegate.setting.longitute doubleValue]];
	}*/
	[self.navigationController presentModalViewController:mapViewController animated:YES];

	
}
- (void)dealloc {
	[mapViewController release];
    [btnFB release];
    [btnEmail release];
    [btnTwtr release];
    [zipCode release];
    [bgScrollView release];
    [logoutBtn release];
    logoutBtn = nil;
    bgScrollView = nil;
    btnEmail = nil;
    btnFB = nil;
    btnTwtr = nil;
    zipCode = nil;
    [super dealloc];
}


-(void)facebookLogin
{
    if (![appDelegate.facebook isSessionValid])
    {

        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                @"user_about_me",
                                @"user_status",
                                @"friends_about_me",
                                nil];
        [appDelegate.facebook authorize:permissions];
        [permissions release];
    }
    
}

-(void) twitterLogin
{
    
    if (![appDelegate.twitter isAuthorized])
    {
        
        [appDelegate.twitter requestRequestToken];
        UIViewController *controller = [[SA_OAuthTwitterController  controllerToEnterCredentialsWithTwitterEngine:appDelegate.twitter delegate:self] retain];  
        [self presentModalViewController: controller animated: YES];
    }	
}



-(IBAction) onFacebookBtn:(id)sender
{
    NSLog(@"onFacebookBtn");
    UIButton * _btn = (UIButton *)sender;
    if ([appDelegate.facebook isSessionValid])
    {
        [appDelegate.facebook logout:appDelegate];
        [_btn setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self facebookLogin];
    }
}

-(IBAction) onTwitterBtn:(id)sender
{
    NSLog(@"onTwitterBtn");
    UIButton * _btn = (UIButton *)sender;
    if ([appDelegate.twitter isAuthorized])
    {
        [appDelegate.twitter clearAccessToken];
        [appDelegate.twitter clearsCookies];
        [_btn setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self twitterLogin];
    }
}

-(IBAction) onEmailBtn:(id)sender
{
    NSLog(@"onEmailBtn");
    BOOL _isEmai = [[NSUserDefaults standardUserDefaults] boolForKey:k_Email_Enable];
    if (_isEmai == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:k_Email_Enable];
        [btnEmail setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
    else
        if (_isEmai == NO) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k_Email_Enable];
            [btnEmail setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
        }
}

-(IBAction) onLogOutBtn:(id)sender
{
    NSLog(@"LogOutBtn");
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:k_LoggedIn_User_Id];
    [userDefault removeObjectForKey:k_User_Email];
    [userDefault removeObjectForKey:k_User_Password];
//    appDelegate.userLoginId = @"";
    [logoutBtn setHidden:YES];
}

#pragma mark -
#pragma mark SA_TwiterEngineViewController Delegate


- (void)dialogDidComplete:(FBDialog *)dialog
{
    if ([appDelegate.facebook isSessionValid]) {
        NSLog(@"here You can change Image");
    }
    else
        NSLog(@"You can change image here also...:P");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Internet connection appears to be offline!"];
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
	NSLog(@"Twitter Authenicated for %@", username);
    [btnTwtr setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Canceled.");
}


@end
