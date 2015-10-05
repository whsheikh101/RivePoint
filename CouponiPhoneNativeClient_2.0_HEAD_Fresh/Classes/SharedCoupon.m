//
//  SharedCoupon.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/3/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "SharedCoupon.h"


@implementation SharedCoupon
@synthesize sndrId;
@synthesize sndrEmail;
@synthesize tCntSUsr;

- (void) dealloc
{
	[sndrId release];
	[sndrEmail release];
	[tCntSUsr release];
	[super dealloc];
}

@end
