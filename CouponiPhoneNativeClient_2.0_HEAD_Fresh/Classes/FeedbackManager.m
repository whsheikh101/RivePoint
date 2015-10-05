//
//  FeedbackManager.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "FeedbackManager.h"
#import "StringUtil.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "CommandParam.h"
#import "CouponManager.h"

@implementation FeedbackManager
@synthesize poi, coupon;

-(void) sendCommandExecutionRequest:(NSString *)feedbackType rating:(NSString *)rating{
	if([feedbackType isEqualToString:@"2"]){
		ratingType = 2;
		[theAlert dismissWithClickedButtonIndex:0 animated:YES];
		//[FlurryUtil logReportBroken:coupon.couponId poiId:poi.poiId zipCode:appDelegate.setting.zip];
	}
	else{
		ratingType = 1;
	//	[FlurryUtil logRateCoupon:coupon.couponId poiId:poi.poiId zipCode:appDelegate.setting.zip];

	}
	[theAlert release];
	[appDelegate showActivityViewer];
	httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
	
	NSString *string = [CommandUtil getXMLForRegisterFeedbackCommmand:feedbackType rating:rating couponId:coupon.couponId poiId:poi.poiId];
	
	[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
	
	
}
-(void)showFeedbackAlert{
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	if(coupon.rating)
		rate = [coupon.rating intValue];
	else
		rate = 0;
	
	if(!feedbackViewControl)
		feedbackViewControl = [[FeedbackAlertController alloc] initWithNibName:@"FeedbackAlertView" bundle:nil];
	feedbackViewControl.rate = rate;

	theAlert = [[UIAlertView alloc] initWithTitle:@"Feedback" message:@"Please provide your feedback.\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate it!", nil];
	/*UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 88.0, 260.0, 25.0)];
	[myTextField setBackgroundColor:[UIColor whiteColor]];.
	myTextField.borderStyle = UITextBorderStyleRoundedRect;*/
	UILabel *errorLabel =[[UILabel alloc] initWithFrame:CGRectMake(12.0, 65.0, 260.0, 25.0)];
	[errorLabel setBackgroundColor:[UIColor clearColor]];
	[errorLabel setTextColor:[UIColor redColor]];
	errorLabel.text =@"";
	feedbackViewControl.view.backgroundColor = [UIColor clearColor];
	feedbackViewControl.view.frame = CGRectMake(18.0, 80.0, 260.0, 130.0);
	
	[feedbackViewControl.star1 setBackgroundColor:[UIColor clearColor]];
	[feedbackViewControl setImageRating:rate];
	[feedbackViewControl setFeedbackManagerRef:self];
	[theAlert addSubview:feedbackViewControl.view];
	[theAlert show];
	
}

-(void) processHttpResponse:(NSData *) response{
	
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"CommandParam" parseError:nil];
	NSArray *result =[parser getArray];
	CommandParam *param =[[result objectAtIndex:0] retain];
	[parser setArray];
	[parser release];
	[httpTransportAdaptor release];
	[result release];
	
	[response release];	
	
	if(ratingType == 1){
		//[FlurryAPI endTimedEvent:RATE_COUPON_EVENT];
		
	}else{
		//[FlurryAPI endTimedEvent:REPORT_BROKEN_EVENT];
		
	}
	
	
	[appDelegate hideActivityViewer];
	if(param && [param.paramValue isEqualToString:@"1"]){
		if(ratingType == 1){
			coupon.rating = [NSString stringWithFormat:@"%d",feedbackViewControl.rate];
		    coupon.poiId = poi.poiId;
			CouponManager *cm = [[CouponManager alloc] init];
			if([cm poiCouponExists:coupon])
				[cm update:coupon];
			[cm release];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_FEEDBACK_REGISTERED_SUCCESSFULLY,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_ERROR_REGISTERING_FEEDBACK,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
		
	if(param)
		[param release];
	
}

-(void)communicationError:(NSString *)errorMsg{
	[appDelegate hideActivityViewer];
	[httpTransportAdaptor release];
	[appDelegate showAlert:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:appDelegate];
	//if(ratingType == 1){
		//[FlurryUtil logRateCoupon:coupon.couponId poiId:poi.poiId zipCode:appDelegate.setting.zip];
		
	//}else{
		//[FlurryUtil logReportBroken:coupon.couponId poiId:poi.poiId zipCode:appDelegate.setting.zip];		
	//}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		//[[self navigationController] popViewControllerAnimated:YES];
		if(feedbackViewControl.rateType == 0 && feedbackViewControl.rate == 0){
			return;
		}
		[self sendCommandExecutionRequest:[NSString stringWithFormat:@"%d", feedbackViewControl.rateType] 
								   rating:[NSString stringWithFormat:@"%d", feedbackViewControl.rate]];
	}
	else{
		NSLog(@"Cancel pressed");
		//[[self navigationController] popViewControllerAnimated:YES];
	}
	
}

- (void) dealloc
{
	[poi release];
	[coupon release];
	[feedbackViewControl release];
	[super dealloc];
}


@end
