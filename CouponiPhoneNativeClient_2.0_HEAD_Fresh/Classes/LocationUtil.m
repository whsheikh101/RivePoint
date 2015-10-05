//
//  LocationUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/14/10.
//  Copyright 2010 Netpace Systems. All rights reserved.
//

#import "LocationUtil.h"
#import "RivePointAppDelegate.h"

@implementation LocationUtil

+(void) handleLocationErrors:(NSObject *) refDelegate error:(NSError *)error locationManager:(CLLocationManager *)locationManager{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	switch ([error code]) {
		case kCLErrorDenied:			
			[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_USER_DENIAL,EMPTY_STRING) delegate:refDelegate];
			break;
		case kCLErrorNetwork:
			[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_NEWWORK_UNAVAILABLE,EMPTY_STRING) delegate:refDelegate];
			break;
		case kCLErrorLocationUnknown:
			[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_UPDATE_FAILURE,EMPTY_STRING) delegate:refDelegate];
			break;
		default:
			[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_UPDATE_FAILURE,EMPTY_STRING) delegate:refDelegate];
			break;
	}
	[LocationUtil gpsOff:locationManager];
	
}
+(void) gpsOn:(CLLocationManager *)locationManager refDelegate:(LocationUpdater *) refDelegate{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(locationManager.locationServicesEnabled){
        
        NSLog(@"LocationUtil Update Call");
        
		[LocationUtil updateGpsAccuracy:locationManager];
		[locationManager startUpdatingLocation];
//		refDelegate.timeout = [NSTimer scheduledTimerWithTimeInterval:30 target:refDelegate selector:@selector(errorFindingLocation) userInfo:nil repeats:NO];
	}
	else{
		[appDelegate hideActivityViewer];
        [appDelegate removeLoadingViewFromSuperView];
		if(refDelegate.hasLocationServiceDisabledMessageShown){
			[appDelegate showAlert:NSLocalizedString(KEY_ERROR_LOCATION_SERVICE_NOT_ENABLED,EMPTY_STRING) delegate:refDelegate];		
		}
		else{
			refDelegate.hasLocationServiceDisabledMessageShown = YES;
		}
	
	}
}
+(void) gpsOff:(CLLocationManager *)locationManager{
	
	[locationManager stopUpdatingLocation];

}
+(void) updateGpsAccuracy:(CLLocationManager *)locationManager{
	locationManager.desiredAccuracy =  kCLLocationAccuracyHundredMeters;
}
+(void) updateLocation:(CLLocation *)newLocation locationManager:(CLLocationManager *)locationManager{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.lastKnownLocation = newLocation;
	
		NSString *lat = [[NSString alloc] initWithFormat:@"%f" , appDelegate.lastKnownLocation.coordinate.latitude];
		NSString *lng = [[NSString alloc] initWithFormat:@"%f" , appDelegate.lastKnownLocation.coordinate.longitude];
	
		appDelegate.setting.latitude = lat;
		appDelegate.setting.longitute = lng;
		appDelegate.setting.zip = @"";
		[lat release];
		[lng release];

	[LocationUtil gpsOff:locationManager];
}
@end
