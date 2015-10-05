//
//  COTDViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/8/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "COTDViewController.h"
#import "COTDXMLParser.h"
#import "CommandUtil.h"

@implementation COTDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIImageView *imgView = (UIImageView *) self.view ;
	imgView.image=[UIImage imageNamed:@"COTD-bg.png"];
	phoneBtn.backgroundColor = [UIColor clearColor] ;
	alsoAvailableAtBtn.backgroundColor =  [UIColor clearColor] ;
	redeemButton.backgroundColor =  [UIColor clearColor] ;
	shareButton.backgroundColor =  [UIColor clearColor] ;
	saveButton.backgroundColor = [UIColor clearColor] ;
	feedBack.backgroundColor =  [UIColor clearColor] ;
	mapButton.backgroundColor =  [UIColor clearColor] ;
	self.navigationItem.title = @"Coupon of the day";
	[GeneralUtil setRivepointLogo:self.navigationItem];
}

- (void)viewWillAppear:(BOOL)animated{

	if(!appDelegate.cotdDictinary){
		
		vendorLabel.text = @"";
		addressLine1Label.text = @"";
		addressLine2Label.text = @"";
		distanceLabel.text = @"";
		couponTitleLabel.text = @"";
		couponSubTitleLabel.text = @"";
		redemtionLabel.text = @"";
		
		phoneBtn.hidden = YES ;
		alsoAvailableAtBtn.hidden = YES;
		redeemButton.hidden = YES;
		shareButton.hidden = YES;
		saveButton.hidden = YES;
		feedBack.hidden = YES;
		mapButton.hidden = YES;
		[previewButton setImage:nil forState:UIControlStateNormal];
		poiLogo.image = nil;
		
		if(adaptor){
			[adaptor cancelRequest];
			[adaptor release];
		}
		
		adaptor = [[HttpTransportAdaptor alloc]init];
		NSString *string;
		
		string = [CommandUtil getXMLForGetCOTDCommmand];
		appDelegate.excludePoiId = nil;
		[adaptor sendXMLRequest:string referenceOfCaller:self];
		[GeneralUtil setRightBarButton:1 controllerReference:self];
		//[FlurryUtil logCOTD:appDelegate.setting.zip];
	}
	else{
		[self setPOI];
		[self setCouponRedemptionDetails];
	}
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)processHttpResponse:(NSData *)response{
	COTDXMLParser *parser = [[COTDXMLParser alloc]init];
	[parser parseXMLFromData:response parseError:nil];
	
	appDelegate.cotdDictinary = [parser getDictionary];
	appDelegate.couponArray = (NSMutableArray *)[appDelegate.cotdDictinary objectForKey:@"result"];
	appDelegate.currentPoiCommand = 6;
	[parser setArray];
	[parser release];
	[adaptor release];
	adaptor = nil;
	[response release];
	[GeneralUtil setRightBarButton:0 controllerReference:self];
	[self displayContent];
	//[FlurryAPI endTimedEvent:COTD_EVENT];
}
-(void)communicationError:(NSString *)errorMsg{
	[GeneralUtil setRightBarButton:0 controllerReference:self];
	[appDelegate showAlert:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self];
	//[FlurryUtil logCOTDError:appDelegate.setting.zip];
	[adaptor release];
	adaptor = nil;
	
}
-(void) setPOI{
	poi = coupon.poi;
	NSArray *array = [poi.completeAddress componentsSeparatedByString:@","];
	
	if([array count] == 4){
		addressLine1Label.text = [array objectAtIndex:0];
		NSString *string = [NSString stringWithFormat:@"%@,%@,%@",[array objectAtIndex:1],
							[array objectAtIndex:2],[[array objectAtIndex:3] substringToIndex:([[array objectAtIndex:3]length]-3)]];
		addressLine2Label.text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		[phoneBtn setTitle:poi.phoneNumber forState:UIControlStateNormal];
	}
	NSArray *splitStr =[poi.distance componentsSeparatedByString:@"."];
	
	NSString *decimalStr = [splitStr objectAtIndex:1];
	if([decimalStr length] >= 2){
		decimalStr = [decimalStr substringToIndex:2];
	}
	
	
	
	poi.distance = [NSString stringWithFormat:@"%@.%@",[splitStr objectAtIndex:0],decimalStr];
	
	distanceLabel.text = [NSString stringWithFormat:@"%@ miles", poi.distance];
	
	
}
-(void) setCouponRedemptionDetails{

	if(coupon.isRestrictedCoupon && [coupon.isRestrictedCoupon isEqualToString:@"1"]){
		int couponCount = [coupon.perUserRedemption intValue] - [coupon.userRedemptionCount intValue];
		redemtionLabel.text = [NSString stringWithFormat:@"%d Redemptions left.",couponCount];
	}
	
}
-(void)displayContent{
	NSMutableArray *resultArray = (NSMutableArray *)[appDelegate.cotdDictinary objectForKey:@"result"];
	if(!resultArray || [resultArray count] == 0){
		appDelegate.cotdDictinary = nil;
		[appDelegate showAlert:NSLocalizedString(KEY_NO_COTD_FOUND,EMPTY_STRING) delegate:self];
		return;
	}
		
	
	NSString *otherCOTDPois = (NSString *)[appDelegate.cotdDictinary objectForKey:@"otherCOTDPois"];
	if([otherCOTDPois isEqualToString:@"0"] || !otherCOTDPois){
		alsoAvailableAtBtn.hidden = YES;
	}
	else
		alsoAvailableAtBtn.hidden = NO;
		
	
	coupon =  (Coupon *)[resultArray objectAtIndex:0];
	
	couponTitleLabel.text = coupon.title;

	couponSubTitleLabel.text = [NSString stringWithFormat:@"%@ %@", 
								[coupon.subTitleLineOne isEqualToString:@"null"]?@"": coupon.subTitleLineOne, 
								[coupon.subTitleLineTwo isEqualToString:@"null"]?@"": coupon.subTitleLineTwo]; 
	
	[self setCouponRedemptionDetails];
	poi = coupon.poi;
	vendorLabel.text = poi.name;
	[self setPOI];
	
	phoneBtn.hidden = NO ;
	redeemButton.hidden = NO;
	shareButton.hidden = NO;
	saveButton.hidden = NO;
	feedBack.hidden = NO;
	mapButton.hidden = NO;
	
	[NSThread detachNewThreadSelector:@selector(setCouponPreviewImage) toTarget:self withObject:nil];
	
	[NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
	
}
- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
		NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
		NSString *urlFileName = @"url";
		NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
		NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=1&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,poi.poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSData *receivedData =  [[[NSData alloc] initWithContentsOfURL:url] autorelease];
		if(receivedData && [receivedData length] > 0)
        {
            UIImage * _pImage = [UIImage imageWithData:receivedData]; 
            if (_pImage) {
                poiLogo.image = _pImage;
            }
            else
                poiLogo.image= [UIImage imageNamed:@"dummy-logo.png"];
            
        }
    [pool release];
}
- (void) setCouponPreviewImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
		NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
		NSString *urlFileName = @"url";
		NSString *urlPathString = [thisBundle pathForResource:urlFileName ofType:@"txt"];
		NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=4&couponId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,coupon.couponId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSData *receivedData =  [[NSData alloc] initWithContentsOfURL:url];
		if(receivedData && [receivedData length] > 0){
			[previewButton setImage:[GeneralUtil scaleImage:[UIImage imageWithData:receivedData]  
													  width:102 height:87]
						   forState:UIControlStateNormal];
		}
		[receivedData release];
	
	[pool release];
} 


-(IBAction)phoneClick {
	[GeneralUtil phoneClick:poi controllerReference:self];
	
}
-(IBAction)mapClick {
	[GeneralUtil mapClick:poi controllerReference:self];
	
}
- (IBAction)saveButton{
	coupon.poiId = poi.poiId;
	if([appDelegate poiCouponExists:coupon poi:poi]){
		[appDelegate showAlert:NSLocalizedString(KEY_COUPON_ALREADY_SAVED,EMPTY_STRING)  delegate:appDelegate];
		return;
	}
	
	if([appDelegate saveCoupon:coupon poi:poi])
		[appDelegate showAlert:NSLocalizedString(KEY_COUPON_SAVED_SUCCESSFULLY,EMPTY_STRING)  delegate:appDelegate];
	else
		[appDelegate showAlert:NSLocalizedString(KEY_ERROR_COUPON_SAVED,EMPTY_STRING)  delegate:appDelegate];
	
	
	[appDelegate updateSavedCouponsTabBarItem];
}
- (IBAction)redeemButton{
	if(!coupon.perUserRedemption || [coupon.perUserRedemption isEqualToString:@"-1"] || [coupon.userRedemptionCount intValue] < [coupon.perUserRedemption intValue]){
		if(cvController == nil)
			cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
		cvController.isSaved = NO;
		cvController.numberOfPOICoupons = 1;
		appDelegate.couponId = [coupon.couponId intValue];
		appDelegate.couponIndex = 0;
		appDelegate.currentPoiCommand = 6;
		appDelegate.couponArray = (NSMutableArray *)[appDelegate.cotdDictinary objectForKey:@"result"];
		[[self navigationController] pushViewController:cvController animated:YES];
	}
	else{
		[appDelegate showAlert:NSLocalizedString(KEY_REDEMPTION_LIMIT_EXHAUSTED,EMPTY_STRING) delegate:appDelegate];
	}
}
- (IBAction)otherPoisButton{
	if(otherPoisvController == nil)
		otherPoisvController = [[COTDOtherPoiViewController alloc] initWithNibName:@"ListVendorView" bundle:nil];
		[[self navigationController] pushViewController:otherPoisvController animated:YES];
	
	
}
-(IBAction)shareCouponAction{
	if(shareIt)
		[shareIt release];
	shareIt = [[ShareIt alloc] init];
	shareIt.couponId = coupon.couponId;
	shareIt.poiId = poi.poiId;
    NSString *emailString = appDelegate.setting.email;
    if ([emailString isEqualToString:@"Not Available"] || [emailString isEqualToString:@""]) {
        [appDelegate askForUserEmail:shareIt];
    }else{
        [shareIt showShareDialog:@""];
    }
}
-(IBAction)couponFeedbackAction{
	if(!feedbackManager)
		feedbackManager = [[FeedbackManager alloc] init];
	feedbackManager.coupon = coupon;
	feedbackManager.poi =  poi;
	[feedbackManager showFeedbackAlert];		
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//tabBarController.selectedViewController = browseNavigationController;
	[[self navigationController] popToRootViewControllerAnimated:YES];
}
-(IBAction)onPreviewClick{
	if(!couponDetailManager)
		couponDetailManager = [[CouponDetailManager alloc] init];
	[couponDetailManager showDetailAlert:poi coupon:coupon];
	
	
}

- (void)dealloc {
	[feedbackManager release];
	[shareViewController release];
	[cvController release];
	[otherPoisvController release];
	[couponDetailManager release];
    [super dealloc];
}

@end
