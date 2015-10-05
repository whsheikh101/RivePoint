//
//  ShareViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "ShareViewController.h"
#import "StringUtil.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "CommandParam.h"

@implementation ShareViewController
@synthesize couponId;
@synthesize poiId;

-(IBAction) submit{
	if([StringUtil validateEmail:email.text]){
		[self sendCommandExecutionRequest];
	}
	else{
		[appDelegate  showAlert:NSLocalizedString(KEY_INVALID_EMAIL,@"") delegate:appDelegate];
	}
}
-(IBAction) reset{
	email.text =@"";
}
-(void) sendCommandExecutionRequest{
	[appDelegate showActivityViewer];
	httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
	
	NSString *string = [CommandUtil getXMLForShareCouponCommmand:email.text couponId:couponId poiId:poiId];
	//[FlurryUtil logShareCouponToFriend:couponId poiId:poiId zipCode:appDelegate.setting.zip];
	[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
	
	
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
	//[FlurryAPI endTimedEvent:SHARE_COUPON_TO_FRIEND_EVENT];
	
	[appDelegate hideActivityViewer];
	if(param && [param.paramValue isEqualToString:@"1"]){
			[appDelegate  showAlert:NSLocalizedString(KEY_COUPON_SHARED_SUCCESS,@"") delegate:appDelegate];
			[email resignFirstResponder];
			//[appDelegate.window sendSubviewToBack:self.view];
			[param release];
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_ERROR_SHARING_COUPON,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
		
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if([StringUtil validateEmail:email.text]){
		[self sendCommandExecutionRequest];
	}
	else{
		[appDelegate  showAlert:NSLocalizedString(KEY_INVALID_EMAIL,@"") delegate:appDelegate];
		return NO;
		
	}
	
	return YES;
}

-(void)communicationError:(NSString *)errorMsg{
	
	[httpTransportAdaptor release];
	[appDelegate hideActivityViewer];
    
    NSString * alertMsg = @"";
    if (errorMsg.length > 1) {
        alertMsg = errorMsg;
    }
    else
        alertMsg = NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING);
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:alertMsg delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Retry",nil];
	[alert show];	
	[alert release];
	//[FlurryUtil logShareCouponToFriendError:couponId poiId:poiId zipCode:appDelegate.setting.zip];
}
- (void)viewWillAppear:(BOOL)animated{
	
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		[self sendCommandExecutionRequest];
	}
	else{
		NSLog(@"Cancel pressed");
		[[self navigationController] popViewControllerAnimated:YES];
	}
	
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
- (IBAction) onClickToChange{
	//	cancelBarButtonItem.enabled = YES;
	//Add the overlay view.
	[self placeOverlayController];
	[self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	
}
- (void) dealloc
{
	[poiId release];
	[couponId release];
	[ovController release];
	[super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIImageView *imgView = (UIImageView *) self.view ;
	imgView.image=[UIImage imageNamed:@"share-bg.jpg"];
}


@end
