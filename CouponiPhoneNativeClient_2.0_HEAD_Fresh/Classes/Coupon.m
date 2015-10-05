//
//  Coupon.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "Coupon.h"
#import "GeneralUtil.h"

@implementation Coupon

@synthesize pk;
@synthesize couponId;
@synthesize poiId;
@synthesize title;
@synthesize subTitleLineOne;
@synthesize subTitleLineTwo;
@synthesize couponUniqueCode;
@synthesize validFrom;
@synthesize validTo;
@synthesize vendorLogoImageName;
@synthesize vendorLogoImageBytes;
@synthesize couponImageName;
@synthesize couponImageBytes;
@synthesize couponType;
@synthesize isRestrictedCoupon;
@synthesize perUserRedemption;
@synthesize userRedemptionCount;
@synthesize isAvailable;
@synthesize isCOTD;
@synthesize rating;
@synthesize feedbkType;
@synthesize couponImagePreview;
@synthesize poi;
@synthesize previewImage;
@synthesize earningPoints;
@synthesize reqdPoints;
@synthesize urlToShare;
@synthesize emailSharedVia;
@synthesize shareID;

+(Coupon*) getTestCoupon {
	
	Coupon *c = [[Coupon alloc]init];
	c.couponId= @"00" ;
	c.poiId=@"11" ;
	c.title = @"Title" ;
	c.subTitleLineOne = @"subTitleLineOne" ;
	c.subTitleLineTwo = @"subTitleLineTwo" ;
	c.couponUniqueCode = @"22" ;
	c.validFrom = @"2009-01-01" ;
	c.validTo = @"2009-12-31" ;
	c.vendorLogoImageName = @"vendorLogoImageName" ;
	c.couponImageName = @"couponImageName" ;
	c.couponType = @"couponType" ;
	c.isRestrictedCoupon = @"Yes" ;
	c.perUserRedemption = @"perUserRedemption" ;
	c.userRedemptionCount = @"userRedemptionCount" ;
	c.isAvailable = @"NO" ;
    c.urlToShare = @"http://www.rivepoint.com/coupon/get/shared/021c7480b259faaa3ca106b7ebe95108";
	
	return c ;
}

- (void) dealloc
{
	 [couponId release];
	 [poiId release];
	 [title release];
	 [subTitleLineOne release];
	 [subTitleLineTwo release];
	 [couponUniqueCode release];
	 [validFrom release];
	 [validTo release];
	 [vendorLogoImageName release];
	 [vendorLogoImageBytes release];
	 [couponImageName release];
	 [couponImageBytes release];
	 [couponType release];
	 [isRestrictedCoupon release];
	 [perUserRedemption release];
	 [userRedemptionCount release];
	 [isAvailable release];
	 [isCOTD release];
	 [rating release];
	 [feedbkType release];
	 [couponImagePreview release];
	 [poi release];
	 [previewImage release];
     [earningPoints release];
     [reqdPoints release];
     [urlToShare release];
     [shareID release];
	 [super dealloc];
}
-(void)encodeWithCoder:(NSCoder *)encoder
{
	
	/*NSString *couponId;
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
	NSData *couponImagePreview;
	
	UIImage *previewImage;
	Poi *poi;*/
	[GeneralUtil setStringToCoder:couponId key:@"couponId" coder:encoder];
	[GeneralUtil setStringToCoder:poiId key:@"poiId" coder:encoder];
	[GeneralUtil setStringToCoder:title key:@"title" coder:encoder];	
	[GeneralUtil setStringToCoder:subTitleLineOne key:@"subTitleLineOne" coder:encoder];
	[GeneralUtil setStringToCoder:subTitleLineTwo key:@"subTitleLineTwo" coder:encoder];
	[GeneralUtil setStringToCoder:couponUniqueCode key:@"couponUniqueCode" coder:encoder];
	[GeneralUtil setStringToCoder:validFrom key:@"validFrom" coder:encoder];
	[GeneralUtil setStringToCoder:validTo key:@"validTo" coder:encoder];
	[GeneralUtil setStringToCoder:vendorLogoImageName key:@"vendorLogoImageName" coder:encoder];
	[GeneralUtil setStringToCoder:vendorLogoImageBytes key:@"vendorLogoImageBytes" coder:encoder];
	[GeneralUtil setStringToCoder:couponImageName key:@"couponImageName" coder:encoder];
	[GeneralUtil setStringToCoder:couponImageBytes key:@"couponImageBytes" coder:encoder];
	[GeneralUtil setStringToCoder:couponType key:@"couponType" coder:encoder];
	[GeneralUtil setStringToCoder:isRestrictedCoupon key:@"isRestrictedCoupon" coder:encoder];
	[GeneralUtil setStringToCoder:perUserRedemption key:@"perUserRedemption" coder:encoder];
	[GeneralUtil setStringToCoder:isAvailable key:@"isAvailable" coder:encoder];
	[GeneralUtil setStringToCoder:isCOTD key:@"isCOTD" coder:encoder];
	[GeneralUtil setStringToCoder:rating key:@"rating" coder:encoder];
	[GeneralUtil setStringToCoder:feedbkType key:@"feedbkType" coder:encoder];
    [GeneralUtil setStringToCoder:feedbkType key:@"earningPoints" coder:encoder];
    [GeneralUtil setStringToCoder:feedbkType key:@"reqdPoints" coder:encoder];
	[GeneralUtil setDataToCoder:couponImagePreview key:@"couponImagePreview" coder:encoder];
	[GeneralUtil setImageToCoder:previewImage key:@"previewImage" coder:encoder];
    [GeneralUtil setStringToCoder:urlToShare key:@"CouponShareUrl" coder:encoder];

}


-(id)initWithCoder:(NSCoder *)decoder
{
	if (self=[super init]){
		self.couponId = [decoder decodeObjectForKey:@"couponId"];
		self.poiId = [decoder decodeObjectForKey:@"poiId"];
		self.title = [decoder decodeObjectForKey:@"title"];
		self.subTitleLineOne = [decoder decodeObjectForKey:@"subTitleLineOne"];
		self.subTitleLineTwo = [decoder decodeObjectForKey:@"subTitleLineTwo"];
		self.couponUniqueCode = [decoder decodeObjectForKey:@"couponUniqueCode"];
		self.validFrom = [decoder decodeObjectForKey:@"validFrom"];
		self.validTo = [decoder decodeObjectForKey:@"validTo"];
		self.vendorLogoImageName = [decoder decodeObjectForKey:@"vendorLogoImageName"];
		self.vendorLogoImageBytes = [decoder decodeObjectForKey:@"vendorLogoImageBytes"];
		self.couponImageName = [decoder decodeObjectForKey:@"couponImageName"];
		self.couponImageBytes = [decoder decodeObjectForKey:@"couponImageBytes"];
		self.couponType = [decoder decodeObjectForKey:@"couponType"];
		self.isRestrictedCoupon = [decoder decodeObjectForKey:@"isRestrictedCoupon"];
		self.perUserRedemption = [decoder decodeObjectForKey:@"perUserRedemption"];
		self.isAvailable = [decoder decodeObjectForKey:@"isAvailable"];
		self.isCOTD = [decoder decodeObjectForKey:@"isCOTD"];
		self.rating = [decoder decodeObjectForKey:@"rating"];
		self.feedbkType = [decoder decodeObjectForKey:@"feedbkType"];
        self.earningPoints = [decoder decodeObjectForKey:@"earningPoints"];
        self.reqdPoints = [decoder decodeObjectForKey:@"reqdPoints"];
		self.couponImagePreview = [decoder decodeObjectForKey:@"couponImagePreview"];
        self.urlToShare = [decoder decodeObjectForKey:@"CouponShareUrl"];
	}
	return self;
}



@end
