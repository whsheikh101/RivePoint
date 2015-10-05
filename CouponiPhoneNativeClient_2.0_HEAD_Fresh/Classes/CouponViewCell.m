//
//  CouponViewCell.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/7/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "CouponViewCell.h"
#import "Coupon.h"
#import "GeneralUtil.h"
#import "SavedListCouponsViewController.h"
#import "SCListCouponsViewController.h"
#import "QRCodeViewController.h"
#import "RivePointSetting.h"
@implementation CouponViewCell
#define COUPON_COUNT_IMAGE_X 100
#define COUPON_COUNT_IMAGE_Y 44
#define COUPON_COUNT_IMAGE_HEIGHT 12
#define ONE_COUPON_IMAGE_WIDTH 10
#define COUNT_LABEL_WIDTH 80
#define TOTAL_COUPON_COUNT_IMAGES 6

#define k_FACEBOOK_Alert 753
#define k_TWITTER_Alert 951

@synthesize couponIndex;
@synthesize isSaved;
@synthesize isShared;
@synthesize couponLabel;
@synthesize numberOfPOICoupons,currCouponId;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        
		// Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}



- (void)layoutSubviews {
	

	//self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
}
-(void)setAttibutesOnLoad{

	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"couponList-bg.png"]];
	//[UIImage imageNamed:@"sample-coupon-preview.png"];
	//view.frame = CGRectMake(0, 0, 349, 50);
	self.backgroundView = view;
	[view release];
}
-(void) setCouponContent:(Coupon *) coupon{
	couponCountLabel.hidden = NO;
    couponCountLabel.text = @"";
	couponRef = coupon;
    isShouldSent = NO;
	[previewButton setImage:nil forState:UIControlStateNormal];
 	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	[previewButton setImage:nil forState:UIControlStateNormal];
	self.currCouponId = coupon.couponId;
	UIImage  *imageFromDic = [appDelegate getCouponPreviewImageFromDictionary:coupon.couponId];
	if(imageFromDic){
		[previewButton setImage:imageFromDic forState:UIControlStateNormal];
	}
	else{
		[NSThread detachNewThreadSelector:@selector(setCouponPreviewImage:) toTarget:self withObject:coupon.couponId];
	}
	
	NSMutableString *string = [[NSMutableString alloc] init];
	couponLabel.text = coupon.title;
		if(![coupon.subTitleLineOne isEqualToString:@"null"])
		[string appendFormat:@"%@ ",coupon.subTitleLineOne];
	
	if(![coupon.subTitleLineTwo isEqualToString:@"null"])
		[string appendFormat:@"%@",coupon.subTitleLineTwo];
		
	subTitleLabel.text = string;	
	// set formattings
	[string release];
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
//	double sec = 1000;
    
	NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([coupon.validTo doubleValue])/1000];
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"MM/dd/yyyy"];
    NSString * nDate = [dtfrm stringFromDate:toDate];
    expiryDateLabel.text = [NSString stringWithFormat:@"%@", nDate];
    [dtfrm release];
	
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//	[dateFormatter setDateStyle:NSDateFormatterShortStyle]; 
//	[dateFormatter setTimeStyle:NSDateFormatterNoStyle]; 
//	NSString *tempDateStr =  [dateFormatter stringFromDate:toDate];
//	NSArray *array = [tempDateStr componentsSeparatedByString:@"/"];
//	int month =  [[array objectAtIndex:0] intValue];
//	int day = [[array objectAtIndex:1] intValue];
//	NSString *dateString = nil;
//	if(month < 10 && day < 10)
//		dateString = [NSString stringWithFormat:@"0%d/0%d/20%@",month,day,[array objectAtIndex:2]];
//	else if(month < 10 && day > 10)
//		dateString = [NSString stringWithFormat:@"0%d/%d/20%@",month,day,[array objectAtIndex:2]];
//	else if(month > 10 && day < 10)
//		dateString = [NSString stringWithFormat:@"%d/0%d/20%@",month,day,[array objectAtIndex:2]];
//	else
//		dateString = [NSString stringWithFormat:@"%d/%d/20%@",month,day,[array objectAtIndex:2]];
//	expiryDateLabel.text = [NSString stringWithFormat:@"%@", dateString];
//	[dateFormatter release];

	if(![coupon.perUserRedemption isEqualToString:@"-1"]){
		int couponCount = [coupon.perUserRedemption intValue] - [coupon.userRedemptionCount intValue];
		if(couponCount > 1){
			couponCountLabel.text = [NSString stringWithFormat: @"%d Redemptions left",couponCount];
            couponCountLabel.text = [couponCountLabel.text stringByAppendingString:@". "];
		}else{
			couponCountLabel.text = [NSString stringWithFormat: @"%d Redemption left",couponCount];
            couponCountLabel.text = [couponCountLabel.text stringByAppendingString:@". "];
        }
        
	}
    if (coupon.earningPoints) {
        couponCountLabel.text = [couponCountLabel.text stringByAppendingString:
                                 [NSString stringWithFormat:@"(Get %@ Points)",coupon.earningPoints]];
                
    }else if(coupon.reqdPoints){
         couponCountLabel.text = [couponCountLabel.text stringByAppendingString:
                                  [NSString stringWithFormat:@"(Need %@ Points)",coupon.reqdPoints]];
        
    }
   
	/*else{
		couponCountLabel.hidden = YES;
	}*/
	saveButton.hidden = isSaved;
	deleteButton.hidden = !isSaved;
	

	//[NSThread detachNewThreadSelector:@selector(setCouponPreviewImage) toTarget:self withObject:nil];
	
	
	/*
	if(!appDelegate.terminateRequest){
		NSLog(@"Inside block");
		if(couponRef && [couponRef retainCount] > 0){
			if(!couponRef.couponImagePreview){
				NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
				NSString *urlFileName = @"url";
				NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
				NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
				NSLog(prefixURL);
				if(couponRef && [couponRef retainCount] > 0){
					NSURL *url= [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=2&couponId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,couponRef.couponId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
					
					if(!appDelegate.terminateRequest){
						NSLog(@"couponRef.couponImagePreview  =");
						if(couponRef && [couponRef retainCount] > 0){
							NSLog(@"couponRef retainCount[%d]", [couponRef retainCount]);
							NSData *prevImageData = 	[[[NSData alloc] initWithContentsOfURL:url] autorelease];
							if(prevImageData && [prevImageData length] > 0){
								couponRef.couponImagePreview  =  prevImageData;
								
							}
						}
					}
				}
			}
		}
		if(!appDelegate.terminateRequest){
			
			if(couponRef && [couponRef retainCount] > 0){
				
				UIImage  *uiImage =  [UIImage imageWithData:couponRef.couponImagePreview];
				uiImage = [GeneralUtil scaleImage:uiImage width:67 height:55];		
				couponRef.previewImage = uiImage;
				NSLog(@"couponPrevImage.image   is not null");
				
				//previewButton.imageView.image = [UIImage imageWithData:couponRef.couponImagePreview];
				[previewButton setImage:couponRef.previewImage 
							   forState:UIControlStateNormal];
			}
		}
	}
	*/
	
}
- (void) setCouponPreviewImage:(NSString *) couponId {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[couponId retain];
	NSData *receivedData = [GeneralUtil getCouponPreviewImage:couponId];
	UIImage *uiImage;
	if(receivedData){
		uiImage = [UIImage imageWithData:receivedData];
	}
	else{
		uiImage = [UIImage imageNamed:@"dummy-logo.png"];
	}
    if (!uiImage) {
        uiImage = [UIImage imageNamed:@"dummy-logo.png"];
    }
	
	
	if([couponId isEqualToString:currCouponId]){
		[previewButton setImage:uiImage forState:UIControlStateNormal];
	}
	[appDelegate setCouponPreviewImageInDictionary:uiImage key:couponId];
	[couponId release];
	[pool release];
} 
- (IBAction)redeemButton{
	if(!couponRef.perUserRedemption || [couponRef.perUserRedemption isEqualToString:@"-1"] || [couponRef.userRedemptionCount intValue] < [couponRef.perUserRedemption intValue]){
        if (couponRef.earningPoints) {
            //QRCodeViewController *qrController = [[QRCodeViewController alloc]init];
            //[qrController scanPressed];
           // [[viewController navigationController]presentModalViewController:qrController animated:YES];
            
            if(isSaved){
               
                [(SavedListCouponsViewController *)viewController setSavedCoupon:couponRef]; 
                [(SavedListCouponsViewController *)viewController dontReturnToRoot];
                [(SavedListCouponsViewController *)viewController setCouponViewCell:self];
                [(SavedListCouponsViewController *)viewController openZxingController];
                /*QRCodeViewController *qrCodeController = [[QRCodeViewController alloc]init];
                [qrCodeController setCouponViewCell:self];
                [qrCodeController setCoupon:couponRef];
                [viewController.navigationController presentModalViewController:qrCodeController animated:YES];
                [qrCodeController release];*/
            }else if(isShared){
                [(SCListCouponsViewController *)viewController setSharedCoupon:couponRef]; 
                [(SCListCouponsViewController *)viewController dontReturnToRoot];
                [(SCListCouponsViewController *)viewController setCouponViewCell:self];
                [(SCListCouponsViewController *)viewController openZxingController];
            }else{
                
                [(ListCouponsViewController *)viewController setCoupon:couponRef]; 
                [(ListCouponsViewController *)viewController dontReturnToRoot];
                [(ListCouponsViewController *)viewController setCouponViewCell:self];
                [(ListCouponsViewController *)viewController openZxingController];
            }
            
           
        }else{
           
            Poi *poi = [GeneralUtil getPoi];
            int userPoints = [poi.userPoints intValue];
            int reqPoints = [couponRef.reqdPoints intValue];
            if(cvController == nil)
            {
                cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
            }
            else
            {
                [cvController release];
                cvController = nil;
                cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
            }
            if (couponRef.reqdPoints) {
                if(userPoints < reqPoints){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:@"Your points are less than the required points" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];	
                    [alert release];
                    return;
                }
              cvController.isLoyaltyPoi = YES;  
            }
                cvController.isSaved = isSaved;
                cvController.isShared = isShared;
                cvController.currCoupon = couponRef;
                cvController.curPOI = poi;
                cvController.numberOfPOICoupons = numberOfPOICoupons;
                cvController.hidesBottomBarWhenPushed = YES;
                appDelegate.couponId = [couponRef.couponId intValue];
                appDelegate.couponIndex = self.couponIndex;
                [(ListCouponsViewController *)viewController dontReturnToRoot];
                [[viewController navigationController] pushViewController:cvController animated:YES];
                [cvController release];
//                cvController = nil;
            NSLog(@"retain conunt cvcontroller : %d",[cvController retainCount]);
        }
	}
	else
		[appDelegate  showAlert:NSLocalizedString(KEY_REDEMPTION_LIMIT_EXHAUSTED,@"") delegate:appDelegate];
	
}

-(void) couponSavedWithStatus:(NSString *)status
{
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
    if ([status isEqualToString:@"0"])
    {
        [appDelegate showAlertWithHeading:@"Saved successfully." andDesc:@""];
    }
    if ([status isEqualToString:@"-2"]) {
        [appDelegate showAlertWithHeading:@"Already marked save" andDesc:@""];
    }
    if ([status isEqualToString:@"-1"]) {
        [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Service not found."];
    }
    reqPost.delegate = nil;
    [reqPost release];
    reqPost = nil;
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
//    [appDelegate showAlertWithHeading:@"Rive Point" andDesc:errorMsg];
}


- (IBAction)saveButton{
	
	//Coupon *c = coupon;
    
    NSString * _userId = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
//    NSString * _userId = appDelegate.setting.subsId;
    if (_userId)
    {
       [appDelegate progressHudView:appDelegate.window andText:@"Processing..."];
        Poi *poi = [GeneralUtil getPoi];
        couponRef.poiId = poi.poiId;
        NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
        NSString * param2 = [XMLUtil getParamXMLWithName:@"couponId" andValue:couponRef.couponId];
        NSString * param3 = [XMLUtil getParamXMLWithName:@"uid" andValue:_userId];
        NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"saveCoupon" andParams:params];
        reqPost = [[XMLPostRequest alloc]init];
        reqPost.delegate = (id) self;
        [reqPost sendPostRequestWithRequestName:k_Save_Coupon andRequestXML:reqXML];
        //[reqPost release];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_RP_Login_Call object:nil userInfo:nil];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
}

- (IBAction)deleteButton{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CONFIRMATION_DELETE_COUPON_OPERATION,EMPTY_STRING) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];	
	[alert release];
	
}

-(IBAction)shareCouponAction{
    
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        BOOL isEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:k_Email_Enable];
        if (isEnabled == YES) {
            Poi *poi = [GeneralUtil getPoi];
            
            if(shareIt)
                [shareIt release];
            shareIt = [[ShareIt alloc] init];
            shareIt.couponId = couponRef.couponId;
            shareIt.poiId = poi.poiId;
            [shareIt showShareDialog:@""];
//            NSString *emailString = appDelegate.setting.email;
//            if ([emailString isEqualToString:@"Not Available"] || [emailString isEqualToString:@""]) {
//                NSLog(@"askForUserEmail called");
//                [appDelegate askForUserEmail:shareIt];
//            }else{
//                [shareIt showShareDialog:@""];
//            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enable email share ?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable", nil];
            alert.tag = 96845;
            [alert show];
            [alert release];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_RP_Login_Call object:nil userInfo:nil];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
 }
-(IBAction)couponFeedbackAction{

	Poi *poi = [GeneralUtil getPoi];
	if(!feedbackManager)
		feedbackManager = [[FeedbackManager alloc] init];
	feedbackManager.coupon = couponRef;
	feedbackManager.poi= poi;
	[feedbackManager showFeedbackAlert];
	
}
-(void) setLabel:(NSString *) textStr{
	couponLabel.text = textStr;	
	
}
- (void) setUIViewController: (UIViewController *) controller{
	viewController = controller;
}
- (void)viewDidDisappear:(BOOL)animated{
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    if (alertView.tag == k_FACEBOOK_Alert)
    {
        if (buttonIndex == 1)
        {
          [appDelegate SwitchToTabWithIndex:8];  
        }
        else
            NSLog(@"Cancel");
        
    }
    else
    {
        if (alertView.tag == k_TWITTER_Alert)
        {
            if (buttonIndex == 1)
            {
                [appDelegate SwitchToTabWithIndex:8];
            }
            else
                NSLog(@"Cancel");
            
        }
        else
            if (alertView.tag == k_Coupon_Alert_Tag) {
                if (buttonIndex == 1) {
                    [self redeemButton];
                }   
            }
            else
                if (alertView.tag == 96845) {
                    if (buttonIndex == 1) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k_Email_Enable];
                        [self shareCouponAction];
                    }
                }
                else
                {
                    if(buttonIndex==1){
                        [self confirmForDeletion:YES];
                    }
                    else{
                        NSLog(@"Cancel pressed");
                    }
                }
            
    }
}
- (void)confirmForDeletion:(BOOL)isConfirmed{
	if(isConfirmed)
		[(SavedListCouponsViewController *)viewController deleteCouponAtIndex:couponIndex];
}
-(IBAction)onPreviewClick{
	if(!couponDetailManager)
		couponDetailManager = [[CouponDetailManager alloc] init];
	if(!isSaved && !isShared){
		[couponDetailManager showDetailAlert:[GeneralUtil getPoi] coupon:couponRef];
	}
	else{
        [couponDetailManager showDetailAlertForSavedAndShared:[GeneralUtil getPoi] coupon:couponRef andDelegate:self];
	}


}
- (void)dealloc {

    [couponLabel release];
    [subTitleLabel  release];
    [expiryDateLabel release];
    [couponPrevPod release];
    [previewButton release];
    [couponCountLabel release];
    [saveButton release];
    [redeemButton release];
    
    couponLabel = nil;
    subTitleLabel = nil;
    expiryDateLabel = nil;
    couponPrevPod =nil;
    previewButton = nil;
    couponCountLabel = nil;
    saveButton = nil;
    redeemButton = nil;
    
	[couponDetailManager release];
	[feedbackManager release];
	[shareIt release];
	[currCouponId release];
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

- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    NSLog(@"Get Facebook Login Notification....");
    if (couponRef.couponId && couponRef.couponId.length > 0) {
        NSLog(@"ID is there");
        NSString * placeHolderStr = [NSString stringWithFormat:@"%@%@/%@",k_Share_Coupon_Base_Url,couponRef.couponId,couponRef.poiId];  
        NSString * titl = couponRef.title;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       FACEBOOK_API_KEY, @"app_id",
                                       placeHolderStr, @"link",
                                       titl,@"name",
                                       nil];
        
        [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(IBAction) onFacebookShareBtn
{
    NSLog(@"onFacebookShareBtn");
    
    if ([appDelegate.facebook isSessionValid])
    {
//        [appDelegate progressHudView:appDelegate.window andText:@"updating..."];
         NSString * placeHolderStr = [NSString stringWithFormat:@"%@%@/%@",k_Share_Coupon_Base_Url,couponRef.couponId,couponRef.poiId]; 
//        NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:placeHolderStr,@"link", nil];
//       [appDelegate.facebook requestWithGraphPath:@"me/links" andParams:params andHttpMethod:@"POST" andDelegate:self];
//        [params release];
        
        NSString * titl = couponRef.title;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       FACEBOOK_API_KEY, @"app_id",
                                       placeHolderStr, @"link",
                                       titl,@"name",
                                       nil];
        
        [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(useNotificationWithString:) 
         name:@"facebookloginnotification"
         object:nil];
        [self facebookLogin];        
    }
}

-(void) sendTweet
{
    if ([appDelegate.twitter isAuthorized] && isShouldSent == YES) {
        [appDelegate progressHudView:appDelegate.window andText:@"tweeting..."];
        appDelegate.shouldNotShareAlert = NO;
        if (couponRef) {
            NSLog(@"Coupon Id : %@",couponRef.couponId);
            NSLog(@"POI Id : %@",couponRef.poiId);
        }
        isShouldSent = NO;
        NSString * placeHolderStr = [NSString stringWithFormat:@"%@%@/%@",k_Share_Coupon_Base_Url,couponRef.couponId,couponRef.poiId];
        [appDelegate.twitter sendUpdate:[NSString stringWithFormat:@"%@ ",placeHolderStr]];
    }
}

-(void) twitterLoggedIn
{
    if (isCalled == YES) {
        isCalled = NO;
        [self performSelector:@selector(sendTweet) withObject:nil afterDelay:1.0];
    }
    
}

-(IBAction) onTwitterShareBtn
{
    NSLog(@"onTwitterShareBtn");
    if ([appDelegate.twitter isAuthorized])
    {
        [appDelegate progressHudView:appDelegate.window andText:@"tweeting..."];
        appDelegate.shouldNotShareAlert = NO;
        NSString * placeHolderStr = [NSString stringWithFormat:@"%@%@/%@",k_Share_Coupon_Base_Url,couponRef.couponId,couponRef.poiId];
        [appDelegate.twitter sendUpdate:[NSString stringWithFormat:@"%@ ",placeHolderStr]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(twitterLoggedIn) 
         name:k_Twitter_LoggedIn_Notification
         object:nil];
        isCalled = YES;
        isShouldSent = YES;
        [couponRef retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Twitter_login_Notification object:nil userInfo:nil];
    }
}

-(IBAction) onEmailBtn
{
   NSLog(@"onEmailBtn"); 
}

#pragma mark -
#pragma mark Facebook
-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
//    [appDelegate.progressHud removeFromSuperview];
////    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon sharing on your wall has fail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////    [alert show];
////    [alert release];
    
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
    
//    [appDelegate.progressHud removeFromSuperview];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon shared on your wall. request" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
}

-(void) request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"User ImageShare Request response : %@", response);   
}

-(void) requestLoading:(FBRequest *)request
{
    //NSLog(@"Request to user ImageShare is going");
}

- (void)dialogDidComplete:(FBDialog *)dialog
{
//    [appDelegate.progressHud removeFromSuperview];
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    [appDelegate.progressHud removeFromSuperview];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon shared on your wall." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    [appDelegate.progressHud removeFromSuperview];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon sharing on your wall has failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}



@end
