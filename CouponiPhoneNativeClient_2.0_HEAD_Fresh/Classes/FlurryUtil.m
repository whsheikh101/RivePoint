//
//  FlurryUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/17/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "FlurryUtil.h"


@implementation FlurryUtil
/*
+ (NSString *) getFlurryAppID{
	NSBundle * thisBundle = [NSBundle bundleForClass:[FlurryUtil class]];
	NSString *flurryFileName = @"flurry";
	NSString *flurryPathString = [thisBundle pathForResource:flurryFileName	ofType:@"txt"];
	NSString *flurryAppID = [[NSString alloc] initWithContentsOfFile:flurryPathString];
	
	return [flurryAppID autorelease];
}


+ (void) logSearchPOIS:(NSString *)keyword zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							keyword,@"Keyword",
							zipCode,@"ZIP Code",
							nil
						 ];

	[FlurryAPI logEvent:SEARCH_COUPONS_EVENT withParameters:dic timed:YES];
}

+ (void) logBrowsePOIS:(NSString *)categoryId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							categoryId,@"Category Id",
							zipCode,@"ZIP Code",
							nil
						 ];
	
	[FlurryAPI logEvent:BROWSE_COUPONS_EVENT withParameters:dic timed:YES];
		
}
+ (void) logGetCoupons:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							zipCode,@"ZIP Code",
							nil
						 ];
	
	[FlurryAPI logEvent:GET_COUPONS_EVENT withParameters:dic timed:YES];
	
}

+ (void) logCOTD:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:COTD_EVENT withParameters:dic timed:YES];
	
}

+ (void) logExternalCoupons:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:EXTERNAL_COUPON_EVENT withParameters:dic];
	
}
+ (void) logRedeemCoupons:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:REDEEM_COUPON_EVENT withParameters:dic timed:YES];
	
}
+ (void) logShareCouponToFriend:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:SHARE_COUPON_TO_FRIEND_EVENT withParameters:dic timed:YES];
	
}
+ (void) logRateCoupon:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:RATE_COUPON_EVENT withParameters:dic timed:YES];
}
+ (void) logReportBroken:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:REPORT_BROKEN_EVENT withParameters:dic timed:YES];
}
+ (void) logSavingCoupon:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:SAVING_COUPON_EVENT withParameters:dic];
}
+ (void) logSavedCoupon:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:SAVED_COUPONS_EVENT withParameters:dic];
}
+ (void) logSettings:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:SETTINGS_EVENT withParameters:dic timed:YES];
}
+ (void) logDeleteAllShared:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:DELETE_ALL_SHARED_EVENT withParameters:dic];
}
+ (void) logDeleteAllSaved:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 nil
						 ];
	
	[FlurryAPI logEvent:DELETE_ALL_SAVED_EVENT withParameters:dic];
}
*/
/***********************************Service Not Available Methods**********************************/
/*
+ (void) logSearchPOISError:(NSString *)keyword zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							keyword,@"Keyword",
							zipCode,@"ZIP Code",
							SEARCH_COUPONS_EVENT,@"Command",
							nil
						 ];
	
	[FlurryAPI endTimedEvent:SEARCH_COUPONS_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}

+ (void) logBrowsePOISError:(NSString *)categoryId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							categoryId,@"Category Id",
							zipCode,@"ZIP Code",
							BROWSE_COUPONS_EVENT,@"Command",
							nil
						 ];
	
	[FlurryAPI endTimedEvent:BROWSE_COUPONS_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}
+ (void) logGetCouponsError:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
							zipCode,@"ZIP Code",
							GET_COUPONS_EVENT,@"Command",
							nil
						 ];
	[FlurryAPI endTimedEvent:GET_COUPONS_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}
+ (void) logCOTDError:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 COTD_EVENT,@"Command",
						 nil
						 ];
	[FlurryAPI endTimedEvent:COTD_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}
+ (void) logExternalCouponError:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 EXTERNAL_COUPON_EVENT,@"Command",
						 nil
						 ];
	
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}
+ (void) logRedeemCouponError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 couponId,@"Coupon Id",
						 poiId, @"POI Id",
						 REDEEM_COUPON_EVENT,@"Command",
						 nil
						 ];
	[FlurryAPI endTimedEvent:REDEEM_COUPON_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}
+ (void) logShareCouponToFriendError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 couponId,@"Coupon Id",
						 poiId, @"POI Id",
						 REDEEM_COUPON_EVENT,@"Command",
						 nil
						 ];
	[FlurryAPI endTimedEvent:SHARE_COUPON_TO_FRIEND_EVENT];
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
	
}

+ (void) logRateCouponError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	[FlurryAPI endTimedEvent:RATE_COUPON_EVENT];
	[FlurryAPI logEvent:RATE_COUPON_EVENT withParameters:dic];
}
+ (void) logReportBrokenError:(NSString *)couponId poiId:(NSString *)poiId zipCode:(NSString *)zipCode{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 couponId,@"Coupon Id",
						 poiId,@"POI Id",
						 zipCode,@"ZIP Code",
						 nil
						 ];
	[FlurryAPI endTimedEvent:REPORT_BROKEN_EVENT];
	[FlurryAPI logEvent:REPORT_BROKEN_EVENT withParameters:dic];
}
+ (void) logSettingsError:(NSString *)zipCode{
	[FlurryAPI endTimedEvent:SETTINGS_EVENT];
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 zipCode,@"ZIP Code",
						 SETTINGS_EVENT,@"Command",
						 nil
						 ];
	
	[FlurryAPI logEvent:SERVICE_NOT_AVAILABLE withParameters:dic];
}
*/
@end
