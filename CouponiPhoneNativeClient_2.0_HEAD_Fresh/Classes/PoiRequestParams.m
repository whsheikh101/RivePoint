//
//  PoiRequestParams.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiRequestParams.h"


@implementation PoiRequestParams

@synthesize commandName;
@synthesize searchKeyword;
@synthesize poiCategoryId;
@synthesize fromSequenceNumber;
@synthesize toSequenceNumber;
@synthesize poiTypeToFetch;
@synthesize userLatitude;
@synthesize userLongitude;
@synthesize radius;
@synthesize userID;
@synthesize lastRegisteredPoiGroup;

- (void) dealloc
{
	[commandName release];
	[searchKeyword release];
	[poiCategoryId release];
	[fromSequenceNumber release];
	[toSequenceNumber release];
	[poiTypeToFetch release];
	[userLatitude release];
	[userLongitude release];
	[radius release];
	[userID release];
	[lastRegisteredPoiGroup release];
	[super dealloc];
}


@end
