//
//  CommandUtil.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoiRequestParams.h"
#import "ClientVersion.h"
#import "RivePointAppDelegate.h"

@interface CommandUtil : NSObject {
#define CLIENT_VERSION_DTO @"com.netpace.gpsframework.poc.commons.dto.ClientVersionDto"
#define EXTERNAL_COUPON @"4"
}
+(NSString *) getXMLForGeoCodeAdressCommand:(NSString *)zipCode userId:(NSString *)userId;
+(NSString *) getXMLForPoisCommand:(PoiRequestParams *)requestParams;
+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId;

+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId 
							  couponType:(NSString *)couponType;

+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId 
							  couponType:(NSString *)couponType loyaltyFlag:(BOOL)loyaltyFlag ;

+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId userId:(NSString *)userId 
						latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude;
+(NSString *) getXMLForReverseGeoCodeCommand:(NSString *)userLatitude longitude:(NSString *)userLongitude;
+(NSString *) getXMLForClientVersion:(NSString *) version userId:(NSString *) userId;
+(NSString *) getXMLForRegisterSubscriberCommand;
+(NSString *) getXMLForEmailSubscription:(NSString *)userId email:(NSString *) email;
+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId poiId:(NSString *)poiId userId:(NSString *)userId 
								latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude;
+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId poiId:(NSString *)poiId userId:(NSString *)userId 
								latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude 
							 loyaltyFlag:(BOOL)loyaltyFlag;
+(NSString *) getXMLForGetCOTDCommmand;
+(NSString *) getXMLForGetExternalPoisCommmand:(NSString *)pageNo
										poiIds:(NSString *) poiIds drvDists:(NSString *)drvDists;
+(NSString *) getXMLForSharedInboxCommmand;

+(NSString *) getXMLForSharedInboxCommmand:(BOOL)loyaltyFlag;

+(NSString *) getXMLForGetSenderSharedCouponsCommmand:(NSString *)senderId;

+(NSString *) getXMLForGetSenderSharedCouponsCommmand:(NSString *)senderId loyaltyFlag:(BOOL)isLoyalty;

+(NSString *) getXMLForRegisterFeedbackCommmand:(NSString *)feedbkType rating:(NSString *)rating 
									   couponId:(NSString *)couponId poiId:(NSString *)poiId;

+(NSString *) getXMLForShareCouponCommmand:(NSString *)rcvrEmail couponId:(NSString *)couponId 
									 poiId:(NSString *)poiId;

+(NSString *) getXMLForGetCOTDPoisCommmand:(NSString *)pageNo poiIds:(NSString *) poiIds 
								  drvDists:(NSString *)drvDists poiId:(NSString *)poiId;

+(NSString *) getXMLForDeleteAllSharedCouponsCommmand;

+(NSString *) getXMLForPoisOptCommand:(PoiRequestParams *)requestParams;

@end
