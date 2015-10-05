//
//  Poi.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "Poi.h"


@implementation Poi

@synthesize pk;
@synthesize poiId;
@synthesize poiSequenceNumber;
@synthesize poiCategoryId;
@synthesize name;
@synthesize phoneNumber;
@synthesize completeAddress;
@synthesize distance;
@synthesize couponCount;
@synthesize imageName;
@synthesize imageBytes;
@synthesize isSponsored;
@synthesize isCOTDPoi;
//@synthesize banner;
//@synthesize bigLogo;
//@synthesize logo;
@synthesize logoPresentStatus;
@synthesize logoImage;
@synthesize latitude;
@synthesize longitude;
@synthesize userPoints;
@synthesize reviewCount;
@synthesize feedbackCount;
@synthesize poiType;

+(Poi*) getTestPoi {
	
	Poi *p = [[Poi alloc]init];
	p.poiId= @"00" ;
	p.poiSequenceNumber=@"11" ;
	p.poiCategoryId = @"22" ;
	p.name = @"name" ;
	p.phoneNumber = @"+923212070560" ;
	p.completeAddress = @"San Roman" ;
	p.distance = @"33" ;
	p.couponCount = @"44" ;
	p.imageName = @"image name" ;
	p.isSponsored = @"NO" ;
	p.feedbackCount = 4;
    p.reviewCount = 6;
    p.poiType = 0;
	return p ;
}

-(void) setBLogo:(NSData *) theLogo{
    NSLog(@"Set Logo Called");
//	if(bigLogo)
//		[bigLogo release];
//	bigLogo = theLogo;
}
- (void)dealloc
{
	[poiId release];
	[poiSequenceNumber release];
	[poiCategoryId release];
	[name release];
	[phoneNumber release];
	[completeAddress release];
	[distance release];
	[couponCount release];
	[imageName release];
	[imageBytes release];
	[isSponsored release];
	[isCOTDPoi release];
//	[banner release];
//	[bigLogo release];
//	[logo release];
	[logoImage release];
	[latitude release];
	[longitude release];
	[userPoints release];
    [poiType release];
	[super dealloc];
}
@end
