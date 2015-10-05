//
//  Settings.m
//  RivePoint
//
//  Created by Shahzad Mughal on 2/17/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import "Setting.h"
#import <UIKit/UIDevice.h>
#import "DeviceUtil.h"

@implementation Setting

@synthesize pk, deviceId, email, longitute, latitude, zip , city, county, state, country, enableGPS,gpsAccuracy,subsId;

+(Setting*)getDefaultSetting {

	Setting *s = [[Setting alloc]init];
	s.deviceId= [DeviceUtil getDeviceId] ;
	s.email=@"Not Available" ;
	s.zip = @"94583" ;
	s.longitute = @"-121.957801" ;
	s.latitude = @"37.752300" ;
	s.city = @"San Ramon" ;
	s.county = @"county" ;
	s.state = @"CA" ;
	s.country = @"US" ;
	s.enableGPS = @"NO" ;
	s.gpsAccuracy = @"100" ;
	s.subsId=@"-1";
	
	return s ;
}

-(void)dealloc {
	[email release];
	[longitute release];
	[latitude release] ;
	[zip release];
	[city release];
	[county release];
	[state release];
	[country release] ;
	[enableGPS release];
	[gpsAccuracy release];
	[deviceId release];
	[subsId release];
	[super dealloc];
}
@end
