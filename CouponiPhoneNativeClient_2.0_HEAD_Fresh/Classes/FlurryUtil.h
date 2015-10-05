//
//  FlurryUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/17/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FlurryAPI.h"

@interface FlurryUtil : NSObject {
	#define GET_COUPONS_EVENT @"Get Coupons"
	#define SEARCH_COUPONS_EVENT @"Search Coupons"
	#define BROWSE_COUPONS_EVENT @"Browse Coupons"
	#define COTD_EVENT @"Coupon of the day"
	#define LOGIN_EVENT @"Login"
	#define EXTERNAL_COUPON_EVENT @"External Coupons"
	#define SHARED_COUPON_EVENT @"Shared Coupons"
	#define REDEEM_COUPON_EVENT @"Redeem Coupon"
	#define SHARE_COUPON_TO_FRIEND_EVENT @"Share Coupon to Friend"
	#define RATE_COUPON_EVENT @"Rate Coupon"
	#define REPORT_BROKEN_EVENT @"Report Broken"
	#define SAVING_COUPON_EVENT @"Saving Coupon"
	#define SAVED_COUPONS_EVENT @"Saved Coupon"
	#define SETTINGS_EVENT @"ZIP Code Settings"
	#define DELETE_ALL_SHARED_EVENT @"Delete All Shared"
	#define DELETE_ALL_SAVED_EVENT @"Delete All Saved"
	
	#define SERVICE_NOT_AVAILABLE @"Service Not Avaliable!"
	
}

+ (NSString *) getFlurryAppID;

+ (void) logSearchPOIS:(NSString *)keyword zipCode:(NSString *)zipCode;
+ (void) logBrowsePOIS:(NSString *)categoryId zipCode:(NSString *)zipCode;
+ (void) logGetCoupons:(NSString *)zipCode;
+ (void) logCOTD:(NSString *)zipCode;
+ (void) logExternalCoupons:(NSString *)zipCode;
+ (void) logRedeemCoupons:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logShareCouponToFriend:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logRateCoupon:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logReportBroken:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logSavingCoupon:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logSavedCoupon:(NSString *)zipCode;
+ (void) logSettings:(NSString *)zipCode;
+ (void) logDeleteAllShared:(NSString *)zipCode;
+ (void) logDeleteAllSaved:(NSString *)zipCode;


+ (void) logSearchPOISError:(NSString *)keyword zipCode:(NSString *)zipCode;
+ (void) logBrowsePOISError:(NSString *)categoryId zipCode:(NSString *)zipCode;
+ (void) logGetCouponsError:(NSString *)zipCode;
+ (void) logCOTDError:(NSString *)zipCode;
+ (void) logExternalCouponError:(NSString *)zipCode;
+ (void) logRedeemCouponError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logShareCouponToFriendError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logRateCouponError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logReportBrokenError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode;
+ (void) logSettingsError:(NSString *)zipCode;

@end
