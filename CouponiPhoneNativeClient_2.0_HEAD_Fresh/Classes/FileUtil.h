//
//  FileUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/29/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtil : NSObject {

}
+ (BOOL)writeApplicationData:(NSString *)data toFile:(NSString *)fileName;
+ (NSString *)applicationDataFromFile:(NSString *)fileName;

+ (BOOL)persistGetCouponPOIS:(NSString *)data;
+ (NSString *)readPersistantGetCouponPOIS;


+ (BOOL)persistCouponList:(NSString *)data;
+ (NSString *)readPersistantCouponList;


+ (void) setStringToNSUserDefaults:(NSString *)data key:(NSString *)key;
+ (NSString *) getStringFromNSUserDefaultsPerfs:(NSString *)key;

+(void) setIntegerToNSUserDefaults:(int)data key:(NSString *)key;
+(int) getIntegerFromNSUserDefaultsPerfs:(NSString *)key;

+(void) setObjectToNSUserDefaults:(NSData *)data key:(NSString *)key;
+(NSData *) getObjectFromNSUserDefaults:(NSString *)key;

+(void) persistPoiLogos:(NSArray *) poiArray;
+(void) setPoiLogos:(NSArray *) poiArray;

+(void) resetUserDefaults;

+(void) persistArrayOfCustomObjects:(NSArray *) array key:(NSString * ) key;
+(NSArray *) restoreArrayOfCustomObjects:(NSString * ) key;

@end
