#import "SettingsView.h"
#import "Setting.h"
#import "SettingManager.h"
#import "XMLParser.h"
#import "HttpTransportAdaptor.h"
#import "CommandParam.h"
#import "StringUtil.h"
#import "CommandUtil.h"
#import "LocationUpdater.h"

@class AppDelegate;


@implementation SettingsView

@synthesize geoCode;
@synthesize overlayViewController;
//@synthesize cancelBarButtonItem;

- (IBAction) updateGpsLocation{
	[locationUpdator updateLocation:self];
}

- (IBAction)GPSAccuracyChanged {
//	NSLog(@"GPS Accuracy %f ", gpsAccuracy.value );
    NSString *strLabel = @" ";
	NSString *distance = @"" ;
	strLabel=[strLabel stringByAppendingFormat:@"%1.0f",gpsAccuracy.value];
	distance=[distance stringByAppendingFormat:@"%1.0f",gpsAccuracy.value];
	
//	NSLog(@"%@",strLabel);	
//	NSLog(@" distance %@" ,distance);
//	
	Setting *s = [appDelegate.sManager find];
	s.gpsAccuracy = distance;
	appDelegate.setting = s;
	[appDelegate.sManager update:s];
	//[appDelegate updateGpsAccuracy];
	
	gpsAccuracyLabel.text = strLabel;
}



- (IBAction)isGPSEnabled {
	/*
	NSLog(@"gps setting changed");
	Setting *s = [appDelegate.sManager find];
	
	
	if (gpsSwitch.on == FALSE)
	{
		s.enableGPS = [[NSString alloc]initWithString: @"NO"];
		[gpsAccuracy setEnabled:FALSE];
		
		[appDelegate stopUpdatingLocation];
	}
	else
	{	s.enableGPS = [[NSString alloc] initWithString: @"YES"];
		[gpsAccuracy setEnabled:TRUE];
		[appDelegate updateLocation];
	}
	
	[update setEnabled:gpsAccuracy.enabled];
	gpsAccuracy.value = [s.gpsAccuracy intValue];
    appDelegate.setting = s;
	
	[appDelegate.sManager update:s];
	 */
}

- (void)initializeComponents {
	appDelegate  = (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
	locationUpdator =[appDelegate getLocationUpdatorInstance];
	//Setting *s = appDelegate.setting;
	Setting *s = [appDelegate.sManager find];
	
	gpsSwitch.on = [s.enableGPS boolValue];
	[gpsAccuracy setEnabled:[s.enableGPS boolValue]];
	[update setEnabled:YES];
	gpsAccuracy.value = [s.gpsAccuracy intValue];
	NSString *strLabel = @" ";
	gpsAccuracyLabel.text = [strLabel stringByAppendingFormat:@"%1.0f",gpsAccuracy.value];
    if (!(appDelegate.setting.email == (id)[NSNull null] || appDelegate.setting.email.length == 0 )) {
        email.text = appDelegate.setting.email;
    }
	
	
	[s release];
}


- (IBAction)zipCodeChanged {
    NSLog(@"Zip Code changed to %@", zipCode.text);
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
	
	if(param){
		
		appDelegate =  (RivePointAppDelegate *) [[UIApplication sharedApplication] delegate];
		appDelegate.setting.email = email.text;
		[appDelegate.sManager update:appDelegate.setting];
		
		[email resignFirstResponder];
		[param release];
		[overlayViewController.view removeFromSuperview];
		[overlayViewController release];
		overlayViewController = nil;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:@"Email updated successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
	}
	else
		[self communicationError:@""];
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if([StringUtil validateEmail:email.text]){
            if([textField.text isEqualToString:appDelegate.setting.email]){
                [email resignFirstResponder];
                [overlayViewController.view removeFromSuperview];
                [overlayViewController release];
                overlayViewController = nil;
                return YES;
            }
		httpTransportAdaptor = [[HttpTransportAdaptor alloc]init];
		[email resignFirstResponder];
		NSString *string = [CommandUtil getXMLForEmailSubscription:appDelegate.setting.subsId email:email.text];
//		cancelBarButtonItem.enabled = NO;
		[httpTransportAdaptor sendXMLRequest:string referenceOfCaller:self];
		
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_INVALID_EMAIL,@"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
		return NO;
		
	}
	
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
     email.text = appDelegate.setting.email;
}


- (void)refreshRecords{
    
    NSLog(@"Settings GPS Updates refreshRecords");
    [appDelegate removeLoadingViewFromSuperView];
	NSString *label = [appDelegate getLocationLabel];
	geoCode.text = label ;
	zipCode.text = appDelegate.setting.zip;
	
}

-(void)communicationError:(NSString *)errorMsg{
	
	[httpTransportAdaptor release];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_FAILED_UPDATE_EMAIL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
	
}
- (void)dealloc {



    [zipCode release];
	[geoCode release];
    
    geoCode = nil;
    zipCode = nil;
    
    [super dealloc];
}

@end
