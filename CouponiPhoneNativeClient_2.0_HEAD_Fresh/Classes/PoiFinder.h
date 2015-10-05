//
//  PoiFinder.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/20/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoiDtoGroup.h"
#import "PoiRequestParams.h"
#import "HttpTransportAdaptor.h"
#import "HTTPSupport.h"

@interface PoiFinder : NSObject <HTTPSupport> {
#define FETCH_FIRST 0
#define FETCH_NEXT 1
#define FETCH_PREVIOUS 2
#define REGISTERED @"1"
#define UNREGISTERED @"2" 
	
# define POI_CACHE_SIZE 5

	HttpTransportAdaptor *adaptor;
	NSMutableArray *poiDtoGroups;
	NSMutableArray *poiDistanceDtos;
	int totalPois;
	int registeredPoiCount;
	int currentPoiDtoGroupIndex;
	BOOL lastRegisteredPoiGroup;
	
	int poiDtoGroupsSize;
	
	NSObject *caller;
	NSString *currentCommand;
	int currentFetchType;
	NSString *searchKeyword;
	NSString *categoryId;
	
	BOOL isLoaded;
	BOOL dontDisplay;
	
	NSString *suggestedKeywords;

}

@property (assign) int totalPois;
@property (assign) int registeredPoiCount;
@property (assign) int currentPoiDtoGroupIndex;
@property (assign) BOOL lastRegisteredPoiGroup;
@property (assign) BOOL isLoaded;

@property (assign) BOOL dontDisplay;

@property (nonatomic,retain) NSString *suggestedKeywords;
@property (nonatomic,retain) NSString *currentCommand;

-(void) processFirstResult:(PoiDtoGroup *) poiDtoGroup;
-(void) processNextResult:(PoiDtoGroup *) poiDtoGroup;
-(void) processPreviousResult:(PoiDtoGroup *) poiDtoGroup;
-(int) getTo;
-(int) getFrom;
-(BOOL) getNextPoiGroupAvalaibility:(BOOL) isGetCouponRequest;
-(BOOL) getPreviousPoiGroupAvalaibility;
-(BOOL) isLastRegisteredPoiGroup;
-(PoiDtoGroup *) getPoiDtoGroup:(int) index;

-(void) execute:(PoiRequestParams *) poiRequestParams;
-(PoiRequestParams *) setupGetCouponsNextRequest:(NSString *)subsId 
										latitude:(NSString *)latitude longitude:(NSString *)longitude;
-(PoiRequestParams *) setupGetCouponsPreviousRequest:(NSString *)subsId 
											latitude:(NSString *)latitude longitude:(NSString *)longitude;


-(void) setupFirstRequest;

-(void) find:(NSString *)commandName fetchType:(int)fetchType latitude:(NSString *)latitude 
									 longitude:(NSString *)longitude subsId:(NSString *) subsId referenceToCaller:(NSObject *) referenceToCaller
								 searchKeyword:(NSString *)keyword categoryId:(NSString *)cid;

-(PoiDtoGroup *) createPoiResult;
	
-(PoiRequestParams *) setupNextRequest:(NSString *)subsId 
										latitude:(NSString *)latitude longitude:(NSString *)longitude;
-(PoiRequestParams *) setupPreviousRequest:(NSString *)subsId 
											latitude:(NSString *)latitude longitude:(NSString *)longitude;
- (void) nullifyPoiDtoGroup;	
- (BOOL) checkCache:(int) fetchType;
-(void) callTheCaller:(PoiDtoGroup *)poiDtoGroupForCaller;
-(void)cancelRequest;

@end
