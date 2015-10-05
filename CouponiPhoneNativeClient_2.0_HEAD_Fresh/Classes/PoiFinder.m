//
//  PoiFinder.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 2/20/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiFinder.h"
#import "PoiRequestParams.h"
#import "HttpTransportAdaptor.h"
#import "CommandUtil.h"
#import "PoiXMLParser.h"
#import "MainViewController.h"
#import "Base64.h"
#import "Poi.h"
#import "RivePointAppDelegate.h"

@implementation PoiFinder

@synthesize totalPois;
@synthesize registeredPoiCount;
@synthesize currentPoiDtoGroupIndex;
@synthesize lastRegisteredPoiGroup;
@synthesize isLoaded;
@synthesize dontDisplay;
@synthesize currentCommand;
@synthesize suggestedKeywords;


-(void) processFirstResult:(PoiDtoGroup *) poiDtoGroup {
	
	
	[poiDtoGroups addObject:poiDtoGroup];
	poiDtoGroupsSize = poiDtoGroupsSize + 1;
	if(![currentCommand isEqualToString:GET_COUPONS_COMMAND])
		registeredPoiCount =  [poiDtoGroup.registerPoisCount intValue];
	
	totalPois = [poiDtoGroup.totalPois intValue];
	poiDistanceDtos = poiDtoGroup.vector;
	currentPoiDtoGroupIndex = [poiDtoGroups indexOfObject:[poiDtoGroups lastObject]];
}
-(void) processNextResult:(PoiDtoGroup *) poiDtoGroup{
	int cacheLimitIndex = 0;
	if(self.currentPoiDtoGroupIndex == [poiDtoGroups indexOfObject:[poiDtoGroups lastObject]]){
		[poiDtoGroups addObject:poiDtoGroup];
		poiDtoGroupsSize = poiDtoGroupsSize + 1;
		self.currentPoiDtoGroupIndex = [poiDtoGroups indexOfObject:[poiDtoGroups lastObject]];
		if(poiDtoGroupsSize > POI_CACHE_SIZE ){
			cacheLimitIndex = currentPoiDtoGroupIndex - POI_CACHE_SIZE;
			///Release the object that is replaced....
			PoiDtoGroup *tempGroup =  [poiDtoGroups objectAtIndex:cacheLimitIndex];
			//[tempGroup.vector release];
			tempGroup.vector = nil;
			poiDtoGroupsSize = poiDtoGroupsSize -1;
		}
		poiDistanceDtos = poiDtoGroup.vector;
	}
	else{
		PoiDtoGroup *tGroup =  [poiDtoGroups objectAtIndex:(currentPoiDtoGroupIndex +1)];
		tGroup.vector = poiDtoGroup.vector;
		
		self.currentPoiDtoGroupIndex = self.currentPoiDtoGroupIndex +1;
		poiDtoGroupsSize = poiDtoGroupsSize + 1;
		if(poiDtoGroupsSize > POI_CACHE_SIZE ){
			cacheLimitIndex = currentPoiDtoGroupIndex - POI_CACHE_SIZE;
			///Release the object that is replaced....
			PoiDtoGroup *tempGroup =  [poiDtoGroups objectAtIndex:cacheLimitIndex];
			//[tempGroup.vector release];
			tempGroup.vector = nil;
			poiDtoGroupsSize = poiDtoGroupsSize -1;
		}
		poiDistanceDtos = poiDtoGroup.vector;
		[poiDtoGroup release];
	}
	
}
-(void) processPreviousResult:(PoiDtoGroup *) poiDtoGroup{
	PoiDtoGroup *tGroup =  [poiDtoGroups objectAtIndex:(currentPoiDtoGroupIndex -1)];
	tGroup.vector = poiDtoGroup.vector;
	
	int cacheLimitIndex = 0;
	self.currentPoiDtoGroupIndex = self.currentPoiDtoGroupIndex -1;
	poiDtoGroupsSize = poiDtoGroupsSize + 1;
	if(poiDtoGroupsSize > POI_CACHE_SIZE ){
		cacheLimitIndex = currentPoiDtoGroupIndex + POI_CACHE_SIZE;
		///Release the object that is replaced....
		PoiDtoGroup *tempGroup =  [poiDtoGroups objectAtIndex:cacheLimitIndex];
		//[tempGroup.vector release];
		tempGroup.vector = nil;
	
		//[poiDtoGroups insertObject:nil atIndex:cacheLimitIndex];
		poiDtoGroupsSize = poiDtoGroupsSize -1;
		
	}
	poiDistanceDtos = poiDtoGroup.vector;
	[poiDtoGroup release];
	
}
-(int) getPoiDistanceDtoSize{
	return [poiDistanceDtos count] ;
	
}
-(int) getTo{
	int to =0;
	if([self getPoiDistanceDtoSize] < 5){
		to = self.totalPois;
	}
	else{
		int index =currentPoiDtoGroupIndex + 1;
		to = index*5;
	}
	return to;
}
-(int) getFrom{
	int from = 0;
	if([self getPoiDistanceDtoSize] < 5){
		int size =[self getPoiDistanceDtoSize] -1;
		from = [self getTo] - size;
	}
	else{
		from = [self getTo] -4;
	}
	return from;
	
	
}
-(BOOL) getNextPoiGroupAvalaibility:(BOOL) isGetCouponRequest{
	PoiDtoGroup *cg = [self getPoiDtoGroup:self.currentPoiDtoGroupIndex];
	//Registered = 1 ; Unregistererd = 2
	if(isGetCouponRequest){
		if([cg.totalPoisProcessed isEqualToString:@"true"] && [cg.poiTypeToFetch isEqualToString:REGISTERED])
			return YES;
	}
	
	if(!(([cg.totalPoisProcessed isEqualToString:@"true"] && [cg.poiTypeToFetch isEqualToString:UNREGISTERED]) ||
	   ([cg.totalPoisProcessed isEqualToString:@"true2"] && [cg.poiTypeToFetch isEqualToString:REGISTERED]) ||
	   ([cg.totalPoisProcessed isEqualToString:@"true4"] && [cg.poiTypeToFetch isEqualToString:REGISTERED]) ))
		return YES;
	else{
		if(([cg.totalPoisProcessed isEqualToString:@"true"] && [cg.poiTypeToFetch isEqualToString:UNREGISTERED]) &&	
		(self.currentPoiDtoGroupIndex < [poiDtoGroups indexOfObject:[poiDtoGroups lastObject]]))
			return YES;
		   
	}
	return NO;
}
-(BOOL) getPreviousPoiGroupAvalaibility{
	if(self.currentPoiDtoGroupIndex > 0)
		return YES;
	return NO;
	
}
-(BOOL) isLastRegisteredPoiGroup{
	if(registeredPoiCount <= 5)
		return NO;
	else if(registeredPoiCount - ((currentPoiDtoGroupIndex+1)*5) <= 5)
		return  YES;
	else
		return  NO;
	
}
-(PoiDtoGroup *) getPoiDtoGroup:(int) index{
	return [poiDtoGroups objectAtIndex:index];
}
-(void) sendRequest:(PoiRequestParams *) poiRequestParams{
	if(adaptor)
		[adaptor release];
	adaptor = [[HttpTransportAdaptor alloc]init];
	NSString *string =[CommandUtil getXMLForPoisCommand:poiRequestParams];
	[adaptor sendXMLRequest:string referenceOfCaller:self];
	self.dontDisplay = NO;
	//[string release];
}
-(PoiDtoGroup *) processResponse:(PoiDtoGroup *)poiDtoGroup{
	PoiDtoGroup *result;
	//if([currentCommand isEqualToString:GET_COUPONS_COMMAND]){
		

	
	
	
		if(currentFetchType == FETCH_FIRST){
			
			
			//self.suggestedKeywords = poiDtoGroup.suggestedKeywords;
			if(![poiDtoGroup.suggestedKeywords isEqualToString:@"null"] || 
			   ![poiDtoGroup.suggestedKeywords isEqualToString:@""]){
				//NSArray *keywords =  [poiDtoGroup.suggestedKeywords componentsSeparatedByString:@","];
				//[poiDtoGroup.suggestedKeywords inde
				//NSString *tempStr = [keywords objectAtIndex:0];
				self.suggestedKeywords = poiDtoGroup.suggestedKeywords;
				//[tempStr release];
				
			}
			
			
			
		
			[self processFirstResult:poiDtoGroup];
			result = [self createPoiResult];
			
			
		}
		else if(currentFetchType == FETCH_NEXT){
			
			[self processNextResult:poiDtoGroup];
			result = [self createPoiResult];
			
		}
		else if(currentFetchType == FETCH_PREVIOUS){
			[self processPreviousResult:poiDtoGroup];
			result = [self createPoiResult];
		}
	//}		
	return result;
}
-(void) processHttpResponse:(NSData *) response{
	if([response length] ==0){
		[adaptor release];
		adaptor = nil;
		[response release];
		[self communicationError:@""];
		return;
	}
	
	PoiXMLParser *poiXMLParser = [[PoiXMLParser alloc] parseXMLFromData:response parseError:nil]; 
	
	NSMutableDictionary *dic = [poiXMLParser getDictionary];
	PoiDtoGroup *poiDtoGroup = [dic objectForKey:@"result"] ;
	
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(!appDelegate.imageLogos)
		appDelegate.imageLogos = [[[NSMutableDictionary alloc] init] autorelease];
	
	for (Poi *poi in poiDtoGroup.vector) {
		if(poi.imageBytes && [[poi.imageBytes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >0){
			NSData* base64Data = [[[NSData alloc] initWithBase64EncodedString:poi.imageBytes]autorelease];
			[appDelegate.imageLogos setObject:base64Data forKey:poi.name];
		}
	}
	
	
	if(![currentCommand isEqualToString:GET_COUPONS_COMMAND]){
		poiDtoGroup.registerPoisCount =  [dic objectForKey:@"registeredPoisCount"];
		if([poiDtoGroup.vector count] ==0)
			poiDtoGroup.vector = nil;
	}
	[poiXMLParser release];
	[adaptor release];
	adaptor = nil;
	[response release];
	poiDtoGroup =[self processResponse:poiDtoGroup];
	isLoaded = YES;
	//if(self.dontDisplay)
	//	return;
		//[caller displayResultDto:poiDtoGroup];	
		[self callTheCaller:poiDtoGroup];
	
	
}
-(void) execute:(PoiRequestParams *) poiRequestParams{
	
	if(![currentCommand isEqualToString:GET_COUPONS_COMMAND]){
		if([poiRequestParams.poiTypeToFetch isEqualToString:UNREGISTERED]){
			//if(poiRequestParams.lastRegisteredPoiGroup)
			//	[lastRegisteredPoiGroup release];
			poiRequestParams.lastRegisteredPoiGroup = @"false";
		}
	}
	
	if([currentCommand isEqualToString:SEARCH_POI_COMMAND])
		poiRequestParams.searchKeyword = [searchKeyword copy];
	else if([currentCommand isEqualToString:BROWSE_POI_COMMAND])
		poiRequestParams.poiCategoryId = [categoryId copy];
	
	
	[self sendRequest:poiRequestParams];
}
-(PoiRequestParams *) setupGetCouponsNextRequest:(NSString *)subsId latitude:(NSString *)latitude longitude:(NSString *)longitude
{
	
	PoiDtoGroup *cg =[self getPoiDtoGroup:self.currentPoiDtoGroupIndex];
	PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
	poiRequestParams.commandName = GET_COUPONS_COMMAND;
	poiRequestParams.userLatitude = latitude;
	poiRequestParams.userLongitude = longitude;
	poiRequestParams.userID = subsId;
	poiRequestParams.fromSequenceNumber = cg.fromSequenceNumber;
	poiRequestParams.toSequenceNumber = cg.toSequenceNumber;
	poiRequestParams.radius =@"5";
	
	
	return poiRequestParams;
}
-(PoiRequestParams *) setupGetCouponsPreviousRequest:(NSString *)subsId 
											latitude:(NSString *)latitude longitude:(NSString *)longitude {
	
	PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
	poiRequestParams.commandName = GET_COUPONS_COMMAND;
	poiRequestParams.userLatitude = latitude;
	poiRequestParams.userLongitude = longitude;
	poiRequestParams.userID = subsId;
	poiRequestParams.radius =@"5";
	
	if((self.currentPoiDtoGroupIndex -1) == 0){
		poiRequestParams.fromSequenceNumber = @"0";
		poiRequestParams.toSequenceNumber = @"0";
	}
	else{
		int index = self.currentPoiDtoGroupIndex - 2;
		PoiDtoGroup *prev =[self getPoiDtoGroup:index];
		poiRequestParams.fromSequenceNumber = prev.fromSequenceNumber;
		poiRequestParams.toSequenceNumber = prev.toSequenceNumber;
	}
	return poiRequestParams;
	
}
-(void) initialize{
	if(poiDtoGroups){
		PoiDtoGroup *poiDtoGroup;
		for(poiDtoGroup in poiDtoGroups){
			[poiDtoGroup release];
			poiDtoGroup = nil;
		}
		[poiDtoGroups release];
	}
		
	poiDtoGroups = [[NSMutableArray alloc]init];
	///////Don't initialize this object causing leak
	//poiDistanceDtos = [[NSMutableArray alloc]init]; 
	totalPois = 0;
	currentPoiDtoGroupIndex = 0;
	registeredPoiCount = 0;
	lastRegisteredPoiGroup = NO;
	poiDtoGroupsSize = 0;
	
}

-(void) setupFirstRequest{
	[self initialize];
 	
}

-(void) find:(NSString *)commandName fetchType:(int)fetchType latitude:(NSString *)latitude 
		longitude:(NSString *)longitude subsId:(NSString *) subsId referenceToCaller:(NSObject *) referenceToCaller
		searchKeyword:(NSString *)keyword  categoryId:(NSString *)cid{
	caller = referenceToCaller;
	isLoaded = NO;
	currentCommand = commandName;
	//[currentFetchType release];
	currentFetchType = fetchType;
	
	if([commandName isEqualToString:GET_COUPONS_COMMAND]){
	if(fetchType == FETCH_FIRST){
		PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
		poiRequestParams.commandName = GET_COUPONS_COMMAND;
		poiRequestParams.userLatitude = latitude;
		poiRequestParams.userLongitude = longitude;
		poiRequestParams.userID = subsId;
		poiRequestParams.fromSequenceNumber =@"0";
		poiRequestParams.toSequenceNumber =@"0";
		poiRequestParams.radius =@"5";
		
		[self setupFirstRequest];
		//[self processFirstResult:[self execute:poiRequestParams]];
		//result = [self createPoiResult:YES];
		[self execute:poiRequestParams];
		
	}
	else if(fetchType == FETCH_NEXT){
		if([self checkCache:FETCH_NEXT]){
			isLoaded = YES;
			//[caller displayResultDto:[self createPoiResult]];	
			[self callTheCaller:[self createPoiResult]];
			return;
		}
			
 		PoiRequestParams *poiRequestParams = [self setupGetCouponsNextRequest:subsId 
																	 latitude:latitude longitude:longitude];
		//[self processNextResult:[self execute:poiRequestParams]];
	//	result = [self createPoiResult:YES];
		[self execute:poiRequestParams];
	}
	else if(fetchType == FETCH_PREVIOUS){
		if([self checkCache:FETCH_PREVIOUS]){
			isLoaded = YES;
			//[caller displayResultDto:[self processResponse:cPoiDtoGroup]];
			//[caller displayResultDto:[self createPoiResult]];
			[self callTheCaller:[self createPoiResult]];

			return;
		}
		
		PoiRequestParams *poiRequestParams = [self setupGetCouponsPreviousRequest:subsId 
																	 latitude:latitude longitude:longitude];
		//[self processPreviousResult:[self execute:poiRequestParams]];
		//result = [self createPoiResult:YES];
		[self execute:poiRequestParams];
	}
		
	}
	else if([commandName isEqualToString:SEARCH_POI_COMMAND] || 
			[commandName isEqualToString:BROWSE_POI_COMMAND]){
		
		if([commandName isEqualToString:SEARCH_POI_COMMAND])
			searchKeyword = [keyword copy];
		else if([commandName isEqualToString:BROWSE_POI_COMMAND])
			categoryId = [cid copy];
		
		if(fetchType == FETCH_FIRST){
			PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
			poiRequestParams.commandName = currentCommand;
			poiRequestParams.userLatitude = latitude;
			poiRequestParams.userLongitude = longitude;
			poiRequestParams.userID = subsId;
			poiRequestParams.fromSequenceNumber =@"0";
			poiRequestParams.toSequenceNumber =@"0";
			poiRequestParams.radius =@"5";
			poiRequestParams.poiTypeToFetch= REGISTERED;
			
			[self setupFirstRequest];

			[self execute:poiRequestParams];
			
		}
		else if(fetchType == FETCH_NEXT){
			if([self checkCache:FETCH_NEXT]){
				isLoaded = YES;
				//[caller displayResultDto:[self createPoiResult]];		
				[self callTheCaller:[self createPoiResult]];
				return;
			}
			
			PoiRequestParams *poiRequestParams = [self setupNextRequest:subsId 
																		 latitude:latitude longitude:longitude];

			[self execute:poiRequestParams];
		}
		else if(fetchType == FETCH_PREVIOUS){
			if([self checkCache:FETCH_PREVIOUS]){
				isLoaded = YES;
				//[caller displayResultDto:[self processResponse:cPoiDtoGroup]];
				//[caller displayResultDto:[self createPoiResult]];
				[self callTheCaller:[self createPoiResult]];
				return;
			}
			
			PoiRequestParams *poiRequestParams = [self setupPreviousRequest:subsId 
																			 latitude:latitude longitude:longitude];

			[self execute:poiRequestParams];
		}
		
	
	}
	
}
-(PoiDtoGroup *) createPoiResult{
	PoiDtoGroup *result = [[PoiDtoGroup alloc]init];
	result.totalPois = [NSString stringWithFormat:@"%d",self.totalPois];
	result.fromSequenceNumber = [NSString stringWithFormat:@"%d",[self getFrom]];
	result.toSequenceNumber =[NSString stringWithFormat:@"%d",[self getTo]];
	result.vector = poiDistanceDtos;
	if([currentCommand isEqualToString:GET_COUPONS_COMMAND])
		result.next =[self getNextPoiGroupAvalaibility:YES];
	else
		result.next =[self getNextPoiGroupAvalaibility:NO];
	
	result.previous = [self getPreviousPoiGroupAvalaibility];
	return result;

}
-(void)communicationError:(NSString *)errorMsg{
	[adaptor release];
	adaptor = nil;
	//[caller displayResultDto:nil];
	[self callTheCaller:nil];
	
}
-(void) callTheCaller:(PoiDtoGroup *)poiDtoGroupForCaller{
	
	[((MainViewController *) caller) displayResultDto:poiDtoGroupForCaller];
}
-(PoiRequestParams *) setupNextRequest:(NSString *)subsId 
							  latitude:(NSString *)latitude longitude:(NSString *)longitude{
	
	PoiDtoGroup *nr = [self getPoiDtoGroup:currentPoiDtoGroupIndex];
	PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
	poiRequestParams.commandName = currentCommand;
	poiRequestParams.userLatitude = latitude;
	poiRequestParams.userLongitude = longitude;
	poiRequestParams.userID = subsId;
	poiRequestParams.radius =@"5";
	
	
	
	if([nr.totalPoisProcessed isEqualToString:@"true1"] && [nr.poiTypeToFetch isEqualToString:REGISTERED]){
		poiRequestParams.poiTypeToFetch = UNREGISTERED;
		poiRequestParams.lastRegisteredPoiGroup =@"false";
		poiRequestParams.fromSequenceNumber = nr.fromSequenceNumber;
		poiRequestParams.toSequenceNumber = nr.toSequenceNumber;
	}
	else if([nr.totalPoisProcessed isEqualToString:@"true"] && [nr.poiTypeToFetch isEqualToString:REGISTERED]){
		poiRequestParams.fromSequenceNumber =@"0";
		poiRequestParams.toSequenceNumber =@"0";
		poiRequestParams.lastRegisteredPoiGroup =@"false";
		poiRequestParams.poiTypeToFetch = UNREGISTERED;
	}
	else{
		if([nr.totalPoisProcessed isEqualToString:@"false"] && [nr.poiTypeToFetch isEqualToString:REGISTERED]){
			if([self isLastRegisteredPoiGroup])
				poiRequestParams.lastRegisteredPoiGroup =@"true";
			else
				poiRequestParams.lastRegisteredPoiGroup =@"false";
			

		}
		poiRequestParams.poiTypeToFetch = nr.poiTypeToFetch;
		poiRequestParams.fromSequenceNumber = nr.fromSequenceNumber;
		poiRequestParams.toSequenceNumber = nr.toSequenceNumber;
	}
	return poiRequestParams;
}
-(PoiRequestParams *) setupPreviousRequest:(NSString *)subsId 
								  latitude:(NSString *)latitude longitude:(NSString *)longitude{

	PoiRequestParams *poiRequestParams = [[PoiRequestParams alloc]init];
	poiRequestParams.commandName = currentCommand;
	poiRequestParams.userLatitude = latitude;
	poiRequestParams.userLongitude = longitude;
	poiRequestParams.userID = subsId;
	poiRequestParams.radius =@"5";
	
	if((currentPoiDtoGroupIndex -1) == 0){
		poiRequestParams.fromSequenceNumber =@"0";
		poiRequestParams.toSequenceNumber =@"0";
		poiRequestParams.poiTypeToFetch = REGISTERED;
		poiRequestParams.lastRegisteredPoiGroup= @"false";
	}
	else{
		int i = currentPoiDtoGroupIndex-2;
		PoiDtoGroup *pr = [self getPoiDtoGroup:i];
			if([pr.totalPoisProcessed isEqualToString:@"false"] && [pr.poiTypeToFetch isEqualToString:REGISTERED]){
				if([self isLastRegisteredPoiGroup])
					poiRequestParams.lastRegisteredPoiGroup =@"true";
				else
					poiRequestParams.lastRegisteredPoiGroup =@"false";
						
			}
		poiRequestParams.fromSequenceNumber =pr.fromSequenceNumber;
		poiRequestParams.toSequenceNumber =pr.toSequenceNumber;
		poiRequestParams.poiTypeToFetch = pr.poiTypeToFetch;
				
	}
	return poiRequestParams;
	
}

- (BOOL) checkCache:(int) fetchType{
	if(fetchType == FETCH_NEXT){
		if(!(currentPoiDtoGroupIndex == [poiDtoGroups indexOfObject:[poiDtoGroups lastObject]] )){
			PoiDtoGroup *tempGroup = [poiDtoGroups objectAtIndex:(currentPoiDtoGroupIndex +1)];
			if(tempGroup.vector){
				currentPoiDtoGroupIndex = currentPoiDtoGroupIndex + 1;
				
				poiDistanceDtos = tempGroup.vector;
				return YES;
			}
		
		}
		
		
	}else if(fetchType == FETCH_PREVIOUS){
		if(!(currentPoiDtoGroupIndex == 0)){
			PoiDtoGroup *tempGroup = [poiDtoGroups objectAtIndex:(currentPoiDtoGroupIndex - 1)];
			if(tempGroup.vector){
				currentPoiDtoGroupIndex = currentPoiDtoGroupIndex - 1;
				poiDistanceDtos = tempGroup.vector;
				return YES;
			}
		}
	}
		return NO;
	
}
- (void) nullifyPoiDtoGroup{
	if([poiDtoGroups count] > 0){
		//[poiDtoGroups insertObject:nil atIndex:0];
		[poiDtoGroups removeLastObject];
		
		
	}
	
}
-(void)cancelRequest{
	if(adaptor){
		[adaptor cancelRequest];
		[adaptor release];
		adaptor = nil;
	}
}
- (void) dealloc
{
	PoiDtoGroup *poiDtoGroup;
	for(poiDtoGroup in poiDtoGroups){
		if(poiDtoGroup.vector){
			//[poiDtoGroup.vector release];
			
			poiDtoGroup.vector = nil;
			
		}
		[poiDtoGroup release];
		poiDtoGroup = nil;
	}
	[poiDtoGroups release];
	[suggestedKeywords release];
	
	[currentCommand release];
	//if(poiDistanceDtos)
	//[poiDistanceDtos release];
	[super dealloc];
}

@end
