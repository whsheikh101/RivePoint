//
//  ProcessViewController.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 Netpace Inc. All rights reserved.
//

#import "ProcessViewController.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "RivePointSetting.h"

@implementation ProcessViewController
@synthesize user;
- (void)viewWillAppear:(BOOL)animated{
	appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelegate showActivityViewer];
	[self sendCommandExecutionRequest];
	
	
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ProcessViewController Frame : %@",NSStringFromCGRect(self.view.frame));
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568);
    }
    NSLog(@"StartupSettingsViewController Frame : %@",NSStringFromCGRect(self.view.frame));
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}

-(void)sendCommandExecutionRequest{
	[appDelegate showActivityViewer];
	httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
	NSString *string = [CommandUtil getXMLForRegisterSubscriberCommand];
	
	[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
	
}

-(void) processHttpResponse:(NSData *) response{
	
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"User" parseError:nil];
	NSArray *result =[parser getArray];
	if(self.user)
		self.user = nil;
	self.user =[result objectAtIndex:0];
	[parser setArray];
	[parser release];
	[httpTransportAdaptor release];
	[result release];
	
	[response release];	
	
	[appDelegate hideActivityViewer];
	if(self.user){
		
		appDelegate.setting.subsId = user.sid;
		//[FlurryAPI setUserID:appDelegate.setting.subsId];
		[appDelegate.sManager updateSubsId:appDelegate.setting];
		
		[appDelegate.window sendSubviewToBack:self.view];
		
		appDelegate.setting.email = self.user.email;
		[appDelegate.sManager update:appDelegate.setting];
		
		appDelegate.userSubsId = user.sid;
        [[NSUserDefaults standardUserDefaults] setValue:user.sid forKey:k_User_Regis_Id];
	}
	else
		[self communicationError:@""];
	
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		[self sendCommandExecutionRequest];
	}
	else{
		NSLog(@"Cancel pressed");
	}
}

-(void)communicationError:(NSString *)errorMsg{

	[httpTransportAdaptor release];
    
    NSString * alertMsg = @"";
    if (errorMsg.length > 1) {
        alertMsg = errorMsg;
    }
    else
        alertMsg = NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING);
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) 
													message:alertMsg 
												   delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Retry",nil];
	[alert show];	
	[alert release];
		
}
- (void) dealloc
{
	[user release];
	[super dealloc];
}


@end
