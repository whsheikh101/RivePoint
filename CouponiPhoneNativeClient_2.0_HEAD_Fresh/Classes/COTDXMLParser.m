//
//  COTDXMLParser.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "COTDXMLParser.h"
#import "XMLUtil.h"

@implementation COTDXMLParser
- (NSMutableArray *)getArray
{
	return items;
}
-(void) setArray{
	[items release];
	items = nil;
	[dictionary release];
	dictionary = nil;
	
}
-(NSMutableDictionary *)getDictionary{
	return dictionary;
}
-(id)parseXMLFromData:(NSData *)xmlResponse parseError:(NSError *)error
{
	
	[items release];
	items = [[NSMutableArray alloc] init];
	dictionary = [[NSMutableDictionary alloc] init];
	
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
	
	if([elementName caseInsensitiveCompare:COMMAND_PARAM_ELEMENT] == NSOrderedSame){
		commandParamName = [attributeDict objectForKey:NAME_ATTRIBUTE];
		currWorkingObjType = -1;
	}

	
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
	
	if(currWorkingObjType == 3 && [elementName caseInsensitiveCompare:PARAM_VALUE_ELEMENT] == NSOrderedSame){
		NSString *tempString = [currentNodeContent copy];
		[dictionary setObject:tempString forKey:[commandParamName copy]];
		[commandParamName release];
		commandParamName = nil;
		currWorkingObjType = -1;
		[tempString release];
	}
	else if(currWorkingObjType == 1 && [elementName caseInsensitiveCompare:@"Vector"] == NSOrderedSame){
		[dictionary setObject:items forKey:[commandParamName copy]];
		[commandParamName release];
		commandParamName = nil;
		currWorkingObjType = -1;
	}
	else if([elementName caseInsensitiveCompare:@"Coupon"] == NSOrderedSame){
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
	
	if([elementName caseInsensitiveCompare:OBJECT_TYPE_ELEMENT] == NSOrderedSame && [currentNodeContent isEqualToString:STRING_BUFFER]){
		currWorkingObjType = 3;
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
