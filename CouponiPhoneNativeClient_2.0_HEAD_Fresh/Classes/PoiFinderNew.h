//
//  PoiFinderNew.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/1/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoiXMLParser.h"
#import "HttpTransportAdaptor.h"
#import "RivePointAppDelegate.h"
#import "PoiDtoGroup.h"
#import "CommandUtil.h"
#import "HTTPSupport.h"
#import "Base64.h"
#import "MainViewController.h"
#import "PoiDtoGroup.h"
#import "RivePointAppDelegate.h"
#import "XMLParser.h"
#import "CommandParam.h"

@interface PoiFinderNew : NSObject <HTTPSupport> {
	#define FETCH_FIRST 0
	#define FETCH_NEXT 1
	#define FETCH_PREVIOUS 2
	#define FETCH_CURRENT 3
	
	#define BROWSE 0
	#define SEARCH 1
	#define GET_COUPONS 2
	#define COTD_OTHER_POIS 3
	#define EXTERNAL_COUPON_POIS 4
	#define COTD_POIS 6
	#define GET_LOYALTY_POIS 8
	
	#define POI_SPLIT_SYMBOL  @"~^~"
	#define POI_PROPERTY_VALUES_SPLIT_SYMBOL @"[~]"
	#define POI_ADDRESS_COMPONENT_SPLIT_SYMBOL  @";"
	
	#define DEFAULT_PAGE_SIZE 7
	
	#define PAGE_NUMBER  @"PageNumber"
	
	
	NSString *poiIds;
	NSString *drvDists;
	int poiFindType;
	int pageNumber;
	NSString *exculdePoiId;
	HttpTransportAdaptor *adaptor;
	RivePointAppDelegate *appDelegate;
	int fType;
	NSObject *caller;
	NSString *searchKeyword; 
	NSString *suggestedKeywords;
	NSString *categoryId;
	NSArray *poiStringsArray;
	PoiDtoGroup *poiDtoGroup;
	NSString *poiStringsParamValue;
	BOOL isLoaded;
	BOOL dontDisplay;
	BOOL fromPersistantState;
	

}

@property (nonatomic,retain) NSString *poiStringsParamValue;
@property (nonatomic,retain) NSString *suggestedKeywords;
@property (nonatomic,retain) NSString *exculdePoiId;
@property (nonatomic,retain) NSString *poiIds;
@property (nonatomic,retain) NSString *drvDists;
@property (nonatomic,retain) NSString *searchKeyword;
@property (nonatomic,retain) NSString *categoryId;
@property (nonatomic,retain) NSArray *poiStringsArray;
@property (nonatomic,retain) PoiDtoGroup *poiDtoGroup;


@property BOOL dontDisplay;
@property BOOL isLoaded;
@property BOOL fromPersistantState;
@property int poiFindType;
@property int pageNumber;
@property int fType;


-(void) getExternalCouponPois: (int)fetchType caller:(NSObject *) referenceToCaller;
-(void) getOtherPois: (int)fetchType caller:(NSObject *) referenceToCaller poiFindType:(int)type;
-(void) getCOTDPois: (int)fetchType caller:(NSObject *) referenceToCaller;
-(void) loadValueThroughString:(NSString *) poiStringsVal commandName:(NSString *)commandName caller:(NSObject *) referenceToCaller;

-(void) searchPois:(int)fetchType keyword:(NSString *)keyword caller:(NSObject *)callerObject;

-(void) browsePois:(int)fetchType categoryId:(NSString *)browseCategoryId  caller:(NSObject *)callerObject;

-(void) getPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject;

-(void) getLoyaltyPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject;

-(void) execute;

-(void)cancelRequest;

-(void) processHttpResponse:(NSData *) response;

-(void) callTheCaller:(PoiDtoGroup *)poiDtoGroupForCaller;

-(NSArray *) split:(NSString *)str seperator:(NSString *)seperator;

-(void) executeOpt:(int)poiFindType;

-(BOOL) isEmptyParamPresent:(NSData *)response;

-(NSString *) getResultParam:(NSData *)response;


-(void) setPoiStringArray:(NSString *) poiStrings;

-(PoiDtoGroup *) getPoiGroup;

-(int) calculatePageStartIndex;

-(int) calculatePageNumber:(int) startIndex;

-(Poi *) toPoi:(NSString *)poiString;

-(BOOL)isNextPageAvailable:(int)cIndex currentPoiGroupSize:(int)currentPoiGroupSize;

-(BOOL)isPreviousPageAvailable:(int)cIndex;

-(int)getTo:(int)currentPoiGroupSize;

-(int)getFrom:(int)currentPoiGroupSize;




@end
