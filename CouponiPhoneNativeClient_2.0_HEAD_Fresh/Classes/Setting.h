//
//  Settings.h
//  RivePoint
//
//  Created by Shahzad Mughal on 2/17/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setting : NSObject {
	int pk;
	NSString *deviceId;
	NSString *email;
	NSString *zip;
	NSString *longitute;
	NSString *latitude;
	NSString *city;
	NSString *county;
	NSString *state;
	NSString *country;
	NSString *enableGPS;
	NSString *gpsAccuracy;
	NSString *subsId;
	
}

@property int pk;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *longitute;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *county;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *enableGPS;
@property (nonatomic, retain) NSString *gpsAccuracy;
@property (nonatomic, retain) NSString *subsId;

+(Setting*)getDefaultSetting;

@end
