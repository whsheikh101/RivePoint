//
//  DeviceUtil.m
//  RivePoint
//
//  Created by Shahzad Mughal on 2/27/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "DeviceUtil.h"


@implementation DeviceUtil
+(NSString*) getDeviceId{
//	UIDevice *myCurrentDevice = [UIDevice currentDevice];
//	NSString *did = [NSString stringWithString: [myCurrentDevice uniqueIdentifier] ];
//	//[myCurrentDevice release];
//	return did ;
    
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}
@end
