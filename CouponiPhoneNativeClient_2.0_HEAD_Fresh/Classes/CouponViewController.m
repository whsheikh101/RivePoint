//
//  CouponViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/3/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CouponViewController.h"
#import "HttpTransportAdaptor.h"
#import "XMLParser.h"
#import "Coupon.h"
#import "Setting.h"
#import "CommandUtil.h"
#import "Base64.h"
#import "Poi.h"
#import "CouponManager.h"
#import "GeneralUtil.h"
#import "PoiUtil.h"
#import "PoiFinderNew.h"
#import "PoiManager.h"
#import "RedeemViewController.h"
#import "ZBarReaderViewController.h"
#import "XMLUtil.h"


@implementation CouponViewController
#define reflectionFraction 0.35
#define reflectionOpacity 0.5

@synthesize isSaved;
@synthesize numberOfPOICoupons;
@synthesize flipIndicatorButton;
@synthesize phoneButton;
@synthesize isLoyaltyPoi;
@synthesize isShared;
@synthesize currCoupon = _currCoupon;
@synthesize curPOI = _curPOI;
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


-(void) callShowCouponForRedeem
{
    @try{
        //            if (isRedeemScreenCall == YES) {
        //                isRedeemScreenCall = NO;
        //                [appDelegate progressHudView:self.view andText:@"Loading..."];
        //            }
        isDelete = NO;
        imageView.image = nil;
        reflectedView.image = nil;
        NSString *poiId;
        NSString *couponId;
        
        [self clearDetailLabels];
        adaptor = [[HttpTransportAdaptor alloc]init];
        couponId = _currCoupon.couponId;
        selectedCoupon = _currCoupon;
        poiId = _curPOI.poiId;
        if ([_curPOI.poiType isEqualToString:@"0"])
        {
            [redeemCoupBtn setHidden:YES];
        }
        else
            [redeemCoupBtn setHidden:NO];
        
        Setting *s = appDelegate.setting;
        NSString *string;
        if(isLoyaltyPoi){
            string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
                                                      userId:appDelegate.setting.subsId 
                                                    latitude:s.latitude longitude:s.longitute 
                                                 loyaltyFlag:YES];
        }
        else{
            string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
                                                      userId:appDelegate.setting.subsId 
                                                    latitude:s.latitude longitude:s.longitute];
        }
//        [appDelegate progressHudView:self.view andText:@"Loading..."];
        [adaptor sendXMLRequest:string referenceOfCaller:self];
        [appDelegate showActivityViewer];
    }
    @catch (NSException * e) {
        NSLog(@"CouponViewController -> (void)viewWillAppear:(BOOL)animated: Caught %@: %@", [e name], [e  reason]);
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
    redeemCoupBtn.hidden = YES;
	//((UIImageView *)self.view).image = [[UIImage imageNamed:@"redemption-screen-bg.png"] autorelease];
	[GeneralUtil setRivepointLogo:self.navigationItem];
	//[couponView setBackgroundImage:[UIImage imageNamed:@"flipper_list_blue.png"] forState:UIControlStateNormal];
	couponView.image = [UIImage imageNamed:@"Solid_256.png"];
	detailView.image = [UIImage imageNamed:@"Coupon-Back-template.png"];
	imageView.backgroundColor = containerView.backgroundColor = reflectedView.backgroundColor = [UIColor clearColor];
    isRedeemScreenCall = NO;
    isQRRedeem = NO;
    [self callShowCouponForRedeem];
}


-(void) viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"CouponViewController didReceiveMemoryWarning");
    imageView = nil;
	parentView = nil;
	couponView = nil;
	detailView = nil;
	reflectedView = nil;
	containerView = nil;
	titleLbl = nil;
	subTitle1Lbl = nil;
	subTitle2Lbl = nil;
	expiryLabel = nil;
	vendorNameLbl = nil;
	addressLbl = nil;
	redeemLbl = nil;
	phoneButton = nil;
	redeemCoupBtn = nil;
    curQRImage = nil;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    NSLog(@"CouponViewController didReceiveMemoryWarning");
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//        @try{
////            if (isRedeemScreenCall == YES) {
////                isRedeemScreenCall = NO;
////                [appDelegate progressHudView:self.view andText:@"Loading..."];
////            }
//            isDelete = NO;
//            imageView.image = nil;
//            reflectedView.image = nil;
//            NSString *poiId;
//            NSString *couponId;
//            
//            [self clearDetailLabels];
//            adaptor = [[HttpTransportAdaptor alloc]init];
//            couponId = _currCoupon.couponId;
//            NSLog(@"Current Coupon Id : %@",couponId);
//            selectedCoupon = _currCoupon;
//            poiId = _curPOI.poiId;
//            NSLog(@"\n\n\n\n\n Current Vender Type : %@ \n\n\n\n\n",_curPOI.poiType);
//            if ([_curPOI.poiType isEqualToString:@"0"])
//            {
//                [redeemCoupBtn setHidden:YES];
//            }
//            else
//                [redeemCoupBtn setHidden:NO];
//            
//            Setting *s = appDelegate.setting;
//            NSString *string;
//            if(isLoyaltyPoi){
//                string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
//                                                          userId:appDelegate.setting.subsId 
//                                                        latitude:s.latitude longitude:s.longitute 
//                                                     loyaltyFlag:YES];
//            }
//            else{
//                string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
//                                                          userId:appDelegate.setting.subsId 
//                                                        latitude:s.latitude longitude:s.longitute];
//            }
//            [appDelegate progressHudView:self.view andText:@"Loading..."];
//            [adaptor sendXMLRequest:string referenceOfCaller:self];
////            [appDelegate showActivityViewer];
//        }
//        @catch (NSException * e) {
//            NSLog(@"CouponViewController -> (void)viewWillAppear:(BOOL)animated: Caught %@: %@", [e name], [e  reason]);
//        }
}


//- (void)viewWillAppear:(BOOL)animated{
//@try{
//	isDelete = NO;
//	imageView.image = nil;
//	reflectedView.image = nil;
//	NSString *poiId;
//	NSString *couponId;
//	 
//	[self clearDetailLabels];
//	adaptor = [[HttpTransportAdaptor alloc]init];
//	couponId = [NSString stringWithFormat:@"%d",appDelegate.couponId];
//	//deleteUIButton.hidden = !isSaved;
//	//saveUIButton.hidden = isSaved;
//	
//	
//	
//	if(isSaved){
//		CouponManager *cm = [[CouponManager alloc] init];
//		selectedCoupon = [cm findByCouponId:appDelegate.couponId];
//		[cm release];
//		poiId = [NSString stringWithFormat:@"%d",appDelegate.poiId];
//	}else{
//		Poi *poi = [GeneralUtil getPoi];
//		
//		
//		
//		poiId = poi.poiId;
//		selectedCoupon = [appDelegate.couponArray objectAtIndex:appDelegate.couponIndex];
//	}
//	
//	Setting *s = appDelegate.setting;
//	NSString *string;
//	if(isLoyaltyPoi){
//		string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
//												  userId:appDelegate.setting.subsId 
//												latitude:s.latitude longitude:s.longitute 
//											 loyaltyFlag:YES];
//	}
//	else{
//		string = [CommandUtil getXMLForShowCouponCommand:couponId poiId:poiId 
//												  userId:appDelegate.setting.subsId 
//												latitude:s.latitude longitude:s.longitute];
//	}
//	//[FlurryUtil logRedeemCoupons:couponId poiId:poiId zipCode:s.zip];
//	[adaptor sendXMLRequest:string referenceOfCaller:self];
//	[appDelegate showActivityViewer];
//}
//@catch (NSException * e) {
//	NSLog(@"CouponViewController -> (void)viewWillAppear:(BOOL)animated: Caught %@: %@", [e name], [e  reason]);
//}
//	
//}


- (void)processHttpResponse:(NSData *)response{
@try{

//    [appDelegate.progressHud removeFromSuperview];
    
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"Coupon" parseError:nil];
	NSArray *result =[parser getArray];
	
	Coupon *coupon =[result objectAtIndex:0];
    couponToRedeem = [[result objectAtIndex:0] retain];
	//[FlurryAPI endTimedEvent:REDEEM_COUPON_EVENT];
	//NSData *data = [[NSData alloc] initWithData:[coupon.couponImageBytes dataUsingEncoding:NSASCIIStringEncoding]];
	BOOL isAvailable = [coupon.isAvailable isEqualToString:@"1"];
	if(isAvailable){
	
		NSData* base64Data = [[NSData alloc] initWithBase64EncodedString:coupon.couponImageBytes];
		//redemptionCodeLabel.text = coupon.couponUniqueCode;
		
		//******************Load View***********************//
		UIImage *uiUmage = [UIImage imageWithData:base64Data];
		[base64Data autorelease];
		imageView.animationImages = nil;
		imageView.image = uiUmage;
		[parentView addSubview:couponView];
		
		NSUInteger reflectionHeight=parentView.bounds.size.height*reflectionFraction;
		
		// create the reflection image, assign it to the UIImageView and add the image view to the containerView
		reflectedView.image=[couponView reflectedImageRepresentationWithHeight:reflectionHeight];
		reflectedView.alpha=reflectionOpacity;
		frontViewIsVisible = YES;
		
		UIButton *localFlipIndicator=[[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
		self.flipIndicatorButton=localFlipIndicator;
		[localFlipIndicator release];
		
		// front view is always visible at first
		[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"flipper_list_blue.png"] forState:UIControlStateNormal];
		
		UIBarButtonItem *flipButtonBarItem;
		flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];
		
		[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
		[flipButtonBarItem release];
		
		[flipIndicatorButton addTarget:self action:@selector(flipCurrentView) forControlEvents:(UIControlEventTouchDown)];
		
		[self loadDetails];
		
		//******************Load View End***********************//
		
		
		
		
		
		
//		CouponManager *cm = [[CouponManager alloc] init];
//		NSString *userRedemptionCountStr;
//		int userRedemptionCount;
//		
//		if(!isSaved){
//			//Coupon *inMemorycoupon =  [appDelegate.couponArray objectAtIndex:appDelegate.couponId];
//			if(selectedCoupon.isRestrictedCoupon && [selectedCoupon.isRestrictedCoupon isEqualToString:@"1"]){
//			userRedemptionCount =  [selectedCoupon.userRedemptionCount intValue];
//			userRedemptionCount++;
//		
//			userRedemptionCountStr = [NSString stringWithFormat:@"%d",userRedemptionCount]; 
//			selectedCoupon.userRedemptionCount = userRedemptionCountStr;
//			//selectedCoupon.poiId = 
//			if([cm poiCouponExists:selectedCoupon])
//				[cm update:selectedCoupon];
//			}
//			
//		}
//		else{
//			if(selectedCoupon.isRestrictedCoupon && [selectedCoupon.isRestrictedCoupon isEqualToString:@"1"]){
//				userRedemptionCount = [selectedCoupon.userRedemptionCount intValue];
//				userRedemptionCount++;
//				userRedemptionCountStr = [NSString stringWithFormat:@"%d",userRedemptionCount]; 
//				selectedCoupon.userRedemptionCount = userRedemptionCountStr;
//				[cm update:selectedCoupon];
//				//[userRedemptionCountStr release];
//				//userRedemptionCountStr = nil;
//			}
//			
//			
//			
//		}
//        redeemPoi = [GeneralUtil getPoi];
//        if(coupon.earningPoints){
//          [redeemPoi setUserPoints:[NSString stringWithFormat:@"%d",([redeemPoi.userPoints intValue] + 
//                                                                       [coupon.earningPoints intValue])]];
//		}else if(coupon.reqdPoints){
//            [redeemPoi setUserPoints:[NSString stringWithFormat:@"%d",([redeemPoi.userPoints intValue] - 
//                                                                       [coupon.reqdPoints intValue])]];
//
//        }
//       if((isSaved || isShared) && isLoyaltyPoi && appDelegate.loyaltyArray){
//            for (Poi *loyaltyPoi in appDelegate.loyaltyArray) {
//                if([loyaltyPoi.poiId isEqualToString:redeemPoi.poiId]){
//                    if(coupon.earningPoints){
//                        loyaltyPoi.userPoints = [NSString stringWithFormat:@"%d",([loyaltyPoi.userPoints intValue] + 
//                                                                                   [coupon.earningPoints intValue])];
//                    }else if(coupon.reqdPoints){
//                        loyaltyPoi.userPoints = [NSString stringWithFormat:@"%d",([loyaltyPoi.userPoints intValue] - 
//                                                                                    [coupon.reqdPoints intValue])];
//                        }
//                    }
//                }
//        }
//       
//        if (isShared && isLoyaltyPoi) {
//            for (Coupon *coupon in appDelegate.sharedCouponArray) {
//                Poi *sharedPoi = coupon.poi;
//                if ([sharedPoi.poiId isEqualToString:redeemPoi.poiId]) {
//                     [coupon setPoi:redeemPoi];
//                  
//                }
//            }
//        }            
//		//[userRedemptionCountStr release];
//		[cm release];
	}
	else{
		[[self navigationController] popViewControllerAnimated:YES];
        [appDelegate showAlertWithHeading:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) andDesc:NSLocalizedString(KEY_COUPON_NOT_AVAILABLE, EMPTY_STRING)];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING)
//														message:NSLocalizedString(KEY_COUPON_NOT_AVAILABLE, EMPTY_STRING)
//													   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alert show];	
//		[alert release];
	}
//    [appDelegate removeLoadingViewFromSuperView];
    
	[parser setArray];
	[parser release];
    parser = nil;
    [adaptor setRefranceToNil];
	[adaptor release];
    adaptor = nil;
	[result release];
	[response release];
	[appDelegate hideActivityViewer];
//    redeemCoupBtn.hidden = NO;
}
@catch (NSException * e) {
	NSLog(@"CouponViewController -> (void)processHttpResponse:(NSData *)response: Caught %@: %@", [e name], [e  reason]);
}

}

- (void)viewWillDisappear:(BOOL)animated
{
    postReq.delegate = nil;
}


-(void)communicationError:(NSString *)errorMsg{
	[appDelegate hideActivityViewer];
//    [appDelegate removeLoadingViewFromSuperView];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING)
													message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) 
												   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	[adaptor release];

//	Poi *poi = [GeneralUtil getPoi];
	
	/*[FlurryUtil logRedeemCouponError:[NSString stringWithFormat:@"%d",appDelegate.couponId] 
							   poiId:poi.poiId
							 zipCode:appDelegate.setting.zip];
	*/

	
}
-(IBAction)saveButtonAction{
	isDelete = NO;
	Coupon *c = [appDelegate.couponArray objectAtIndex:appDelegate.couponId];
	Poi *poi;
	if(appDelegate.currentPoiCommand == 2)
		poi = [appDelegate.poiArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == 1)
		poi = [appDelegate.browseArray objectAtIndex:appDelegate.poiId];
	else 
		poi = [appDelegate.searchArray objectAtIndex:appDelegate.poiId];

	if([appDelegate poiCouponExists:c poi:poi]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_COUPON_ALREADY_SAVED,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
		return;
	}
	
	if([appDelegate saveCoupon:c poi:poi]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_COUPON_SAVED_SUCCESSFULLY,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_ERROR_COUPON_SAVED,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
	[appDelegate updateSavedCouponsTabBarItem];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    if(isDelete){
		if(numberOfPOICoupons > 1)
			[[self navigationController] popToViewController:[[[self navigationController] viewControllers] objectAtIndex:1] animated:YES];
		else
			[[self navigationController] popToRootViewControllerAnimated:YES];
	}
	else{
		[[self navigationController] popToViewController:[[[self navigationController] viewControllers] objectAtIndex:1] animated:NO];
	}    
	alertView.delegate = nil;
}
-(IBAction)deleteCoupon{
	CouponManager *cm = [[CouponManager alloc] init];
	selectedCoupon.poiId =  [NSString stringWithFormat:@"%d", appDelegate.poiId];
	if([cm deleteCoupon:selectedCoupon]){
		isDelete = YES;
		[appDelegate showAlert:KEY_COUPON_DELETED_SUCCESSFULLY delegate:self];
		//[[self navigationController] popToViewController:[[[self navigationController] viewControllers] objectAtIndex:1] animated:YES];
	}
	else{
		[appDelegate showAlert:KEY_ERROR_DELETE_COUPON delegate:self];
	}
	[cm release];
	[appDelegate updateSavedCouponsTabBarItem];
}

- (void)flipCurrentView {
	//Coupon *coupon = [appDelegate.couponArray objectAtIndex:appDelegate.couponId];
	NSUInteger reflectionHeight;
	UIImage *reflectedImage;
	
	// disable user interaction during the flip
    //containerView.layer.cornerRadius = 8;
    //containerView.layer.masksToBounds = YES;
	containerView.userInteractionEnabled = NO;
	flipIndicatorButton.userInteractionEnabled = NO;
	
	// setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (frontViewIsVisible==YES) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:parentView cache:YES];
        [couponView removeFromSuperview];
        [parentView addSubview:detailView];
		
		// update the reflection image for the new view
		 reflectionHeight=parentView.bounds.size.height*reflectionFraction;
		 reflectedImage = [detailView reflectedImageRepresentationWithHeight:reflectionHeight];
		 //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:reflectedView cache:YES];
		 reflectedView.image=reflectedImage;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:parentView cache:YES];
        [detailView removeFromSuperview];
        [parentView addSubview:couponView];
		// update the reflection image for the new view
		reflectionHeight=parentView.bounds.size.height*reflectionFraction;
		 reflectedImage = [couponView reflectedImageRepresentationWithHeight:reflectionHeight];
		 reflectedView.image=reflectedImage;
    }
	[UIView commitAnimations];
	
	
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	if(frontViewIsVisible)
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:reflectedView cache:YES];
	else
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:reflectedView cache:YES];
		
	
	[UIView commitAnimations];
	
	
	
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	
	if (frontViewIsVisible==YES)
	{
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"flipper_list_blue.png"] forState:UIControlStateNormal];
		
	}
	else
	{
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"flipper_list_blue.png"] forState:UIControlStateNormal];
		
	}
	[UIView commitAnimations];
	frontViewIsVisible=!frontViewIsVisible;
}


- (void)transitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	containerView.userInteractionEnabled = YES;
	flipIndicatorButton.userInteractionEnabled = YES;
	
}


-(void) loadDetails{
	
	@try{
	    
        selectedCoupon = _currCoupon;
        
		if(selectedCoupon.title && ![selectedCoupon.title isEqualToString:@"null"])
			titleLbl.text = selectedCoupon.title;
		BOOL subTitleOneAvailable = NO, subTitleTwoAvailable = NO ;
	
		if(selectedCoupon.subTitleLineOne && ![selectedCoupon.subTitleLineOne isEqualToString:@"null"])
			subTitleOneAvailable = YES;
	
		if(selectedCoupon.subTitleLineTwo && ![selectedCoupon.subTitleLineTwo isEqualToString:@"null"])
			subTitleTwoAvailable = YES;
		
		if(subTitleOneAvailable && subTitleTwoAvailable){
			subTitle2Lbl.text = [NSString stringWithFormat:@"%@ %@",selectedCoupon.subTitleLineOne,selectedCoupon.subTitleLineTwo];
		}
		else if(subTitleOneAvailable){
			subTitle2Lbl.text = selectedCoupon.subTitleLineOne;
		}
		else{
			subTitle2Lbl.text = @"";
		}
		redeemLbl.text=@"Redeemable At:";
        
        
        if ([selectedCoupon.validTo rangeOfString:@"/"].location == NSNotFound) 
        {
            NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([selectedCoupon.validTo doubleValue])/1000];
            NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
            [dtfrm setDateFormat:@"MM/dd/yyyy"];
            NSString * nDate = [dtfrm stringFromDate:toDate];
            expiryLabel.text = [NSString stringWithFormat:@"%@", nDate];
            [dtfrm release];
            
//            double sec = 1000.00f;
//            NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([selectedCoupon.validTo doubleValue])/sec];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateStyle:NSDateFormatterLongStyle]; 
//            [dateFormatter setTimeStyle:NSDateFormatterNoStyle]; 
//            expiryLabel.text = [NSString stringWithFormat:@"Expires: %@", [dateFormatter stringFromDate:toDate]];
//            [dateFormatter release];
            
        } else {
            expiryLabel.text = selectedCoupon.validTo;
        }
//		Poi *selectedPoi = [GeneralUtil getPoi];
        Poi *selectedPoi = _curPOI;
		vendorNameLbl.text = selectedPoi.name;
		addressLbl.text = selectedPoi.completeAddress;
		if(selectedPoi.phoneNumber && ![selectedPoi.phoneNumber isEqualToString:@"null"]){
				//phoneNoLbl.text = selectedPoi.phoneNumber;
			[self.phoneButton setTitle:selectedPoi.phoneNumber forState:UIControlStateNormal];
		}
	}
	@catch (NSException * e) {
		NSLog(@"CouponViewController -> (void)loadDetails: Caught %@: %@", [e name], [e  reason]);
	}	
}

-(void) clearDetailLabels{
	vendorNameLbl.text = @"";
	subTitle1Lbl.text = @"";
	subTitle2Lbl.text = @"";
	titleLbl.text = @"";
	addressLbl.text = @"";
	expiryLabel.text = @"";
	redeemLbl.text = @"";
	//phoneNoLbl.text = @"";
	[self.phoneButton setTitle:@"" forState:UIControlStateNormal];
	
}

-(IBAction)phoneNumberClicked{
	[PoiUtil dialPhoneNumber:[GeneralUtil getPoi]];

}


-(void) requestFailWithError:(NSString *)errorMsg
{
    [redeemCoupBtn setHidden:NO];
}

-(void) couponRedeemedWithStatus:(NSString *)status
{
//    [redeemCoupBtn setHidden:NO];
//    [appDelegate.progressHud removeFromSuperview];
    
    postReq.delegate = nil;
    [postReq release];
    postReq = nil;
    
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"])
    {
        if (isQRRedeem == YES) {
            isRedeemScreenCall = YES;
            RedeemViewController * viewController = [[RedeemViewController alloc]initWithNibName:@"RedeemViewController" bundle:nil];
            viewController.qrImage = curQRImage;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            [curQRImage release];
            curQRImage = nil;
            NSLog(@"curQRImage Retain Count : %d", curQRImage.retainCount);
        }
        else
            [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Redeemed successfully!"];
    }
    else
    {
        [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Already redeemed!"];
        [curQRImage release];
        curQRImage = nil;
    }
    status = nil;
    
    
    
}

-(IBAction) onRedeemCouponBtn
{
//    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
//    if (userID && userID.length > 0) {
//        if ([selectedCoupon.couponType isEqualToString:@"0"])
//        {
////            if (userID && userID.length > 0) {
//                [redeemCoupBtn setHidden:YES];
//                [appDelegate progressHudView:self.view andText:@"Processing"];
//                NSString * curCouponID = selectedCoupon.couponId;
//                NSString * curPoiID = selectedCoupon.poiId;
//                NSString * curSubID = appDelegate.setting.subsId;
//                NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:curPoiID];
//                NSString * param2 = [XMLUtil getParamXMLWithName:@"couponId" andValue:curCouponID];
//                NSString * param3= [XMLUtil getParamXMLWithName:@"uid" andValue:curSubID];
//                NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
//                int rand = arc4random() % 1000;
//                NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
//                NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_RedeemCoupon_Call andParams:params];
//                XMLPostRequest * postReq = [[XMLPostRequest alloc]init];
//                postReq.delegate = (id)self;
//                [postReq sendPostRequestWithRequestName:k_RedeemCoupon_Call andRequestXML:reqXML];
//                [postReq release];
//            }
//            else
//                [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please first login!"];
//        }
//        else
//        {
            // ADD: present a barcode reader that scans from the camera feed
            isRedeemScreenCall = YES;
            ZBarReaderViewController *reader = [ZBarReaderViewController new];
            reader.readerDelegate = self;
            //reader.supportedOrientationsMask = ZBarOrientationMaskAll;
            ZBarImageScanner *scanner = reader.scanner;
            // TODO: (optional) additional reader configuration here
            // EXAMPLE: disable rarely used I2/5 to improve performance
            [scanner setSymbology: ZBAR_I25
                           config: ZBAR_CFG_ENABLE
                               to: 0];
            // present and release the controller
            [self presentModalViewController: reader
                                    animated: YES];
            [reader release];
//        }
//    }
//    else
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please first login!"];
       
//    CouponManager *cm = [[CouponManager alloc] init];
//    NSString *userRedemptionCountStr;
//    int userRedemptionCount;
//    
//    if(!isSaved){
//        //Coupon *inMemorycoupon =  [appDelegate.couponArray objectAtIndex:appDelegate.couponId];
//        if(selectedCoupon.isRestrictedCoupon && [selectedCoupon.isRestrictedCoupon isEqualToString:@"1"]){
//			userRedemptionCount =  [selectedCoupon.userRedemptionCount intValue];
//			userRedemptionCount++;
//            
//			userRedemptionCountStr = [NSString stringWithFormat:@"%d",userRedemptionCount]; 
//			selectedCoupon.userRedemptionCount = userRedemptionCountStr;
//			//selectedCoupon.poiId = 
//			if([cm poiCouponExists:selectedCoupon])
//				[cm update:selectedCoupon];
//        }
//        
//    }
//    else{
//        if(selectedCoupon.isRestrictedCoupon && [selectedCoupon.isRestrictedCoupon isEqualToString:@"1"]){
//            userRedemptionCount = [selectedCoupon.userRedemptionCount intValue];
//            userRedemptionCount++;
//            userRedemptionCountStr = [NSString stringWithFormat:@"%d",userRedemptionCount]; 
//            selectedCoupon.userRedemptionCount = userRedemptionCountStr;
//            [cm update:selectedCoupon];
//            //[userRedemptionCountStr release];
//            //userRedemptionCountStr = nil;
//        }
//        
//        
//        
//    }
//    redeemPoi = [GeneralUtil getPoi];
//    if(couponToRedeem.earningPoints){
//        [redeemPoi setUserPoints:[NSString stringWithFormat:@"%d",([redeemPoi.userPoints intValue] + 
//                                                                   [couponToRedeem.earningPoints intValue])]];
//    }else if(couponToRedeem.reqdPoints){
//        [redeemPoi setUserPoints:[NSString stringWithFormat:@"%d",([redeemPoi.userPoints intValue] - 
//                                                                   [couponToRedeem.reqdPoints intValue])]];
//        
//    }
//    if((isSaved || isShared) && isLoyaltyPoi && appDelegate.loyaltyArray){
//        for (Poi *loyaltyPoi in appDelegate.loyaltyArray) {
//            if([loyaltyPoi.poiId isEqualToString:redeemPoi.poiId]){
//                if(couponToRedeem.earningPoints){
//                    loyaltyPoi.userPoints = [NSString stringWithFormat:@"%d",([loyaltyPoi.userPoints intValue] + 
//                                                                              [couponToRedeem.earningPoints intValue])];
//                }else if(couponToRedeem.reqdPoints){
//                    loyaltyPoi.userPoints = [NSString stringWithFormat:@"%d",([loyaltyPoi.userPoints intValue] - 
//                                                                              [couponToRedeem.reqdPoints intValue])];
//                }
//            }
//        }
//    }
//    
//    if (isShared && isLoyaltyPoi) {
//        for (Coupon *coupon in appDelegate.sharedCouponArray) {
//            Poi *sharedPoi = coupon.poi;
//            if ([sharedPoi.poiId isEqualToString:redeemPoi.poiId]) {
//                [coupon setPoi:redeemPoi];
//                
//            }
//        }
//    }            
//    //[userRedemptionCountStr release];
//    [cm release];
    
    
    
    
}



- (void)dealloc {
    
    [imageView release];
	[parentView release];
	[couponView release];
	[detailView release];
	[reflectedView release];
	[containerView release];
	[titleLbl release];
	[subTitle1Lbl release];
	[subTitle2Lbl release];
	[expiryLabel release];
	[vendorNameLbl release];
	[addressLbl release];
	[redeemLbl release];
	[phoneButton release];
	[redeemCoupBtn release];
//    [curQRImage release];
    
    imageView = nil;
	parentView = nil;
	couponView = nil;
	detailView = nil;
	reflectedView = nil;
	containerView = nil;
	titleLbl = nil;
	subTitle1Lbl = nil;
	subTitle2Lbl = nil;
	expiryLabel = nil;
	vendorNameLbl = nil;
	addressLbl = nil;
	redeemLbl = nil;
	phoneButton = nil;
	redeemCoupBtn = nil;
//    curQRImage = nil;
    
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated{
//	if(isSaved)
//		[selectedCoupon release];
//	[[self navigationController] popToRootViewControllerAnimated:YES];
    
}



-(void) gotoRedeemViewController:(UIImage *)_image andText:(NSString *)text
{
    if (curQRImage) {
        [curQRImage release];
    }
    curQRImage = [_image retain];
    isRedeemScreenCall  = YES;
   // [self.navigationController popViewControllerAnimated:YES];
    NSArray * qrCodeCompArray = [text componentsSeparatedByString:@"<sep>"];
    NSString * curCopPoiID = [qrCodeCompArray objectAtIndex:0];
//    if (userID && userID.length > 0) {
    
    NSLog(@"QRCode : %@ and POIID : %@",curCopPoiID,selectedCoupon.poiId);
    
    if ([curCopPoiID isEqualToString:selectedCoupon.poiId]) {
        [appDelegate progressHudView:self.view andText:@"Processing"];
        isQRRedeem = YES;
        [redeemCoupBtn setHidden:YES];
        NSString * curCouponID = selectedCoupon.couponId;
        NSString * curPoiID = selectedCoupon.poiId;
        NSString * curSubID = appDelegate.setting.subsId;
        NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:curPoiID];
        NSString * param2 = [XMLUtil getParamXMLWithName:@"couponId" andValue:curCouponID];
        NSString * param3= [XMLUtil getParamXMLWithName:@"uid" andValue:curSubID];
        NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_RedeemCoupon_Call andParams:params];
        postReq = [[XMLPostRequest alloc]init];
        postReq.delegate = (id)self;
        [postReq sendPostRequestWithRequestName:k_RedeemCoupon_Call andRequestXML:reqXML];
        //[postReq release];
    }
    else
    {
        [curQRImage release];
        curQRImage = nil;
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Invalid QR code!"];
    }
        
        
//    }
//    else
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please first login!"];
    qrCodeCompArray = nil;
    curCopPoiID = nil;
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
   
    NSLog(@"%@",info);
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
      UIImage * _image = [info objectForKey: UIImagePickerControllerOriginalImage];
//    reader.delegate = nil;
     // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    [self gotoRedeemViewController:_image andText:symbol.data];
//    reader.delegate = nil;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


@end
