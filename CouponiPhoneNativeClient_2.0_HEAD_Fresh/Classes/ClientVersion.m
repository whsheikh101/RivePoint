//
//  ClientVersion.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/20/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "ClientVersion.h"


@implementation ClientVersion
@synthesize vendor;
@synthesize version;
@synthesize clientType;

- (void) dealloc
{
	[vendor release];
	[version release];
	[clientType release];
	[super dealloc];
}

@end
