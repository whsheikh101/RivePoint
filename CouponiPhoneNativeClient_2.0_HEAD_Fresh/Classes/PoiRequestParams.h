//
//  PoiRequestParams.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PoiRequestParams : NSObject {
#define BROWSE_POI_COMMAND @"showPoiCategoryDetail"
#define SEARCH_POI_COMMAND @"searchPois"
#define GET_COUPONS_COMMAND @"searchRegisteredPois"
	
#define BROWSE_POI_OPT_COMMAND @"browsePoisOpt"
#define SEARCH_POI_OPT_COMMAND @"searchPoisOpt"
#define GET_COUPONS_OPT_COMMAND @"getCpnOpt"
#define GET_LOYALTY_POIS_COMMAND @"getLoyaltyPOIS"
	
	
	
	NSString *commandName;
	NSString *searchKeyword;
	NSString *poiCategoryId;
	NSString *fromSequenceNumber;
	NSString *toSequenceNumber;
	NSString *poiTypeToFetch;
	NSString *userLatitude;
	NSString *userLongitude;
	NSString *radius;
	NSString *userID;
	NSString *lastRegisteredPoiGroup;
}

@property (nonatomic,retain) NSString *commandName;
@property (nonatomic,retain) NSString *searchKeyword;
@property (nonatomic,retain) NSString *poiCategoryId;
@property (nonatomic,retain) NSString *fromSequenceNumber;
@property (nonatomic,retain) NSString *toSequenceNumber;
@property (nonatomic,retain) NSString *poiTypeToFetch;
@property (nonatomic,retain) NSString *userLatitude;
@property (nonatomic,retain) NSString *userLongitude;
@property (nonatomic,retain) NSString *radius;
@property (nonatomic,retain) NSString *userID;
@property (nonatomic,retain) NSString *lastRegisteredPoiGroup;



@end

