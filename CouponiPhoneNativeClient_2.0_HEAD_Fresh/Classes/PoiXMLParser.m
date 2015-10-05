//
//  poiTest.m
//  HelloWorld
//
//  Created by Ahmer Mustafa on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiXMLParser.h"


@implementation PoiXMLParser
- (NSMutableDictionary *)getDictionary
{
	return dictionary;
}

-(id)parseXMLFromData:(NSData *)xmlResponse
		   parseError:(NSError *)error
{
	
	dictionary = [[NSMutableDictionary alloc] init];
	paramObjectType = nil;
	
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
	
	if([elementName isEqualToString:@"commandParam"]){
		
		[commandParamName release];
		commandParamName = [attributeDict objectForKey:@"name"];
		
	} else if(paramObjectType){
		
		
		if([paramObjectType isEqualToString:@"java.lang.StringBuffer"]){
			currentWorkingObject = @"NSString";
			[paramObjectType release];
			paramObjectType = @"NSString";
		}
		else if([paramObjectType  isEqualToString:@"com.netpace.gpsframework.poc.commons.dto.PoiDtoGroup"]){
			currentWorkingObject = @"PoiDtoGroup";
			[paramObjectType release];
			paramObjectType = @"PoiDtoGroup";
		}
		else{
			currentWorkingObject = [paramObjectType copy];	
		}
			
			parentObject  = [[NSClassFromString(paramObjectType) alloc] init];
			
			[paramObjectType release];
			paramObjectType = nil;
		
	} else if([elementName isEqualToString:@"poi"]){
		[currentWorkingObject release];
		currentWorkingObject = @"Poi";
		if(item)
			[item release];
		item = [[NSClassFromString(currentWorkingObject) alloc] init];
		
	}
if(currentNodeContent)
	[currentNodeContent deleteCharactersInRange:NSMakeRange(0, [currentNodeContent length])];
	
	
	//NSLog(@"Open tag: %@", elementName);

}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
	//NSLog(@"Close tag: %@", elementName);
	
	
	if(commandParamName){
		if([elementName isEqualToString:@"objectType"]){
			NSString *tempString = [currentNodeContent copy];

			paramObjectType = [tempString copy];//[[self replaceSpaces:tempString]copy] ;
			[tempString release];
		}
	}
	
	
	if([elementName isEqualToString:@"poi"]){
		[currentWorkingObject release];
		currentWorkingObject = nil;
		[items addObject:item];
		
		[item release];
		item = nil;
	}
	if([elementName isEqualToString:@"vector"]){
		
		@try { 
			[parentObject setValue:items forKey:elementName]; 
		} 
		@catch (NSException *exception) { 
			NSLog(@"PoiXMLParser: Caught %@: %@ at Element{%@}", [exception name], [exception  reason],elementName);
		} 
		
		[currentWorkingObject release];
		currentWorkingObject = @"PoiDtoGroup";
		return;
	}
	if([elementName isEqualToString:@"commandParam"]){
		[dictionary setObject:parentObject forKey:[commandParamName copy]];
		[commandParamName release];
		commandParamName = nil;
		
	}
	if([elementName isEqualToString:@"poiDtoGroup"]){
		[currentWorkingObject release];
		currentWorkingObject = nil;
	}
		
	if(currentWorkingObject){	
		if([currentWorkingObject isEqualToString:@"PoiDtoGroup"]){
		
			NSString *tempString = [currentNodeContent copy];
			NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			@try { 
				[parentObject setValue:trimmedString forKey:elementName]; 
			} 
			@catch (NSException *exception) { 
				NSLog(@"PoiXMLParser: Caught %@: %@ at Element{%@}", [exception name], [exception  reason],elementName);
			} 
			
			//[trimmedString release];
			[tempString release];
		
	}else if([currentWorkingObject isEqualToString:@"Poi"]){
		NSString *tempString2 = [currentNodeContent copy];
		NSString *trimmedString2 = [tempString2 stringByTrimmingCharactersInSet:
								   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		@try { 
			[item setValue:trimmedString2 forKey:elementName]; 
		} 
		@catch (NSException *exception) { 
			NSLog(@"PoiXMLParser: Caught %@: %@ at Element{%@}", [exception name], [exception  reason],elementName);
		} 
		
		
		[tempString2 release];
		//[trimmedString release];

	}else if([currentWorkingObject isEqualToString:@"NSString"]){
		NSString *tempString = [currentNodeContent copy];
		NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:
								   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		parentObject = [trimmedString copy];
		[tempString release];
		[trimmedString release];
	}

}

		//[currentNodeContent release];
	

}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{   
	[currentNodeContent appendString:string];
	//NSLog(@"currentNodeContent after append : %@",currentNodeContent);	
}
			
-(NSString *) replaceSpaces:(NSString *) string{
				
	NSString *trimmedString = [string stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *tempString =[trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	[trimmedString release];
	trimmedString = [tempString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	[tempString release];
				return trimmedString;
}

- (void)dealloc
{
	
	[currentNodeContent release];
	[currentWorkingObject release];
	
	/*NSLog(@"Retain Count [items=%d], [item=%d], [currentNodeContent=%d], [currentWorkingObject=%d], [paramObjectType=%d], commandParamName=%d",
		  [items retainCount],[item retainCount],[currentNodeContent retainCount],[currentWorkingObject retainCount],
	[paramObjectType retainCount],[commandParamName retainCount]
	);*/
	[items release];
	[dictionary release];
	[super dealloc];
}



@end
