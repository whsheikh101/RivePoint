//
//  ShareIt.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "ShareIt.h"
#import "StringUtil.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "CommandParam.h"


@implementation ShareIt
@synthesize couponId;
@synthesize poiId;

-(void) submit{
    
	if([StringUtil validateEmail:email.text]){
		[self sendCommandExecutionRequest];
	}
	else{
		//[appDelegate  showAlert:NSLocalizedString(KEY_INVALID_EMAIL,@"") delegate:appDelegate];
		[self showShareDialog:NSLocalizedString(KEY_INVALID_EMAIL,@"")];
	}
}
-(void) reset{
	//email.text =@"";
}
-(void) sendCommandExecutionRequest{
//	[appDelegate showActivityViewer];
    [appDelegate progressHudView:appDelegate.window andText:@"sending..."];
	httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
	
	NSString *string = [CommandUtil getXMLForShareCouponCommmand:email.text couponId:couponId poiId:poiId];
	
	[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
	
	
}

-(void) processHttpResponse:(NSData *) response{
	
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate.progressHud removeFromSuperview];
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"CommandParam" parseError:nil];
	NSArray *result =[parser getArray];
	CommandParam *param =[[result objectAtIndex:0] retain];
	[parser setArray];
	[parser release];
	[httpTransportAdaptor release];
	[result release];
	
	[response release];	
	
//	[appDelegate hideActivityViewer];
	if(param && [param.paramValue isEqualToString:@"1"]){
			[appDelegate  showAlert:NSLocalizedString(KEY_COUPON_SHARED_SUCCESS,@"") delegate:appDelegate];
			[email resignFirstResponder];
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_ERROR_SHARING_COUPON,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		alertViewDialog = alert;
		[alert release];
	}
	if(param)
		[param release];
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	/*
	if([StringUtil validateEmail:textField.text]){
		[alertViewDialog resignFirstResponder];
		[self sendCommandExecutionRequest];
	}
	else{
		[self showShareDialog:NSLocalizedString(KEY_INVALID_EMAIL,@"")];
		return NO;
		
	}
	*/
    NSLog(@"%@",textField.text);
	[textField resignFirstResponder];
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
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
        NSString *s = [alertView textFieldAtIndex:0].text;
            email.text = s;
            [self submit];
        
	}
	else{
		NSLog(@"Cancel pressed");
		//[[self navigationController] popViewControllerAnimated:YES];
	}
	
}

-(void)showShareDialog:(NSString *)errorText{
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Share Coupon" message:@"Please provide email to share.\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
	theAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 88.0, 225.0, 25.0)];
	//[bslider setBackgroundColor:[UIColor blueColor]];
	email = myTextField;
    //email.text = @"wkhan@netpace.com";
	//[myTextField setBackgroundColor:[UIColor whiteColor]];
	myTextField.delegate = self;
	myTextField.keyboardType =   UIKeyboardTypeEmailAddress;
	myTextField.returnKeyType = UIReturnKeyDone;
	myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	myTextField.borderStyle = UITextBorderStyleRoundedRect;
	if([errorText length] != 0){
		UILabel *errorLabel =[[UILabel alloc] initWithFrame:CGRectMake(35.0, 65.0, 260.0, 25.0)];
		[errorLabel setBackgroundColor:[UIColor clearColor]];
		[errorLabel setTextColor:[UIColor redColor]];
		errorLabel.text =errorText;
		[theAlert addSubview:errorLabel];
	}
    myTextField = [theAlert textFieldAtIndex:0];
	//[theAlert addSubview:myTextField];
	[theAlert show];
	[myTextField becomeFirstResponder];
	[theAlert release];
	
}
- (void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.frame = CGRectMake( 20.0, 100.0, 300.0, 190.0 );
}
- (void) dealloc
{
	[poiId release];
	[couponId release];
	[super dealloc];
}


@end
