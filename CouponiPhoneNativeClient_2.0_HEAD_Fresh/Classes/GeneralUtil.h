//
//  GeneralUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"
#import "RivePointAppDelegate.h"

@interface GeneralUtil : NSObject {

}
+ (void) setRivepointLogo:(UINavigationItem *)item;
+ (UISegmentedControl *) setSegmentedContol:(UINavigationItem *)item;
+ (Poi *)getPoi;
+ (void)setRightBarButton: (int)i controllerReference:(UIViewController *) controllerReference;
+ (void)mapClick:(Poi *)poi controllerReference:(UIViewController *) controllerReference;
+ (void)phoneClick:(Poi *)poi controllerReference:(UIViewController *) controllerReference;
+ (NSString *)getLongFormatDate: (NSString *) inputDateString;
+ (NSData *)getVendorSmallLogo:(NSString *)poiId;
+ (void)fillWithVendorSmallLogo:(NSArray *)poiList;
+(void)fillWithSameVendorLogo:(NSArray *)poiList;
+ (NSString *)truncateDecimal:(NSString *) str;
+ (UIImage *)scaleImage:(UIImage *)image width:(int)width height:(int)height;

+ (void) setStringToCoder:(NSString *)str key:(NSString *)key coder:(NSCoder *)encoder;
+ (void) setDataToCoder:(NSData *)data key:(NSString *)key coder:(NSCoder *)encoder;
+ (void) setImageToCoder:(UIImage *)img key:(NSString *)key coder:(NSCoder *)encoder;

+(NSString *) updateZipFromPOIList:(NSArray *) array;
+(void) setActivityIndicatorView:(UINavigationItem *) navItem;
+ (NSData *)getCouponPreviewImage:(NSString *)couponId;
+(void)setBigLogo:(UIImageView *)bigLogoImageView poiId:(NSString *) poiId;

@end
