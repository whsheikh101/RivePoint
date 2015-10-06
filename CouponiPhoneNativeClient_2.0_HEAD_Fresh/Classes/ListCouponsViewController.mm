//
//  ListCouponsViewController.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "ListCouponsViewController.h"
#import "RivePointAppDelegate.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "GeneralUtil.h"
#import "FileUtil.h"
#import "PoiFinderNew.h"
#import "PoiUtil.h"
#import "MapViewController.h"
//#import "ZXingWidgetController.h"
//#import "QRCodeReader.h"
#import "ReviewRatingViewController.h"
#import "ViewPhotosViewVontroller.h"
#import "FavoritePoiUtils.h"
#import "ASIFormDataRequest.h"
#import "XMLUtil.h"
#import "RivepointConstants.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@implementation ListCouponsViewController
@synthesize coupon;
@synthesize reviewCountLbl;
@synthesize isFavoritePOI;
@synthesize curPOI = _curPOI;

#define COUPON_LIST_CELL_HEIGHT 96
#define COUPON_ARRAY @"couponArray"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *couponCell = @"CouponViewCell";
	CouponViewCell *cell = (CouponViewCell *)[tableView dequeueReusableCellWithIdentifier:couponCell];
	
	if(nil == cell) {
		UIViewController *c = [[UIViewController alloc] initWithNibName:couponCell bundle:nil];
		cell = (CouponViewCell *) c.view;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		[cell setAttibutesOnLoad];
		[c release];
	}
	if(appDelegate.couponArray){
		[cell setCouponContent:[appDelegate.couponArray objectAtIndex:indexPath.row]];
		cell.couponIndex = indexPath.row;
	}
		
	
	[cell setUIViewController:self];
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(appDelegate.couponArray)
		return [appDelegate.couponArray count];
	
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return COUPON_LIST_CELL_HEIGHT;
}

-(void) twitterLogin
{
    if (![appDelegate.twitter isAuthorized])
    {
        
        [appDelegate.twitter requestRequestToken];
        UIViewController *controller = [[SA_OAuthTwitterController  controllerToEnterCredentialsWithTwitterEngine:appDelegate.twitter delegate:self] retain];
        shouldReturnToRoot = NO;
        [self presentModalViewController: controller animated: YES];
    }	
}

#pragma mark -
#pragma mark RivePoint Login


-(void) callRegisterToRP
{
    NSLog(@"callRegisterToRP");
    shouldReturnToRoot = NO;
    isArranged = YES;
    RegisterViewController * viewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    viewController.calledType = 1;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
}

-(void) callLoginPageToRP
{
    NSLog(@"callLoginPageToRP");
    shouldReturnToRoot = NO;
    isArranged = YES;
    LoginViewController * loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.CalledType = 1;
    [self presentModalViewController:loginViewController animated:YES];
    [loginViewController release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRegisterToRP) name:k_RP_Register_Call object:nil];
}

#pragma mark -
#pragma mark SA_TwiterEngineViewController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
    NSLog(@"OAuthTwitterController");
	[[NSNotificationCenter defaultCenter] postNotificationName:k_Twitter_LoggedIn_Notification object:nil userInfo:nil];
    controller.delegate = nil;
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Canceled.");
}



/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
 */

-(void) arrangePOIDataForFirstScreen
{
    poi = [GeneralUtil getPoi];
	vendorLabel.text = poi.name;
	userPointsLabel.text = [poi.userPoints stringByAppendingFormat:@" points"];
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
	if([poi.isSponsored isEqualToString:@"true"])
		distanceLabel.text = @"";		
	else{
		distanceLabel.text = [NSString stringWithFormat:@"%@ miles", (poi.distance = [GeneralUtil truncateDecimal:poi.distance])];
	}	
    self.reviewCountLbl.text = [NSString stringWithFormat:@"%d",poi.reviewCount];
    ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-stars-0%d.png",poi.feedbackCount]];
//    for (int i = 0;  i < 5; i++)
//    {
//        int _x = 95 + (12 * i);
//        UIImageView * star = [[UIImageView alloc]initWithFrame:CGRectMake(_x, 85, 10, 10)];
//        [self.view addSubview:star];
//        if (poi.feedbackCount > i)
//        {
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star_B.png"]];
//        }
//        else
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star.png"]];
//        [star release];
//    }

}



 - (void)viewDidLoad {
	 [super viewDidLoad];
     
     //Scroll view padding removed
     self.automaticallyAdjustsScrollViewInsets = NO;
     
     isArranged = NO;
	 self.title = @"Coupons List";
	 self.navigationItem.leftBarButtonItem.title = @"List";
	 poiDetailImageView.image = [UIImage imageNamed:@"merchantBg.png"];
	 appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	 [GeneralUtil setRivepointLogo:self.navigationItem];
     
     [[NSNotificationCenter defaultCenter] 
      addObserver:self 
      selector:@selector(twitterLogin) 
      name:k_Twitter_login_Notification
      object:nil];
//     [self arrangePOIDataForFirstScreen];
     /*
     if ([[UIScreen mainScreen] bounds].size.height > 500) {
         NSLog(@"its iPhone 5");
         uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y, uiTableView.frame.size.width, 295);
     }*/
 }
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    NSLog(@"List Coupon View Controller - Receive Memory Warning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


-(void) viewWillDisappear:(BOOL)animated
{
    if (isArranged == NO) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [super viewWillDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (isArranged == NO) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callLoginPageToRP) name:k_RP_Login_Call object:nil];
        
        if(appDelegate.loadFromPersistantStore){
            appDelegate.couponArray = [FileUtil restoreArrayOfCustomObjects:COUPON_ARRAY];
            [NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
        }	
        appDelegate.terminateRequest = NO;
        if (_curPOI) {
            poi = _curPOI;
        }
        else
            poi = [GeneralUtil getPoi];
        vendorLabel.text = poi.name;
        userPointsLabel.text = [poi.userPoints stringByAppendingFormat:@" points"];
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
        if([poi.isSponsored isEqualToString:@"true"])
            distanceLabel.text = @"";		
        else{
            distanceLabel.text = [NSString stringWithFormat:@"%@ miles", (poi.distance = [GeneralUtil truncateDecimal:poi.distance])];
        }
        if (self.isFavoritePOI == NO) {
            shouldReturnToRoot = YES;
        }
        [uiTableView reloadData];
        if(	appDelegate.loadFromPersistantStore){
            appDelegate.loadFromPersistantStore = NO;
            return;
        }
        
        if(!appDelegate.couponArray){
            bigLogoImageView.image = nil;
            [NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
            if(adaptor){
                [adaptor cancelRequest];
                [adaptor release];
            }
            
            adaptor = [[HttpTransportAdaptor alloc]init];
            NSString *string;
            
            if(appDelegate.currentPoiCommand == 4)
                string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId couponType:EXTERNAL_COUPON];
            else if(appDelegate.currentPoiCommand ==  GET_LOYALTY_POIS)
                string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId 
                                                      couponType:nil loyaltyFlag:YES];
            else
                string = [CommandUtil getXMLForPoiCouponsCommand:poi.poiId userId:appDelegate.setting.subsId];
            
            [adaptor sendXMLRequest:string referenceOfCaller:self];
            [appDelegate progressHudView:self.view andText:@"Loading..."];
            [self setRightBarButton:1];
        }
        else
            [NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
        
        
        self.reviewCountLbl.text = [NSString stringWithFormat:@"%d",poi.reviewCount];
        ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-stars-0%d.png",poi.feedbackCount]];
//        for (int i = 0;  i < 5; i++)
//        {
//            int _x = 95 + (12 * i);
//            UIImageView * star = [[UIImageView alloc]initWithFrame:CGRectMake(_x, 85, 10, 10)];
//            [self.view addSubview:star];
//            if (poi.feedbackCount > i)
//            {
//                [star setImage:[UIImage imageNamed:@"cell_FB_Star_B.png"]];
//            }
//            else
//                [star setImage:[UIImage imageNamed:@"cell_FB_Star.png"]];
//            [star release];
//        }

    }
    else
        isArranged = NO;
}
- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[GeneralUtil setBigLogo:bigLogoImageView poiId:poi.poiId];
	
	[pool release];
}

- (void)processHttpResponse:(NSData *)response{
    
    
    
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"Coupon" parseError:nil];

	appDelegate.couponArray =nil;
	appDelegate.couponArray = [[parser getArray]autorelease];

	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	[uiTableView reloadData];
	[response release];
	[appDelegate hideActivityViewer];
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
	[self setRightBarButton:0];
	if(!appDelegate.couponArray || [appDelegate.couponArray count] == 0){
		[appDelegate showAlert:NSLocalizedString(KEY_NO_COUPON_FOUND,EMPTY_STRING) delegate:self];
	}
	else{
		[self persistToNSUserDefaults];
	}
	
}
- (void) persistToNSUserDefaults{
	if(appDelegate.currentPoiCommand == BROWSE){
		[FileUtil setIntegerToNSUserDefaults:3 key:NO_OF_LEVELS];
		[FileUtil setIntegerToNSUserDefaults:appDelegate.poiId key:POI_ID];
		[FileUtil setIntegerToNSUserDefaults:COUPON_LIST key:LEVEL3];
	}
	else if(appDelegate.currentPoiCommand == GET_COUPONS ||appDelegate.currentPoiCommand == SEARCH){
		[FileUtil setIntegerToNSUserDefaults:2 key:NO_OF_LEVELS];
		[FileUtil setIntegerToNSUserDefaults:appDelegate.poiId key:POI_ID];
		[FileUtil setIntegerToNSUserDefaults:COUPON_LIST key:LEVEL2];
	}
	
	[FileUtil persistArrayOfCustomObjects:appDelegate.couponArray key:COUPON_ARRAY]; 
	
}
- (void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"Came In viewDidDisappear");
	appDelegate.terminateRequest = YES;
    [appDelegate.progressHud removeFromSuperview];
        if(shouldReturnToRoot){
            if(browseVendorController && !isMapClick){
                [[self navigationController] popToViewController:browseVendorController animated:YES];
            }else if(isMapClick){
                isMapClick = NO; 
            }
            else{
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }
//            [appDelegate removeAllFromCouponPreviewImageDictionary];
        }
        shouldReturnToRoot = YES;
        NSLog(@"Came Out viewDidDisappear");
}

-(void)communicationError:(NSString *)errorMsg{
	[self setRightBarButton:0];
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
	[appDelegate hideActivityViewer];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	[adaptor release];
	adaptor = nil;

}

-(IBAction)phoneClick{
	/*if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}*/
	[PoiUtil dialPhoneNumber:poi];
}
-(IBAction)mapClick{
	/*if([poi.completeAddress length] > 0){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:NSLocalizedString(GOOGLE_MAPS_URL,EMPTY_STRING) ,poi.completeAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_MAPS_CANT_OPEN,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	 }*/
	isArranged = YES;
	poi = [GeneralUtil getPoi];
    
    if(mapViewController){
		mapViewController = nil;
	}
//	if(!mapViewController){
		mapViewController = [[MapViewController alloc] initWithNibName:@"Maps" bundle:nil];
//	}
		
	[mapViewController setListCouponViewController:self];
	[self.navigationController presentModalViewController:mapViewController animated:YES];
	isMapClick = YES;
	[mapViewController release];	
	
}


-(IBAction) onSharePhotoClick
{
    self.title = @"Back";
    isArranged = YES;
    ViewPhotosViewVontroller * viewController = [[ViewPhotosViewVontroller alloc]initWithNibName:@"ViewPhotosViewVontroller" bundle:nil];
    viewController.coupon = self.coupon;
    shouldReturnToRoot = NO;
    [[self navigationController] pushViewController:viewController animated:YES];
    [viewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
}

-(IBAction) onFavoriteClick
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        [appDelegate progressHudView:self.view andText:@"Processing..."];
        poi = [GeneralUtil getPoi];
        
        NSString * param1= [XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
        NSString * param2= [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
        NSString * params= [NSString stringWithFormat:@"%@%@",param1,param2];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"addFavPoi" andParams:params];
        
        XMLPostRequest * xmlReq = [[XMLPostRequest alloc]init];
        xmlReq.delegate = (id) self;
        [xmlReq sendPostRequestWithRequestName:k_AddFavPoiReq andRequestXML:reqXML];
        [xmlReq release];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
    
    
}

-(void) addPoiFavRequestCompletedWithSatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"0"])
    {
        [appDelegate showAlertWithHeading:@"Marked favorite successfully." andDesc:@""];
    }
    if ([status isEqualToString:@"-2"]) {
        [appDelegate showAlertWithHeading:@"Already marked favorite" andDesc:@""];
    }
    if ([status isEqualToString:@"-1"]) {
        [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Service not found."];
    }
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
//   [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Service not found."]; 
}

-(IBAction) onRatingClick
{
    self.title = @"Back";
    isArranged = YES;
    ReviewRatingViewController * viewController = [[ReviewRatingViewController alloc]initWithNibName:@"ReviewRatingViewController" bundle:nil];
    viewController.coupon = self.coupon;
    viewController.delegate = (id) self;
    shouldReturnToRoot = NO;
    [[self navigationController] pushViewController:viewController animated:YES];
    [viewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
    
}

-(void) userAddedNewReview
{
    self.reviewCountLbl.text = [NSString stringWithFormat:@"%d",poi.reviewCount];
}

-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
		[GeneralUtil setActivityIndicatorView:self.navigationItem];
	}
}

- (void) dontReturnToRoot{
	shouldReturnToRoot = NO;
	
}
 
-(void)setBrowseVendorController:(BrowseVendorController *)controller{
	browseVendorController = controller;
	
}

-(void) viewDidUnload
{
     NSLog(@"List Coupon View Controller - View is going to unload");

    uiTableView = nil;
    poiDetailImageView = nil;
    vendorLabel = nil;
    addressLine1Label = nil;
    addressLine2Label= nil;
    phoneBtn= nil;
    bigLogoImageView= nil;
    distanceLabel = nil;
    mapButton = nil;
    userPointsLabel = nil;
    reviewCountLbl = nil;
    coupon = nil;
    adaptor =nil;
    browseVendorController = nil;
    mapViewController = nil;
    cvController = nil;
    couponViewCell = nil;
    ratingImageView = nil;
    _curPOI = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    
    NSLog(@"dealloc IN");
    
    [uiTableView release];
//    [mapViewController release];
//	[poi release];
	[poiDetailImageView release];
    [vendorLabel release];
    [addressLine1Label release];
    [addressLine2Label release];
    [phoneBtn release];
    [bigLogoImageView release];
    [distanceLabel release];
    [mapButton release];
    [userPointsLabel release];
    [reviewCountLbl release];
    [coupon release];
    [ratingImageView release];
    [_curPOI release];
    ratingImageView = nil;
    
//    poi = nil;
//    mapViewController = nil;
    uiTableView = nil;
    poiDetailImageView = nil;
    vendorLabel = nil;
    addressLine1Label = nil;
    addressLine2Label= nil;
    phoneBtn= nil;
    bigLogoImageView= nil;
    distanceLabel = nil;
    mapButton = nil;
    userPointsLabel = nil;
    reviewCountLbl = nil;
    coupon = nil;
    _curPOI = nil;
    
//	[super dealloc];
    NSLog(@"dealloc Out");
}

- (void)openZxingController{
    
    /*
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    [self presentModalViewController:widController animated:YES];
    [widController release];
   */
}

//
//
//- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
//    //self.resultsToDisplay = result;
//    if (self.isViewLoaded) {
//      //  [label setText:resultsToDisplay];
//        
//     //   [resultsView setNeedsDisplay];
//        
//        NSArray *qrcodeComponents = [result componentsSeparatedByString:@"<sep>"];
//        int poiId = [[qrcodeComponents objectAtIndex:0]intValue];
//        int vendorId = [[qrcodeComponents objectAtIndex:0]intValue];
//        //UIAlertView *alertView = nil;
//        if ([poi.poiId intValue] == poiId) {
//           /*alertView = [[UIAlertView alloc]initWithTitle:@"QRCode" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];*/
//            [self dismissModalViewControllerAnimated:NO];
//            if(cvController == nil)
//                cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
//            cvController.isSaved = couponViewCell.isSaved;
//            cvController.numberOfPOICoupons = couponViewCell.numberOfPOICoupons;
//            cvController.hidesBottomBarWhenPushed = YES;
//            [cvController setIsLoyaltyPoi:YES];
//            appDelegate.couponId = [coupon.couponId intValue];
//            appDelegate.couponIndex = couponViewCell.couponIndex;
//            [self dontReturnToRoot];
//            [[self navigationController] pushViewController:cvController animated:YES];
//        }else{
//            [self dismissModalViewControllerAnimated:NO];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Invalid QRCode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            [alertView release];
//        }
//        
//    }
//    
//
//}
//
//- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
//    
//    [controller dismissModalViewControllerAnimated:YES];
//}

-(void) setCouponViewCell:(CouponViewCell *)cell{
    couponViewCell = cell;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    int statusCode = [response statusCode];
//    NSLog(@"Status Code [%d]",statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSString* newStr = [[[NSString alloc] initWithData:data
//                                              encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"Response String : %@",newStr);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self setRightBarButton:0];
    [appDelegate.progressHud removeFromSuperview];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setRightBarButton:0];
    [appDelegate.progressHud removeFromSuperview];
}


@end
