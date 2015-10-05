//
//  CouponPoiXMLParser.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "CouponPoiXMLParser.h"


@implementation CouponPoiXMLParser
- (NSMutableArray *)getArray
{
	return items;
}
-(void) setArray{
	[items release];
	items = nil;
	
}

-(id)parseXMLFromData:(NSData *)xmlResponse parseError:(NSError *)error
{
	if(items)
		[items release];
	items = [[NSMutableArray alloc] init];
	
	currentNodeContent = [[NSMutableString alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlResponse];
	[parser setDelegate:self];
	
	[parser parse];
	
	
	
	[parser release];
	
	return self;
	
	
}
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	
	if([elementName caseInsensitiveCompare:@"Coupon"] == NSOrderedSame){
		if(item)
			[item release];
		item = [[NSClassFromString(@"Coupon") alloc] init];
		currWorkingObjType = 1;
	}else if([elementName caseInsensitiveCompare:@"Poi"] == NSOrderedSame){
		if(poiObject)
			[poiObject release];
		poiObject = [[NSClassFromString(@"Poi") alloc] init];
		currWorkingObjType = 2;
	}
	
	
	if(currentNodeContent)
		[currentNodeContent deleteCharactersInRange:NSMakeRange(0, [currentNodeContent length])];
	if(currentNodeName){
		[currentNodeName release];
		currentNodeName =nil;
	}
	currentNodeName = [elementName copy];
	//NSLog(@"Open tag: %@", elementName);
	
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
	//NSLog(@"Close tag: %@", elementName);
	
	
	if([elementName caseInsensitiveCompare:@"Coupon"] == NSOrderedSame){
		[items addObject:item];
		
		[item release];
		item = nil;
		
	}
	else if([elementName caseInsensitiveCompare:@"Poi"] == NSOrderedSame){
		[item setValue:poiObject forKey:@"poi"];
		
		[poiObject release];
		poiObject = nil;
		currWorkingObjType = 1;
		
	}
	else if(item && currentNodeName && [elementName isEqualToString:currentNodeName] && currWorkingObjType == 1){
		NSString *tempString = [currentNodeContent copy];
		@try{
			
			[item setValue:tempString forKey:elementName];
		}
		@catch (NSException *exception) { 
			NSLog(@"XMLParser: Caught %@: %@ at Element{%@}", [exception name], [exception  reason],elementName);
		}
		[tempString release];
		
	}
	else if(poiObject && currentNodeName && [elementName isEqualToString:currentNodeName] && currWorkingObjType == 2){
		NSString *tempString = [currentNodeContent copy];
		@try{
			
			[poiObject setValue:tempString forKey:elementName];
		}
		@catch (NSException *exception) { 
			NSLog(@"XMLParser: Caught %@: %@ at Element{%@}", [exception name], [exception  reason],elementName);
		}
		[tempString release];
		
	}
	
	
	if(currentNodeName){
		[currentNodeName release];
		currentNodeName =nil;
	}
	
	//[currentNodeContent release];
	
	
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{   
	[currentNodeContent appendString:string];
	//NSLog(@"currentNodeContent after append : %@",currentNodeContent);	
}

- (void)dealloc
{
	
	[currentNodeContent release];
	[items release];
	
	[super dealloc];
}


@end
