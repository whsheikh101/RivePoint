//
//  PoiDtoGroup.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiDtoGroup.h"


@implementation PoiDtoGroup

@synthesize poiTypeToFetch;
@synthesize totalPois;
@synthesize suggestedKeywords;
@synthesize fromSequenceNumber;
@synthesize toSequenceNumber;
@synthesize vector;
@synthesize totalPoisProcessed;
@synthesize next;
@synthesize previous;
@synthesize registerPoisCount;
@synthesize nextPage;
@synthesize previousPage;
@synthesize pageNumber;
@synthesize to;
@synthesize from;
- (void)dealloc
{
	[poiTypeToFetch release];
	[totalPois release];
	[suggestedKeywords release];
	[fromSequenceNumber release];
	[toSequenceNumber release];

	[totalPoisProcessed release];
	[registerPoisCount release];
	[nextPage release];
	[previousPage release];
	[pageNumber release];
	[to release];
	[from release];
	[vector release];
	[super dealloc];
}



@end
