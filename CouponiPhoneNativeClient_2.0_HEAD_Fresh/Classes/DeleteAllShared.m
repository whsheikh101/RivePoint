//
//  DeleteAllShared.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "DeleteAllShared.h"
#import "CommandUtil.h"
#import "XMLParser.h"
#import "CommandParam.h"

@implementation DeleteAllShared

-(void) sendCommandExecutionRequest{
	[appDelegate showActivityViewer];
	httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
	
	NSString *string = [CommandUtil getXMLForDeleteAllSharedCouponsCommmand];
	
	[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
	
	
}
-(void) emptySharedInbox{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CONFIRMATION_SHARED_INBOX_OPERATION,EMPTY_STRING) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];	
	[alert release];
}
-(void) processHttpResponse:(NSData *) response{
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
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
	if(param && [param.paramValue isEqualToString:@"1"])
		[appDelegate  showAlert:NSLocalizedString(KEY_EMPTY_INBOX_SUCCESS,@"") delegate:appDelegate];
	else if( [param.paramValue isEqualToString:@"0"])
		[appDelegate  showAlert:NSLocalizedString(KEY_ERROR_EMPTY_SHARED_COUPON_OPERATION,@"") delegate:appDelegate];
	else 
		[appDelegate  showAlert:param.paramValue delegate:appDelegate];
	
	if(param)
		[param release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==1){
		NSLog(@"Retry/Yes pressed.. %d" , buttonIndex);
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
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:alertMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry",nil];
	[alert show];	
	[alert release];
	
}

- (void) dealloc
{
	[super dealloc];
}


@end
