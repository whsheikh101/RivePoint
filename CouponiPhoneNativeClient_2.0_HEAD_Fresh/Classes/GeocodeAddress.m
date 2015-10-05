//
//  GeocodeAddress.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/10/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "GeocodeAddress.h"


@implementation GeocodeAddress

@synthesize street;
@synthesize city;
@synthesize county;
@synthesize state;
@synthesize country;
@synthesize postalcode;
@synthesize resultcode;
@synthesize altitude;
@synthesize latitude;
@synthesize longitude;

- (void)dealloc
{
	[street release];
	[city release];
	[county release];
	[state release];
	[country release];
	[postalcode release];
	[resultcode release];
	[altitude release];
	[latitude release];
	[longitude release];
	[super dealloc];
}
@end
