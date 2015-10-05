//
//  LocationUpdater.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "LocationUpdater.h"
#import "XMLParser.h"
#import "CommandUtil.h"
#import "LocationUtil.h"
#import "MainViewController.h"

#define k_GPS_Enable 9513
#define k_GPS_Update 5536

@implementation LocationUpdater
@synthesize bestEffortAtLocation,timeout,reverseGeocoder,hasLocationServiceDisabledMessageShown;

-(void) processHttpResponse:(NSData *) response{
	NSError *error;
	XMLParser *p = [[XMLParser alloc] parseXMLFromData:response className:@"GeocodeAddress" parseError:error];
	
	NSMutableArray *arr = [p getArray];
	GeocodeAddress *code = [arr objectAtIndex:0];
	
	[self updateZipCode: code];
	
	[adaptor release];
	[p release];
	[response release];
	
	[appDelegate hideActivityViewer];
	if(isStartup){
		[appDelegate.window sendSubviewToBack:[appDelegate.startupSettingsViewController view]];
		appDelegate.tabBarController.selectedViewController = appDelegate.navController;
	}
	else{
		[appDelegate resetCachedObjects];
		[(MainViewController *)refOfControllerForCallback refreshRecords];
	}
	
}

-(void) updateZipCode:(GeocodeAddress*) code{
	[appDelegate updateSettingFromGeoCode:code];
	
}
-(void)communicationError:(NSString *)errorMsg{
	[appDelegate hideActivityViewer];
	[appDelegate setDefaultSettings];
    NSLog(@"Came here");
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
//	[appDelegate showAlert:[NSString stringWithFormat:NSLocalizedString(KEY_ALERT_DEFAULT_SETTINGS,EMPTY_STRING),
//							NSLocalizedString(KEY_ERROR_REVERSE_GEOCODING,EMPTY_STRING),appDelegate.setting.zip] delegate:self];
    
    [appDelegate showAlert:@"Internet connection appears to be offline." delegate:self];
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	if(showActivityViewerOnStartup){
//		[appDelegate showActivityViewer];
		showActivityViewerOnStartup = NO;
	}
//	[appDelegate.progressHud removeFromSuperview];
	if(newLocation.horizontalAccuracy < 0) return;
	
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
		NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
		if (locationAge > DEFAULT_LOCATION_AGE) return;
		// test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
		
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
			[timeout invalidate]; 
			self.timeout = nil;
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            
            NSLog(@"LocationUpdated Successfull");
            [appDelegate hideActivityViewer];
            NSLog(@"LocationUpdated didUpdateToLocation");
//            [appDelegate removeLoadingViewFromSuperView];
            
			[LocationUtil updateLocation:newLocation locationManager:locationManager];
			//[FlurryAPI setLocation:newLocation];
			
			[self sendCommandExecutionRequest];
            //[self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
			
		}			
	}

	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[appDelegate hideShowMethod];
	if(!refOfControllerForCallback){
		if([error code] != kCLErrorLocationUnknown){
			[timeout invalidate]; 
			self.timeout = nil;
			[appDelegate hideActivityViewer];
//            [appDelegate.progressHud removeFromSuperview];
            NSLog(@"LocationUpdated didFailWithError");
			[LocationUtil gpsOff:manager];
            if (isStartup) {
                [appDelegate.window sendSubviewToBack:[appDelegate.startupSettingsViewController view]];
                appDelegate.tabBarController.selectedViewController = appDelegate.navController;
                [appDelegate showAlert:[NSString stringWithFormat:NSLocalizedString(KEY_ALERT_DEFAULT_SETTINGS,EMPTY_STRING),
                                        NSLocalizedString(KEY_ERROR_LOCATION_UPDATE_FAILURE,EMPTY_STRING),appDelegate.setting.zip] 
                              delegate:nil];
            }
            else{
                [appDelegate removeLoadingViewFromSuperView];
                [appDelegate showAlert:@"Internet connection appears to be offline." delegate:self];
            }
        
		}
	}
	else{
		if([error code] != kCLErrorLocationUnknown){
			[timeout invalidate]; 
			self.timeout = nil;
			[appDelegate hideActivityViewer];
            NSLog(@"LocationUpdated didFailWithError 2");
            [appDelegate removeLoadingViewFromSuperView];
//            [appDelegate.progressHud removeFromSuperview];
			[LocationUtil handleLocationErrors:self error:error locationManager:manager];	
		}
	}
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"MKReverseGeocoder has failed.");
	//[self communicationError];
	adaptor = [[HttpTransportAdaptor alloc]init];
	NSString *string = [CommandUtil getXMLForReverseGeoCodeCommand:appDelegate.setting.latitude longitude:appDelegate.setting.longitute];
	[adaptor sendXMLRequest:string referenceOfCaller:self];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	GeocodeAddress *code = [[GeocodeAddress alloc] init];
	code.country = placemark.country;
	code.state = placemark.administrativeArea;
	code.city = placemark.subAdministrativeArea;
	if(placemark.postalCode)
		code.postalcode = placemark.postalCode;
	else
		code.postalcode = @"N/A";
	code.street = [NSString stringWithFormat:@"%@, %@, %@", placemark.thoroughfare, placemark.subLocality, placemark.locality]; 
	code.latitude = appDelegate.setting.latitude;
	code.longitude = appDelegate.setting.longitute;
	
	[self updateZipCode: code];
	[code release];
 	
	[appDelegate hideActivityViewer];
	if(isStartup){
		[appDelegate.window sendSubviewToBack:[appDelegate.startupSettingsViewController view]];
		appDelegate.tabBarController.selectedViewController = appDelegate.navController;
	}
	else{
		[appDelegate resetCachedObjects];
		[(MainViewController *)refOfControllerForCallback refreshRecords];
	}

}

-(void)updateLocation{
	//[self showGPSAlertDialog];
	[appDelegate showActivityViewer];
//	[self makeMapObject];
	isStartup = YES;
	showActivityViewerOnStartup = YES;
	[LocationUtil gpsOn:locationManager refDelegate:self];
	
}
-(void)updateLocation:(NSObject *)refController{
	[appDelegate showActivityViewer];
    [appDelegate progressHudView:appDelegate.window andText:@"Updating..."];
//	[self makeMapObject];
	refOfControllerForCallback = refController;
	isStartup = NO;
	[LocationUtil gpsOn:locationManager refDelegate:self];
	
}
-(void)makeMapObject {
	if(!mapView){
		mapView = [[MKMapView alloc] init];
		mapView.showsUserLocation = YES;
		mapView.delegate = self;	
	}
}
-(void)errorFindingLocation{
	[timeout invalidate]; 
	self.timeout = nil;
	// we have a measurement that meets our requirements, so we can stop updating the location
	// 
	// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
	//
	
	if(bestEffortAtLocation == nil){
//		[appDelegate hideActivityViewer];
//        [appDelegate.progressHud removeFromSuperview];
        NSLog(@"LocationUpdated errorFindingLocation");
        [appDelegate removeLoadingViewFromSuperView];
		[LocationUtil gpsOff:locationManager];
//		[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_UPDATE_FAILURE,EMPTY_STRING) delegate:self];
        [appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_UPDATE_FAILURE,EMPTY_STRING) delegate:self];
	}
	else{
		[LocationUtil updateLocation:bestEffortAtLocation locationManager:locationManager];
		[self sendCommandExecutionRequest];
	}
}
- (void)showGPSAlertDialog{
    if (showGPSAlert) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:[NSString stringWithFormat:NSLocalizedString(KEY_GPS_ALERT,EMPTY_STRING),appDelegate.setting.zip] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Enable GPS",nil];
        alert.tag = k_GPS_Enable;
		[alert show];	
		[alert release];
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == k_GPS_Enable) {
        if(buttonIndex==1){
            [LocationUtil gpsOn:locationManager refDelegate:self];
        }
        else{
            if(isStartup){
                [appDelegate.window sendSubviewToBack:[appDelegate.startupSettingsViewController view]];
                appDelegate.tabBarController.selectedViewController = appDelegate.navController;
            }
        }
    }
    else
        if (alertView.tag == k_GPS_Update) {
            if (buttonIndex == 1) {
                NSLog(@"Retry GPS UPdate");
            }
        }
	
	
}

-(void) sendCommandExecutionRequest{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [appDelegate.setting.latitude doubleValue];
	coordinate.longitude = [appDelegate.setting.longitute doubleValue];
	
	self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coordinate] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
	/*
	adaptor = [[HttpTransportAdaptor alloc]init];
	NSString *string = [CommandUtil getXMLForReverseGeoCodeCommand:appDelegate.setting.latitude longitude:appDelegate.setting.longitute];
	[adaptor sendXMLRequest:string referenceOfCaller:self];
	*/
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		showGPSAlert = YES;
		appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;

	}
	return self;
}
- (void)mapView:(MKMapView *)mkMapView didAddAnnotationViews:(NSArray *)views
{
	self.bestEffortAtLocation = mapView.userLocation.location;

}

- (void) dealloc {
	[mapView release];
	[bestEffortAtLocation release];
	[locationManager release];
	[adaptor release];
	[super dealloc];
}


@end
