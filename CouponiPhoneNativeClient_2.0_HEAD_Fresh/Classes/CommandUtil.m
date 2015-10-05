//
//  CommandUtil.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CommandUtil.h"
#import "XMLUtil.h"
#import "PoiRequestParams.h"
#import "ClientVersion.h"
#import "DeviceUtil.h"

@implementation CommandUtil
#define ZIP_TO_GEOCODE_ADDRESS @"convertZipToGeocodeAddress"
#define ZIP_CODE_PARAMETER @"zipCode"
#define USER_ID_PARAMETER @"userId"
#define VENDOR_NAME @"Apple"
#define SHOW_POI_COUPONS @"showPoiCoupons"
#define SHOW_COUPON @"showCoupon"
#define REVERSE_GEOCODE_ADDRESS @"reverseGeocodeCommand"
#define UPGRADE_VERSION @"upgVersion"
#define REGISTER_SUBSCRIBER @"regDevice"
#define EMAIL_SUBSCRIBER @"subscribeEmail"
#define GET_COTD @"getCOTD"
#define GET_EXTERNAL_POIS @"getExtCpnPois"
#define SHARED_COUPOMN_INBOX @"shwSCpnInbx"
#define GET_SENDER_SHARED_COUPONS @"getSndrSharedCoupons"
#define REGISTER_FEEDBACK @"regCpnFeedBack"
#define SHARED_COUPON_COMMAND @"shareCoupon"
#define GET_COTD_POIS_COMMAND @"getCOTDPois"
#define DELETE_ALL_SHARED_COUPONS @"delAllSharedCoupons"
#define VENDOR_LOGO_REQUIRED @"vLogoReq"
#define POI_GROUP_SIZE_PARAMETER @"poiGrpSize"
#define POI_GROUP_SIZE_VALUE @"7"
#define LAT_LONG_REQUIRED @"latLngReqd"


#define TRUE_PARAM_VALUE @"1"

+(NSString *) getXMLForGeoCodeAdressCommand:(NSString *)zipCode userId: (NSString *)userId {
	
	NSMutableString *params = [[NSMutableString alloc] init];
	[params appendString:[XMLUtil getStringCommandParam:ZIP_CODE_PARAMETER paramValue:zipCode]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:userId]];
	
	[XMLUtil setCommonParams:params];

	
	NSString *theXML = [XMLUtil getFinalXML:ZIP_TO_GEOCODE_ADDRESS params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[params release];
	
	return encodedXML;	
	
}
+(NSString *) getXMLForPoisCommand:(PoiRequestParams *)requestParams{
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	
	if([requestParams.commandName isEqualToString:BROWSE_POI_COMMAND]){
		[params appendString:[XMLUtil getStringCommandParam:@"poiCategoryId" paramValue:requestParams.poiCategoryId ]];
	}else if([requestParams.commandName isEqualToString:SEARCH_POI_COMMAND]){
		[params appendString:[XMLUtil getStringCommandParam:@"searchKeyword" paramValue:requestParams.searchKeyword ]];
	}
	
	
	//Passing hard-coded 0 value for mobileUserDateTime as server deserializes it.
	[params appendString:[XMLUtil getStringCommandParam:@"mobileUserDateTime" paramValue:@"0" ]];
	
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"fromSequenceNumber" paramValue:requestParams.fromSequenceNumber ]];
	
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"toSequenceNumber" paramValue:requestParams.toSequenceNumber ]];
	
	
	//In Get Registered Pois command, poiTypeToFetch is not required.
	if(![requestParams.commandName isEqualToString:GET_COUPONS_COMMAND]){
		[params appendString:[XMLUtil getStringCommandParam:@"poiTypeToFetch" paramValue:requestParams.poiTypeToFetch ]];
	}
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLatitude" paramValue:requestParams.userLatitude ]];
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLongitude" paramValue:requestParams.userLongitude ]];

	[params appendString:[XMLUtil getStringCommandParam:@"radius" paramValue:requestParams.radius ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:requestParams.userID ]];
	
	[params appendString:[XMLUtil getStringCommandParam:VENDOR_LOGO_REQUIRED paramValue:TRUE_PARAM_VALUE ]];
	
	[params appendString:[XMLUtil getStringCommandParam:POI_GROUP_SIZE_PARAMETER paramValue:POI_GROUP_SIZE_VALUE ]];
	
	if(requestParams.lastRegisteredPoiGroup && [requestParams.lastRegisteredPoiGroup isEqualToString:@"true"]){
		[params appendString:[XMLUtil getStringCommandParam:@"lastRegisteredPoiGroup" paramValue:requestParams.lastRegisteredPoiGroup ]];
	}
	

	NSString *theXML = [XMLUtil getFinalXML:requestParams.commandName params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	[requestParams release];
	[params release];

	return encodedXML;	
	
	
}



+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId{
	return [self getXMLForPoiCouponsCommand:poiId userId:userId couponType:nil];
}
+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId 
							  couponType:(NSString *)couponType {
	
	return [self getXMLForPoiCouponsCommand:poiId userId:userId couponType:nil loyaltyFlag:NO];
}

+(NSString *) getXMLForPoiCouponsCommand:(NSString *)poiId userId:(NSString *)userId 
							  couponType:(NSString *)couponType loyaltyFlag:(BOOL)loyaltyFlag {
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	if(couponType)
		[params appendString:[XMLUtil getStringCommandParam:@"cpnType" paramValue:couponType ]];
	
	if(loyaltyFlag)
		[params appendString:[XMLUtil getStringCommandParam:@"loyaltyFlag" paramValue:@"1" ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"poiId" paramValue:poiId ]];
	
	
	[XMLUtil setCommonParams:params];
	
	
	//Passing hard-coded 0 value for mobileUserDateTime as server deserializes it.
	[params appendString:[XMLUtil getStringCommandParam:@"mobileUserDateTime" paramValue:@"0" ]];
	
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:userId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:SHOW_POI_COUPONS params:params];
	
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;
	

}

+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId userId:(NSString *)userId 
								latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude{
	
	NSMutableString *params = [[NSMutableString alloc] init];
	[params appendString:[XMLUtil getStringCommandParam:@"couponId" paramValue:couponId ]];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLatitude" paramValue:userLatitude ]];

	[params appendString:[XMLUtil getStringCommandParam:@"userLongitude" paramValue:userLongitude ]];

	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:userId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:SHOW_COUPON params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
	
}
+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId poiId:(NSString *)poiId userId:(NSString *)userId 
								latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude {
	
	return [self getXMLForShowCouponCommand:couponId poiId:poiId userId:userId latitude:userLatitude longitude:userLongitude loyaltyFlag:NO];
}
+(NSString *) getXMLForShowCouponCommand:(NSString *)couponId poiId:(NSString *)poiId userId:(NSString *)userId 
								latitude:(NSString *)userLatitude longitude:(NSString *)userLongitude 
								loyaltyFlag:(BOOL)loyaltyFlag {
	
	NSMutableString *params = [[NSMutableString alloc] init];
	[params appendString:[XMLUtil getStringCommandParam:@"couponId" paramValue:couponId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"poiId" paramValue:poiId ]];
	
	[XMLUtil setCommonParams:params];
	
	if(loyaltyFlag)
		[params appendString:[XMLUtil getStringCommandParam:@"loyaltyFlag" paramValue:@"1" ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLatitude" paramValue:userLatitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLongitude" paramValue:userLongitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:userId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:SHOW_COUPON params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
	
}

+(NSString *) getXMLForReverseGeoCodeCommand:(NSString *)userLatitude longitude:(NSString *)userLongitude{
	
	NSMutableString *params = [[NSMutableString alloc] init];	
	
	[params appendString:[XMLUtil getStringCommandParam:@"lat" paramValue:userLatitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"lon" paramValue:userLongitude ]];
	
	[XMLUtil setCommonParams:params];

	NSString *theXML = [XMLUtil getFinalXML:REVERSE_GEOCODE_ADDRESS params:params];

	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[params release];
	return encodedXML;
	
}
+(NSString *) getXMLForClientVersion:(NSString *) version userId:(NSString *) userId{
	
	NSString *param = [XMLUtil getClientVersionDtoXML:userId version:version 
							 vendor:VENDOR_NAME clientType:IPHONE_NATIVE_PLATFORM];
	NSString *theXML = [XMLUtil getFinalXML:REVERSE_GEOCODE_ADDRESS params:param];
	
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	return encodedXML;
}
+(NSString *) getXMLForRegisterSubscriberCommand{
	
	NSMutableString *params = [[NSMutableString alloc] init];	
	
	[params appendString:[XMLUtil getStringCommandParam:@"deviceId" paramValue:[DeviceUtil getDeviceId] ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"clientType" paramValue:IPHONE_NATIVE_PLATFORM ]];
	
	[XMLUtil setCommonParams:params];
	
	NSString *theXML = [XMLUtil getFinalXML:REGISTER_SUBSCRIBER params:params];
	
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[params release];
	return encodedXML;
	
}
+(NSString *) getXMLForEmailSubscription:(NSString *)userId email:(NSString *) email{
	
	NSString *param = [XMLUtil getDtoEmailSubscriptionXML:userId email:email];
	NSString *theXML = [XMLUtil getFinalXML:EMAIL_SUBSCRIBER params:param];
	
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	return encodedXML;
}
+(NSString *) getXMLForGetCOTDCommmand{
	
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"latitude" paramValue:appDelegate.setting.latitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"longitude" paramValue:appDelegate.setting.longitute ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:GET_COTD params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}
+(NSString *) getXMLForGetExternalPoisCommmand:(NSString *)pageNo
									  	poiIds:(NSString *) poiIds drvDists:(NSString *)drvDists
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[params appendString:[XMLUtil getStringCommandParam:@"pageNo" paramValue:pageNo ]];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"latitude" paramValue:appDelegate.setting.latitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"longitude" paramValue:appDelegate.setting.longitute ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	if(poiIds)
		[params appendString:[XMLUtil getStringCommandParam:@"poiIds" paramValue:poiIds ]];
	if(drvDists)
		[params appendString:[XMLUtil getStringCommandParam:@"drvDists" paramValue:drvDists ]];
	
	[params appendString:[XMLUtil getStringCommandParam:VENDOR_LOGO_REQUIRED paramValue:TRUE_PARAM_VALUE ]];
	
	[params appendString:[XMLUtil getStringCommandParam:POI_GROUP_SIZE_PARAMETER paramValue:POI_GROUP_SIZE_VALUE ]];
	
	NSString *theXML = [XMLUtil getFinalXML:GET_EXTERNAL_POIS params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}

+(NSString *) getXMLForSharedInboxCommmand
{
	/*RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	//[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	[params appendString:[XMLUtil getDtoCommandParam:@"sharedCoupon" javaObjectType:@"SharedCouponDto" 
										   objectDto:[XMLUtil getParamSharedCouponDto:appDelegate.setting.subsId]]];
	[XMLUtil setCommonParams:params];
	
	NSString *theXML = [XMLUtil getFinalXML:SHARED_COUPOMN_INBOX params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"XML: %@" , theXML);
	//[theXML release];
	
	[params release];
	return encodedXML;	*/
    return [self getXMLForSharedInboxCommmand:NO];
}

+(NSString *) getXMLForSharedInboxCommmand:(BOOL)loyaltyFlag
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	//[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	[params appendString:[XMLUtil getDtoCommandParam:@"sharedCoupon" javaObjectType:@"SharedCouponDto" 
										   objectDto:[XMLUtil getParamSharedCouponDto:appDelegate.setting.subsId]]];
    
    if(loyaltyFlag)
		[params appendString:[XMLUtil getStringCommandParam:@"loyaltyFlag" paramValue:@"1" ]];
    
	[XMLUtil setCommonParams:params];
	
	NSString *theXML = [XMLUtil getFinalXML:SHARED_COUPOMN_INBOX params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}

+(NSString *) getXMLForGetSenderSharedCouponsCommmand:(NSString *)senderId loyaltyFlag:(BOOL)isLoyalty{
    RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
    
	[XMLUtil setCommonParams:params];
    
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"sndrId" paramValue:senderId ]];
    
	if(isLoyalty)
    [params appendString:[XMLUtil getStringCommandParam:@"loyaltyFlag" paramValue:@"1" ]];
    
	NSString *theXML = [XMLUtil getFinalXML:GET_SENDER_SHARED_COUPONS params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}

+(NSString *) getXMLForGetSenderSharedCouponsCommmand:(NSString *)senderId
{
	/*RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
		
	[XMLUtil setCommonParams:params];
		
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"sndrId" paramValue:senderId ]];
	

	NSString *theXML = [XMLUtil getFinalXML:GET_SENDER_SHARED_COUPONS params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"XML: %@" , theXML);
	//[theXML release];
	
	[params release];
	return encodedXML;	*/
    
    return [self getXMLForGetSenderSharedCouponsCommmand:senderId loyaltyFlag:NO];
}
+(NSString *) getXMLForRegisterFeedbackCommmand:(NSString *)feedbkType rating:(NSString *)rating 
									   couponId:(NSString *)couponId poiId:(NSString *)poiId
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"feedbkType" paramValue:feedbkType ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"rating" paramValue:rating ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"couponId" paramValue:couponId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"poiId" paramValue:poiId ]];
	
	
	
	NSString *theXML = [XMLUtil getFinalXML:REGISTER_FEEDBACK params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}
+(NSString *) getXMLForShareCouponCommmand:(NSString *)rcvrEmail couponId:(NSString *)couponId 
									 poiId:(NSString *)poiId
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"rcvrEmail" paramValue:rcvrEmail ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"couponId" paramValue:couponId ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"poiId" paramValue:poiId ]];
	
	
	
	NSString *theXML = [XMLUtil getFinalXML:SHARED_COUPON_COMMAND params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}
+(NSString *) getXMLForGetCOTDPoisCommmand:(NSString *)pageNo poiIds:(NSString *) poiIds 
								  drvDists:(NSString *)drvDists poiId:(NSString *)poiId
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[params appendString:[XMLUtil getStringCommandParam:@"pageNo" paramValue:pageNo ]];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:@"latitude" paramValue:appDelegate.setting.latitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"longitude" paramValue:appDelegate.setting.longitute ]];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	if(poiIds)
		[params appendString:[XMLUtil getStringCommandParam:@"poiIds" paramValue:poiIds ]];
	if(drvDists)
		[params appendString:[XMLUtil getStringCommandParam:@"drvDists" paramValue:drvDists ]];
	if(poiId)
		[params appendString:[XMLUtil getStringCommandParam:@"poiId" paramValue:poiId ]];
	
	//[params appendString:[XMLUtil getStringCommandParam:VENDOR_LOGO_REQUIRED paramValue:TRUE_PARAM_VALUE ]];
	
	[params appendString:[XMLUtil getStringCommandParam:POI_GROUP_SIZE_PARAMETER paramValue:POI_GROUP_SIZE_VALUE ]];
	
	NSString *theXML = [XMLUtil getFinalXML:GET_COTD_POIS_COMMAND params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	
	[params release];
	return encodedXML;	
}
+(NSString *) getXMLForDeleteAllSharedCouponsCommmand
{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:DELETE_ALL_SHARED_COUPONS params:params];
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	[params release];
	return encodedXML;	
}

+(NSString *) getXMLForPoisOptCommand:(PoiRequestParams *)requestParams{
	
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableString *params = [[NSMutableString alloc] init];
	
	[XMLUtil setCommonParams:params];
	
	
	if([requestParams.commandName isEqualToString:BROWSE_POI_OPT_COMMAND]){
		[params appendString:[XMLUtil getStringCommandParam:@"poiCategoryId" paramValue:requestParams.poiCategoryId ]];
	}else if([requestParams.commandName isEqualToString:SEARCH_POI_OPT_COMMAND]){
		[params appendString:[XMLUtil getStringCommandParam:@"searchKeyword" paramValue:requestParams.searchKeyword ]];
	}
	
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLatitude" paramValue:appDelegate.setting.latitude ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"userLongitude" paramValue:appDelegate.setting.longitute ]];
	
	[params appendString:[XMLUtil getStringCommandParam:@"pageNo" paramValue:@"1" ]];
	
	[params appendString:[XMLUtil getStringCommandParam:LAT_LONG_REQUIRED paramValue:TRUE_PARAM_VALUE ]];
	
	
	[params appendString:[XMLUtil getStringCommandParam:USER_ID_PARAMETER paramValue:appDelegate.setting.subsId ]];
	
	NSString *theXML = [XMLUtil getFinalXML:requestParams.commandName params:params];
    
//    NSLog(@"%@",theXML);
    
	NSString *encodedXML = [NSString stringWithString:[theXML stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//[theXML release];
	[requestParams release];
	[params release];
	
	return encodedXML;	
	
	
}
@end
