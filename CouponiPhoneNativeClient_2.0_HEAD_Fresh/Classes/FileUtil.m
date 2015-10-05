//
//  FileUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/29/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import "FileUtil.h"
#import "Poi.h"
#import "RivepointConstants.h"
#import "PoiFinderNew.h"

@implementation FileUtil
#define fileForGetCouponPOIS @"GetCouponsPOISFile.poi"
#define fileForCouponList @"CouponList.coupon"

+ (BOOL)writeApplicationData:(NSString *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName ];
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:appFile error:nil];
	
    return ([data writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:nil]);
}

+ (NSString *)applicationDataFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSString *myData = [NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:nil];
    //NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

+ (BOOL)persistGetCouponPOIS:(NSString *)data{
	@try{
		return ([self writeApplicationData:data toFile:fileForGetCouponPOIS]);
	}
	@catch (NSException * e) {
		NSLog(@"(BOOL)persistGetCouponPOIS:(NSString *)data: Caught %@: %@", [e name], [e  reason]);
	}
	return NO;

}
+ (NSString *)readPersistantGetCouponPOIS{
	@try{
		return ([self applicationDataFromFile:fileForGetCouponPOIS]);
	}
	@catch (NSException * e) {
		NSLog(@"(NSString *)readPersistantGetCouponPOIS: Caught %@: %@", [e name], [e  reason]);
	}
	return nil;
}



+ (BOOL)persistCouponList:(NSString *)data{
	@try{
		return ([self writeApplicationData:data toFile:fileForCouponList]);
	}
	@catch (NSException * e) {
		NSLog(@"(BOOL)persistCouponList:(NSString *)data: Caught %@: %@", [e name], [e  reason]);
	}
	return NO;

}
+ (NSString *)readPersistantCouponList{
	@try{
		return ([self applicationDataFromFile:fileForCouponList]);
	}
	@catch (NSException * e) {
		NSLog(@"(NSString *)readPersistantCouponList: Caught %@: %@", [e name], [e  reason]);
	}
	return nil;
}


+(void) setStringToNSUserDefaults:(NSString *)data key:(NSString *)key{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	// saving a NSString
	[prefs setObject:data forKey:key];

    [prefs synchronize];

}

+(NSString *) getStringFromNSUserDefaultsPerfs:(NSString *)key{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting a NSString
	NSString *myString = [prefs stringForKey:key];
	
	return myString;

}
+(void) setIntegerToNSUserDefaults:(int)data key:(NSString *)key{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
																   
	// saving an int
	[prefs setInteger:data forKey:key];
																	   
	[prefs synchronize];
														   
}
+(int) getIntegerFromNSUserDefaultsPerfs:(NSString *)key{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an int
	int valueInt = [prefs integerForKey:key];
	
	return valueInt;
	
}
+(void) setObjectToNSUserDefaults:(NSData *)data key:(NSString *)key{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// saving an int
	[prefs setObject:data forKey:key];
	
	[prefs synchronize];
	
}
+(NSData *) getObjectFromNSUserDefaults:(NSString *)key{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an int
	NSData *data = [prefs objectForKey:key];
	
	return data;
	
}
+(void) persistPoiLogos:(NSArray *) poiArray{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//NSMutableArray *logoArray = [[NSMutableArray alloc] init]; // set value
	NSMutableDictionary *logoDic = [[NSMutableDictionary alloc]init];
	
	for (Poi *poi in poiArray) {
	if(poi.logoImage){
			//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:poi.logoImage];
			//UIImageJPEGRepresentation(poi.logoImage, 1.0);
			[logoDic setObject:UIImageJPEGRepresentation(poi.logoImage, 1.0) forKey:poi.name];
			//[logoArray addObject:data];
		}
		
	}
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:logoDic];
	[logoDic release];
	
	[defaults setObject:data forKey:@"theKey"];
	[defaults synchronize];
	
	
}
+(void) setPoiLogos:(NSArray *) poiArray{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [defaults objectForKey:@"theKey"];
	
	NSDictionary *logoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	for (Poi *poi in poiArray) {
		NSData  *imgData =[logoDic objectForKey:poi.name];
		if(imgData){
			poi.logoImage = [UIImage imageWithData:imgData];
			poi.logoPresentStatus = LOGO_PRESENT;
		}
		else{
			poi.logoImage = [UIImage imageNamed:@"dummy-logo.png"];
			poi.logoPresentStatus = LOGO_NOT_PRESENT;
		}
		//poi.logo = [logoDic objectForKey:poi.poiId];
		
		/*
		if(poi.logo){
			UIImage *uiImage = [UIImage imageWithData:poi.logo];
			if( uiImage.size.height > 45 || uiImage.size.width > 56){
				uiImage = [uiImage _imageScaledToSize:CGSizeMake(56.0f, 45.0f) interpolationQuality:1];
			} 
		
			poi.logoImage = uiImage;
			poi.logoPresentStatus = LOGO_PRESENT;
		}
		else{
			poi.logoImage = [UIImage imageNamed:@"dummy-logo.png"];
			poi.logoPresentStatus = LOGO_NOT_PRESENT;
		}
		
		*/
		
	}
	
}
+(void) resetUserDefaults{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:NO_OF_LEVELS];
	[defaults removeObjectForKey:LEVEL1];
	[defaults removeObjectForKey:LEVEL2];
	[defaults removeObjectForKey:LEVEL3];
	[defaults removeObjectForKey:@"theKey"];
	[defaults removeObjectForKey:POI_LIST];
	[defaults removeObjectForKey:SEARCH_KEYWORD];
	[defaults removeObjectForKey:PAGE_NUMBER];
	[defaults removeObjectForKey:CATEGORY_ID];
	
	
	
}
+(void) persistArrayOfCustomObjects:(NSArray *) array key:(NSString * ) key{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	
	[defaults setObject:data forKey:key];
	[defaults synchronize];
	
	
}
+(NSArray *) restoreArrayOfCustomObjects:(NSString * ) key{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [defaults objectForKey:key];
	
	NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	

	return array;
	
}
@end
