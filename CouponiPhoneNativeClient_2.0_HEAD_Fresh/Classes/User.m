//
//  User.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "User.h"


@implementation User
@synthesize sid;
@synthesize uid;
@synthesize pwd;
@synthesize email;

- (void) dealloc
{
	[sid release];
	[uid release];
	[pwd release];
	[email release];
	[super dealloc];
}

@end
