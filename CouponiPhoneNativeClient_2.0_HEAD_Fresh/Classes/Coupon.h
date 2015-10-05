//
//  Coupon.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@interface Coupon : NSObject {
	int pk;
	NSString *couponId;
	NSString *poiId;
	NSString *title;
	NSString *subTitleLineOne;
	NSString *subTitleLineTwo;
	NSString *couponUniqueCode;
	NSString *validFrom;
	NSString *validTo;
	NSString *vendorLogoImageName;
	NSString *vendorLogoImageBytes;
	NSString *couponImageName;
	NSString *couponImageBytes;
	NSString *couponType;
	NSString *isRestrictedCoupon;
	NSString *perUserRedemption;
	NSString *userRedemptionCount;
	NSString *isAvailable;
	NSString *isCOTD;
	NSString *rating;
	NSString *feedbkType;
    NSString *earningPoints;
    NSString *reqdPoints;
	NSData *couponImagePreview;
    NSString * urlToShare;
	
	UIImage *previewImage;
	Poi *poi;
}

@property int pk;
@property (nonatomic,retain) NSString *couponId;
@property (nonatomic,retain) NSString *poiId;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *subTitleLineOne;
@property (nonatomic,retain) NSString *subTitleLineTwo;
@property (nonatomic,retain) NSString *couponUniqueCode;
@property (nonatomic,retain) NSString *validFrom;
@property (nonatomic,retain) NSString *validTo;
@property (nonatomic,retain) NSString *vendorLogoImageName;
@property (nonatomic,retain) NSString *vendorLogoImageBytes;
@property (nonatomic,retain) NSString *couponImageName;
@property (nonatomic,retain) NSString *couponImageBytes;
@property (nonatomic,retain) NSString *couponType;
@property (nonatomic,retain) NSString *isRestrictedCoupon;
@property (nonatomic,retain) NSString *perUserRedemption;
@property (nonatomic,retain) NSString *userRedemptionCount;
@property (nonatomic,retain) NSString *isAvailable;
@property (nonatomic,retain) NSString *isCOTD;
@property (nonatomic,retain) NSString *rating;
@property (nonatomic,retain) NSString *feedbkType;
@property (nonatomic,retain) NSString *earningPoints;
@property (nonatomic,retain) NSString *reqdPoints;
@property (nonatomic,retain) NSString *urlToShare;
@property (nonatomic , retain) NSString * emailSharedVia;
@property (nonatomic , retain) NSString * shareID;

@property (nonatomic, copy) NSData *couponImagePreview;
@property (nonatomic,retain) UIImage *previewImage;
@property (nonatomic, retain) Poi *poi;


@end
