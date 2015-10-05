//
//  CommandParams.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/16/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CommandParam.h"


@implementation CommandParam
@synthesize Name;
@synthesize isCollection;
@synthesize collectionType;
@synthesize objectType;
@synthesize paramValue;


- (void) dealloc
{
	[Name release];
	[isCollection release];
	[collectionType release];
	[objectType release];
	[paramValue release];
	[super dealloc];
}


@end

