//
//  EmailView.m
//  RivePoint
//
//  Created by Shahzad Mughal on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "EmailViewController.h"
#import "StringUtil.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "CommandParam.h"
#import "ShareIt.h"

@implementation EmailViewController
@synthesize shareIt;

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
	NSString *string = [CommandUtil getXMLForEmailSubscription:appDelegate.setting.subsId 
						email:[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
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
	
	[appDelegate hideActivityViewer];
	if(param){
		
			appDelegate.setting.email = email.text;
			[appDelegate.sManager update:appDelegate.setting];
			
			[email resignFirstResponder];
			[appDelegate.window sendSubviewToBack:self.view];
			[param release];
            [shareIt showShareDialog:@""];
            		
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_FAILED_UPDATE_EMAIL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
		
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	/*if([StringUtil validateEmail:email.text]){
		[self sendCommandExecutionRequest];
	}
	else{
		[appDelegate  showAlert:NSLocalizedString(KEY_INVALID_EMAIL,@"") delegate:appDelegate];
		return NO;
		
	}*/
    [textField resignFirstResponder];
	
	return YES;
}

-(void)communicationError:(NSString *)errorMsg{
	
	[httpTransportAdaptor release];
    
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
- (void)viewWillAppear:(BOOL)animated{
	
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		NSLog(@"Retry pressed.. %d" , buttonIndex);
		[self sendCommandExecutionRequest];
	}
	else{
		NSLog(@"Cancel pressed");
		exit(0);
	}
	
}

-(IBAction) cancel{
   
    [self.view removeFromSuperview];
}

- (void) dealloc
{
	
	[super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	UIImageView *imgView = (UIImageView *) self.view ;
	imgView.image=[[UIImage imageNamed:@"email-screen-bg.png"] autorelease];
}


@end
