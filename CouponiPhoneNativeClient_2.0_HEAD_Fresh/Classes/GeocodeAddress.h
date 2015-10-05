//
//  GeocodeAddress.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/10/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GeocodeAddress : NSObject {
	NSString *street;
	NSString *city;
	NSString *county;
	NSString *state;
	NSString *country;
	NSString *postalcode;
	NSString *resultcode;
	NSString *altitude;
	NSString *latitude;
	NSString *longitude;
	
	
}

@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *county;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *postalcode;
@property (nonatomic, retain) NSString *resultcode;
@property (nonatomic, retain) NSString *altitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;


@end
