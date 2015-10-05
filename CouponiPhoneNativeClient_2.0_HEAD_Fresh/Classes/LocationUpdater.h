//
//  LocationUpdater.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HTTPSupport.h"
#import "HttpTransportAdaptor.h"
#import "GeocodeAddress.h"
#import "RivePointAppDelegate.h"


@interface LocationUpdater : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate,HTTPSupport,MKReverseGeocoderDelegate,MKMapViewDelegate> {
	#define DEFAULT_TIMOUT  30
	#define DEFAULT_LOCATION_AGE 5.0

	RivePointAppDelegate *appDelegate;
	CLLocationManager *locationManager;
	BOOL showGPSAlert;
	HttpTransportAdaptor *adaptor;
	BOOL isStartup;
	NSObject *refOfControllerForCallback;
	CLLocation *bestEffortAtLocation;
	NSTimer *timeout;
	BOOL showActivityViewerOnStartup;
	MKReverseGeocoder *reverseGeocoder;
	MKMapView *mapView;
	BOOL hasLocationServiceDisabledMessageShown;
}
@property (nonatomic,retain) CLLocation *bestEffortAtLocation;
@property (nonatomic,retain) NSTimer *timeout;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property BOOL hasLocationServiceDisabledMessageShown;

-(void) showGPSAlertDialog;
-(void) sendCommandExecutionRequest;
-(void) updateZipCode:(GeocodeAddress*) code;
-(void)updateLocation;
-(void)updateLocation:(NSObject *)refController;
-(void)makeMapObject;
@end
