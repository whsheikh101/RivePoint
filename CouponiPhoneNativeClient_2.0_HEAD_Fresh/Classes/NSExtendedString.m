//
//  NSExtendedString.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/25/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "NSExtendedString.h"


@implementation NSExtendedString

-(unsigned int) indexOf:(char) searchChar {
	NSRange searchRange;
	searchRange.location=(unsigned int)searchChar;
	searchRange.length=1;
	NSRange foundRange = [backingString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithRange:searchRange]];
	return foundRange.location;
}

-(NSExtendedString *) initWithString: (NSString *) origString {
	if(self = [super init]) {
		backingString = [[NSString alloc] initWithString:origString];
	}
	return self;
}
-(NSExtendedString *) initWithExtendedString: (NSExtendedString *) origString {
	if(self = [super init]) {
		backingString = [[origString string] copy];
	}
	return self;
}

-(NSString *) string {
	return backingString;
}
- (void) dealloc
{

	[super dealloc];
}

@end
