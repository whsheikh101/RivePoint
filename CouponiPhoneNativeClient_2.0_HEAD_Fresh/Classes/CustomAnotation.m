//
//  CustomAnotation.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 10/25/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CustomAnotation.h"


@implementation CustomAnotation

@synthesize coordinate;
@synthesize title;
@synthesize poiIndex;
@synthesize subtitle;

//- (NSString *)subtitle{
//	return subtitle;
//}
- (id) initWithCoordiantes:(float)latitude longitude:(float)longitude 
					 title:(NSString *)pTitle subtitle:(NSString *)pSubtitle{
	
	
	coordinate.latitude = latitude;
	coordinate.longitude = longitude;
	title = pTitle;
	subtitle = pSubtitle;
	
	return self;
}
- (void) dealloc
{
	[title release];
	[subtitle release];

	[super dealloc];
}

@end
