//
//  PoiFinderNew.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/1/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiFinderNew.h"


@implementation PoiFinderNew


@synthesize exculdePoiId;
@synthesize poiIds;
@synthesize drvDists;
@synthesize searchKeyword;
@synthesize poiFindType;
@synthesize pageNumber;
@synthesize fType;
@synthesize suggestedKeywords;
@synthesize categoryId;
@synthesize poiStringsArray;
@synthesize poiDtoGroup;
@synthesize isLoaded;
@synthesize dontDisplay;
@synthesize poiStringsParamValue;
@synthesize fromPersistantState;


-(void) getExternalCouponPois: (int)fetchType caller:(NSObject *) referenceToCaller
{
	[self getOtherPois:fetchType caller:referenceToCaller poiFindType:EXTERNAL_COUPON_POIS];
	
}
-(void) getCOTDPois: (int)fetchType caller:(NSObject *) referenceToCaller
{
	[self getOtherPois:fetchType caller:referenceToCaller poiFindType:COTD_OTHER_POIS];
	
}
-(void) getOtherPois: (int)fetchType caller:(NSObject *) referenceToCaller poiFindType:(int)type
{
	fType = fetchType;
	caller = referenceToCaller;
	if(fetchType == FETCH_FIRST){
		pageNumber = 1;
		poiFindType = type;
		//if(poiFindType == EXTERNAL_COUPON_POIS)
		//	self.poiIds = self.drvDists = nil;
	}
	else if(fetchType == FETCH_NEXT)
		pageNumber = pageNumber + 1;
	else if(fetchType == FETCH_PREVIOUS)
		pageNumber = pageNumber - 1;
	
	[self execute];
}
-(void) execute
{
	if(!appDelegate)
		appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(adaptor)
		[adaptor release];
	adaptor = [[HttpTransportAdaptor alloc]init];
	
	NSString *string;
	if(poiFindType == EXTERNAL_COUPON_POIS)
		 string =[CommandUtil getXMLForGetExternalPoisCommmand:[NSString stringWithFormat:@"%d",pageNumber] 
															  poiIds:self.poiIds drvDists:self.drvDists];
	else if(poiFindType == COTD_OTHER_POIS)
		string = [CommandUtil getXMLForGetCOTDPoisCommmand:[NSString stringWithFormat:@"%d",pageNumber] 
													poiIds:self.poiIds drvDists:self.drvDists poiId:exculdePoiId];
	
		[adaptor sendXMLRequest:string referenceOfCaller:self];

		
	

}


-(void) findPoisOpt:(int)findType fetchType:(int)fetchType {
@try {
	//NSLog(@"findPoisOpt started.");
	isLoaded = NO;
	if (fetchType == FETCH_FIRST){
		pageNumber = 1;
		[self executeOpt:findType];
		
	} else if (fetchType == FETCH_NEXT) {
	
		pageNumber = pageNumber + 1;
		[self callTheCaller:[self getPoiGroup]];
				
	} else if (fetchType == FETCH_PREVIOUS){
		
		pageNumber = pageNumber - 1;
		[self callTheCaller:[self getPoiGroup]];
		
	} else if (fetchType == FETCH_CURRENT) {
		[self callTheCaller:[self getPoiGroup]];
	}
}
	@catch (NSException * e) {
		NSLog(@"findPoisOpt:(int)findType fetchType:(int)fetchType: Caught %@: %@", [e name], [e  reason]);
	}
	//NSLog(@"findPoisOpt ended on control transfer");	
	
}


-(BOOL) isEmptyParamPresent:(NSData *)response{
BOOL isParamPresent = NO;
@try {
//NSLog(@"isEmptyParamPresent started.");
	
	XMLParser *parserForEmptyPoi = [[XMLParser alloc]parseXMLFromData:response 
															className:@"PoiDtoGroup" 
														   parseError:nil];
	
	NSArray *emptyPoiArray = [parserForEmptyPoi getArray];
	
	if([emptyPoiArray count] > 0){
		PoiDtoGroup *emptyPoiDtoGroup = [emptyPoiArray objectAtIndex:0];
		PoiDtoGroup *poiDtoGroupp = [PoiDtoGroup alloc];
		poiDtoGroupp.suggestedKeywords = emptyPoiDtoGroup.suggestedKeywords;
		emptyPoiDtoGroup.vector = nil;
		self.suggestedKeywords = emptyPoiDtoGroup.suggestedKeywords;
		self.poiDtoGroup = poiDtoGroupp;
		[poiDtoGroupp release];
		isParamPresent= YES;		
	}
	
	[parserForEmptyPoi setArray];
	[emptyPoiArray release];
	[parserForEmptyPoi release];
}
	@catch (NSException * e) {
		NSLog(@"isEmptyParamPresent:(NSData *)response: Caught %@: %@", [e name], [e  reason]);
	}
	//NSLog(@"isEmptyParamPresent ended.");
	return isParamPresent;
	
}
-(NSString *) getResultParam:(NSData *)response{
@try {
	//NSLog(@"getResultParam started.");


	XMLParser *resultParser = [[XMLParser alloc]parseXMLFromData:response 
															className:@"CommandParam" 
														   parseError:nil];
	NSArray *resultParams = [resultParser getArray];
	NSString *poiStrings = nil;
	if([resultParams count] > 0){
		CommandParam *param = [resultParams objectAtIndex:0];
		poiStrings = [param.paramValue retain];
	
	}
	
	[resultParser setArray];
	[resultParams release];
	[resultParser release];
	//NSLog(@"getResultParam ended.");
	return poiStrings;
}
@catch (NSException * e) {
	NSLog(@"getResultParam:(NSData *)response: Caught %@: %@", [e name], [e  reason]);
}
return nil;	
}

-(void) processHttpResponse:(NSData *) response{
@try {

	//NSLog(@"processHttpResponse started.");
	if([response length] ==0){
		[adaptor release];
		adaptor = nil;
		[response release];
		[self communicationError:@""];
		return;
	}
	PoiDtoGroup *poiDtoGroupp = nil;
	if(poiFindType == EXTERNAL_COUPON_POIS || poiFindType == COTD_OTHER_POIS){
	
		PoiXMLParser *poiXMLParser = [[PoiXMLParser alloc] parseXMLFromData:response parseError:nil]; 
	
		NSMutableDictionary *dic = [poiXMLParser getDictionary];
		poiDtoGroupp = [dic objectForKey:@"result"] ;
	

		if(!appDelegate.imageLogos)
			appDelegate.imageLogos = [[[NSMutableDictionary alloc] init] autorelease];
	
		for (Poi *poi in poiDtoGroup.vector) {
			if(poi.imageBytes && [[poi.imageBytes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >0){
				NSData* base64Data = [[[NSData alloc] initWithBase64EncodedString:poi.imageBytes]autorelease];
				[appDelegate.imageLogos setObject:base64Data forKey:poi.name];
			}
		}
	
		if(fType == FETCH_FIRST && poiFindType == EXTERNAL_COUPON_POIS){
			self.poiIds =  [dic objectForKey:@"poiIds"];
			self.drvDists = [dic objectForKey:@"drvDists"];
		}

		poiDtoGroup.next =  [poiDtoGroup.nextPage isEqualToString:@"1"];
		poiDtoGroup.previous =  [poiDtoGroup.previousPage isEqualToString:@"1"];

		[poiXMLParser release];
	
	}else{
		
		if([self isEmptyParamPresent:response]){
			poiDtoGroupp = self.poiDtoGroup;
		} 
		else{
			NSString *poiStrings = [self getResultParam:response];
			self.poiStringsParamValue = poiStrings;
			if(poiStrings){
				if([poiStrings length] > 0){
					[self setPoiStringArray:poiStrings];
					poiDtoGroupp = [self getPoiGroup];
				
				}
				[poiStrings release];
			
			}
		
		}
	}

	[adaptor release];
	adaptor = nil;
	[response release];
	//NSLog(@"processHttpResponse ended.");
	[self callTheCaller:poiDtoGroupp];
}
	@catch (NSException * e) {
		NSLog(@"processHttpResponse:(NSData *) response: Caught %@: %@", [e name], [e  reason]);
	}
	//NSLog(@"processHttpResponse ended on control tranfer.");
	
}

-(void) loadValueThroughString:(NSString *) poiStringsVal commandName:(NSString *)commandName caller:(NSObject *) referenceToCaller{
@try{
	fromPersistantState = YES;
	pageNumber = 1;
	self.poiStringsParamValue = poiStringsVal;
	caller = referenceToCaller;
	[self setPoiStringArray:poiStringsVal];
	PoiDtoGroup *poiDtoGroupp = [self getPoiGroup];
	[self callTheCaller:poiDtoGroupp];
	fromPersistantState = NO;
}
@catch (NSException * e) {
	NSLog(@"loadValueThroughString:(NSString *) poiStringsVal: Caught %@: %@", [e name], [e  reason]);
}

} 
-(void) callTheCaller:(PoiDtoGroup *)poiDtoGroupForCaller{
	isLoaded = YES;
	[((MainViewController *) caller) displayResultDto:poiDtoGroupForCaller];
}
-(void)cancelRequest{
	if(adaptor){
		[adaptor cancelRequest];
		[adaptor release];
		adaptor = nil;
	}
}

-(NSArray *) split:(NSString *)str seperator:(NSString *)seperator{
//NSLog(@"split started");
	@try {
		NSArray *strArray =  [str componentsSeparatedByString:seperator];
		return strArray;
	}
	@catch (NSException * e) {
		NSLog(@"split:(NSString *)str seperator:(NSString *)seperator: Caught %@: %@", [e name], [e  reason]);
	}
	return nil;
	
}

-(void) searchPois:(int)fetchType keyword:(NSString *)keyword  caller:(NSObject *)callerObject{
@try {
	//NSLog(@"searchPois started");
	caller = callerObject;
	if(fetchType == FETCH_FIRST)
		self.searchKeyword = keyword;
	//NSLog(@"searchPois ended");
	[self findPoisOpt:SEARCH fetchType:fetchType];
	
}
	@catch (NSException * e) {
		NSLog(@"searchPois:(int)fetchType keyword:(NSString *)keyword  caller:(NSObject *)callerObject: Caught %@: %@", [e name], [e  reason]);
		
	}
	//NSLog(@"searchPois ended on control transfer");
}
-(void) browsePois:(int)fetchType categoryId:(NSString *)browserCategoryId  caller:(NSObject *)callerObject{
	@try {
		//NSLog(@"browsePois started");
		caller = callerObject;
		if(fetchType == FETCH_FIRST)
			self.categoryId = browserCategoryId;
		//NSLog(@"browsePois ended");
		[self findPoisOpt:BROWSE fetchType:fetchType];
		
	}
	@catch (NSException * e) {
		NSLog(@"browsePois:(int)fetchType keyword:(NSString *)keyword  caller:(NSObject *)callerObject: Caught %@: %@", [e name], [e  reason]);
		
	}
	//NSLog(@"browsePois ended on control transfer");
}
-(void) getPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject{
	@try {
		//NSLog(@"getPoisWithCoupons started");
		caller = callerObject;

		//NSLog(@"getPoisWithCoupons ended");
		[self findPoisOpt:GET_COUPONS fetchType:fetchType];
		
	}
	@catch (NSException * e) {
		NSLog(@"getPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject: Caught %@: %@", [e name], [e  reason]);
		
	}
	//NSLog(@"getPoisWithCoupons ended on control transfer");
}
-(void) getLoyaltyPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject{
	@try {
		//NSLog(@"getPoisWithCoupons started");
		caller = callerObject;
		
		//NSLog(@"getPoisWithCoupons ended");
		[self findPoisOpt:GET_LOYALTY_POIS fetchType:fetchType];
		
	}
	@catch (NSException * e) {
		NSLog(@"getLoyaltyPoisWithCoupons:(int)fetchType caller:(NSObject *)callerObject: Caught %@: %@", [e name], [e  reason]);
		
	}

}
-(void) executeOpt:(int)poiFindTyppe {
@try {
	

	isLoaded= YES;
	dontDisplay = NO;

	PoiRequestParams *requestParams = [[PoiRequestParams alloc] init];		
	
	if (poiFindTyppe == BROWSE){
		requestParams.commandName = BROWSE_POI_OPT_COMMAND;
		requestParams.poiCategoryId = self.categoryId;		
				
	} else if (poiFindTyppe == SEARCH){
				
		requestParams.searchKeyword = self.searchKeyword;
		requestParams.commandName = SEARCH_POI_OPT_COMMAND;
				
	} else if (poiFindTyppe == GET_COUPONS){
		requestParams.commandName = GET_COUPONS_OPT_COMMAND;
				
	} else if (poiFindTyppe == GET_LOYALTY_POIS){
		requestParams.commandName = GET_LOYALTY_POIS_COMMAND;
		
	} 
	
	NSString *xmlRequest = [CommandUtil getXMLForPoisOptCommand:requestParams];
			
			
	if(adaptor)
		[adaptor release];
	adaptor = [[HttpTransportAdaptor alloc]init];
	//NSLog(@"executeOpt ended");
	[adaptor sendXMLRequest:xmlRequest referenceOfCaller:self];
}
	@catch (NSException * e) {
		NSLog(@"executeOpt:(int)poiFindTyppe: Caught %@: %@", [e name], [e  reason]);
		
	}
	//NSLog(@"executeOpt ended on control transfer.");
			
}
-(void) setPoiStringArray:(NSString *) poiStrings{
//NSLog(@"setPoiStringArray started");
	@try {
		NSArray *stringsArray = [self split:poiStrings seperator:POI_SPLIT_SYMBOL];
		self.poiStringsArray = stringsArray;
//		[stringsArray release];
	}
	@catch (NSException * e) {
		NSLog(@"setPoiStringArray:(NSString *) poiStrings: Caught %@: %@", [e name], [e  reason]);
	}
//NSLog(@"setPoiStringArray ended");
}

-(PoiDtoGroup *) getPoiGroup{
	@try {
	

		PoiDtoGroup *resultPoiDtoGroup = [[PoiDtoGroup alloc]init];
		NSMutableArray *currentPoiArray = [[NSMutableArray alloc]init];
	
	
//		int groupMaxSize = DEFAULT_PAGE_SIZE; 
	
		int totalPoisSize = [self.poiStringsArray count];
		
		int startIndex = [self calculatePageStartIndex];
		
		int pageNo = [self calculatePageNumber:startIndex];
		self.pageNumber = pageNo;
		
		
		
		int i = 0;
		
		for (i = startIndex; i < totalPoisSize; i++) {
			NSString *poiString = (NSString *)[self.poiStringsArray objectAtIndex:i];
			Poi *poiFromString = [self toPoi:poiString];
			[currentPoiArray addObject:poiFromString];
			[poiFromString release];
//			if ([currentPoiArray count] == groupMaxSize)
//				break;
			
		}
		int currentPoiGropSize = [currentPoiArray count];
		
		resultPoiDtoGroup.totalPois = [NSString stringWithFormat:@"%d",totalPoisSize];
		resultPoiDtoGroup.vector = currentPoiArray;
		[currentPoiArray release];
		
		resultPoiDtoGroup.next  = [self isNextPageAvailable:i currentPoiGroupSize:currentPoiGropSize];
		
		resultPoiDtoGroup.previous= [self isPreviousPageAvailable:startIndex];
		
		resultPoiDtoGroup.pageNumber = [NSString stringWithFormat:@"%d",self.pageNumber];
		
		resultPoiDtoGroup.from = [NSString stringWithFormat:@"%d",[self getFrom:currentPoiGropSize]];
		
		resultPoiDtoGroup.to = [NSString stringWithFormat:@"%d",[self getTo:currentPoiGropSize]];
		

		//NSLog(@"getPoiGroup ended.");
		return resultPoiDtoGroup;
	}
	@catch (NSException * e) {
		NSLog(@"getPoiGroup:(NSString *)poiString: Caught %@: %@", [e name], [e  reason]);
	}
	return nil;
	
}
-(int)getTo:(int)currentPoiGroupSize{
	//NSLog(@"getTo started");
	int to;
	
	if (currentPoiGroupSize < DEFAULT_PAGE_SIZE)
		to = currentPoiGroupSize;
	else		
		to = pageNumber * DEFAULT_PAGE_SIZE;

	//NSLog(@"getTo ended");
	return to;
}
-(int)getFrom:(int)currentPoiGroupSize{
	//NSLog(@"getFrom started");
	int from = 0;
    int to = [self getTo:currentPoiGroupSize];
    
    if(currentPoiGroupSize< DEFAULT_PAGE_SIZE)
        from = to -( currentPoiGroupSize - 1);
	else
    	from = to - (DEFAULT_PAGE_SIZE - 1);

	//NSLog(@"getFrom ended");
	return from;
}

-(BOOL)isNextPageAvailable:(int)cIndex currentPoiGroupSize:(int)currentPoiGroupSize{
	//NSLog(@"isNextPageAvailable started");
	BOOL isNextPageAvailable = NO;
@try {

	int lastElementIndex = [poiStringsArray count] -1;
	
	if (currentPoiGroupSize < DEFAULT_PAGE_SIZE || lastElementIndex == cIndex) 
		isNextPageAvailable = NO;
	else 
		isNextPageAvailable = YES;
}
	@catch (NSException * e) {
		NSLog(@"isNextPageAvailable:(int)cIndex currentPoiGroupSize:(int)currentPoiGroupSize: Caught %@: %@", [e name], [e  reason]);
	}	
	
	//NSLog(@"isNextPageAvailable ended");
	return isNextPageAvailable;


}

-(BOOL)isPreviousPageAvailable:(int)cIndex{
	//NSLog(@"isPreviousPageAvailable started");
	BOOL isPreviousPageAvailable = NO;
	
	if (cIndex == 0) 
		isPreviousPageAvailable = NO;
	else
		isPreviousPageAvailable = YES;
	
	//NSLog(@"isPreviousPageAvailable ended");
	return isPreviousPageAvailable;



}


-(int) calculatePageStartIndex{
//NSLog(@"calculatePageStartIndex started");
	int startIndex = (pageNumber - 1) * DEFAULT_PAGE_SIZE;
	int totalPoisSize = [self.poiStringsArray count];
	
	if (startIndex > (totalPoisSize - 1)) {
		
		if (totalPoisSize < DEFAULT_PAGE_SIZE) {
			
			startIndex = 0;
			return startIndex;
		}
		
		int lastPageSize = totalPoisSize % DEFAULT_PAGE_SIZE;
		
		if (lastPageSize == 0) {
			
			startIndex = totalPoisSize - DEFAULT_PAGE_SIZE;
			
		} else {
			
			startIndex = totalPoisSize - lastPageSize;
		}
		
	}
//NSLog(@"calculatePageStartIndex ended");
	return startIndex;


}		

-(int) calculatePageNumber:(int) startIndex {
//NSLog(@"calculatePageNumber started");
	int pageNo = 0;
	pageNo = ((startIndex + 1) + (DEFAULT_PAGE_SIZE - 1)) / DEFAULT_PAGE_SIZE;
//NSLog(@"calculatePageNumber ended");
	return pageNo;
}
-(Poi *) toPoi:(NSString *)poiString{
//NSLog(@"toPoi started");
	@try {

		Poi *poi = [[Poi alloc]init];
		NSArray *poiValueArray = [self split:poiString seperator:POI_PROPERTY_VALUES_SPLIT_SYMBOL];
		for(int i=0; i< [poiValueArray count] ; i++){
			NSString *poiValue = [poiValueArray objectAtIndex:i];
			switch (i) {
				case 0:
					poi.poiId = poiValue;
					break;
				case 1:
					poi.name = poiValue;
					break;
				case 2:		
					poi.completeAddress = [poiValue stringByReplacingOccurrencesOfString:@";" withString:@","];
					break;
				case 3:
					poi.phoneNumber = poiValue;
					break;
				case 4:
					if([poiValue compare:@"null"]!= NSOrderedSame)
						poi.imageBytes = poiValue;
					break;
				case 5:
					poi.imageName = poiValue;
					break;
				case 6:
					poi.distance = poiValue;
					break;
				case 7:
					poi.poiCategoryId = poiValue;
					break;			
				case 8:
					poi.couponCount = poiValue;
					break;
				case 9:
					poi.isCOTDPoi = poiValue;
					break;
				case 10:
					poi.isSponsored = poiValue;
					break;
				case 11:
					poi.poiSequenceNumber = poiValue;
					break;
				case 12:
                    poi.userPoints = poiValue;
					break;
				case 13:
					poi.reviewCount = [poiValue intValue];
					break;	
				case 14:
					poi.feedbackCount = [poiValue intValue];
					break;
                case 15:
                    poi.poiType = poiValue;
                    break;
                case 16:
                    poi.latitude = poiValue;
                    break;
                case 17:
                    poi.longitude = poiValue;
                    break;
				default:
					break;
			}
		}
//		NSLog(@"toPoi ended");
//		[poiValueArray release];
        poiValueArray = nil;
		return poi;
	}
	@catch (NSException * e) {
		NSLog(@"toPoi:(NSString *)poiString: Caught %@: %@", [e name], [e  reason]);
	}
	
	return nil;
}

		
-(void)communicationError:(NSString *)errorMsg{
    [appDelegate.progressHud removeFromSuperview];
	[adaptor release];
	adaptor = nil;
	[self callTheCaller:nil];
	
}


- (void) dealloc
{
@try{

	[drvDists release];
	[poiIds release];
	[exculdePoiId release];
	//[searchKeyword release];
	////NSLog(@"searchKeyword retainCount %d", [searchKeyword retainCount]);
	[suggestedKeywords release];
	[categoryId release];
	[poiStringsArray release];

	[poiDtoGroup release];
	[poiStringsParamValue release];
}
@catch (NSException * e) {
	NSLog(@"(void) dealloc: Caught %@: %@", [e name], [e  reason]);
}	
	[super dealloc];

}

@end
