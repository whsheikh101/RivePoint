//
//  PoiDtoGroup.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PoiDtoGroup : NSObject {
	NSString *poiTypeToFetch;
	NSString *totalPois;
	NSString *suggestedKeywords;
	NSString *fromSequenceNumber;
	NSString *toSequenceNumber;
	NSMutableArray *vector;
	NSString *totalPoisProcessed;
	BOOL next;
	BOOL previous;
	NSString *registerPoisCount;
	NSString *nextPage;
	NSString *previousPage;
	NSString *pageNumber;
	NSString *to;
	NSString *from;
	
}
@property (nonatomic,retain) NSString *poiTypeToFetch;
@property (nonatomic,retain) NSString *totalPois;
@property (nonatomic,retain) NSString *suggestedKeywords;
@property (nonatomic,retain) NSString *fromSequenceNumber;
@property (nonatomic,retain) NSString *toSequenceNumber;
@property (nonatomic,retain) NSMutableArray *vector;
@property (nonatomic,retain) NSString *totalPoisProcessed;
@property BOOL next;
@property BOOL previous;
@property (nonatomic,retain) NSString *registerPoisCount;
@property (nonatomic,retain) NSString *nextPage;
@property (nonatomic,retain) NSString *previousPage;
@property (nonatomic,retain) NSString *pageNumber;
@property (nonatomic,retain) NSString *to;
@property (nonatomic,retain) NSString *from;
@end
