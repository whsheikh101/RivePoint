//
//  XMLParser.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser

- (NSMutableArray *)getArray
{
	return items;
}
-(void) setArray{
	items = nil;
	
}

-(id)parseXMLFromData:(NSData *)xmlResponse className:(NSString *) name
		   parseError:(NSError *)error
{
	
	className = [name copy];
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
	
	if([elementName caseInsensitiveCompare:className] == NSOrderedSame){
			if(item)
			[item release];
		item = [[NSClassFromString(className) alloc] init];
		
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
	
	
	if([elementName caseInsensitiveCompare:className] == NSOrderedSame){
		[items addObject:item];
		
		[item release];
		item = nil;

	}
	else if(item && currentNodeName && [elementName isEqualToString:currentNodeName]){
		NSString *tempString = [currentNodeContent copy];
		@try{
			
			[item setValue:tempString forKey:elementName];
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
	[className release];

	/*
	NSLog(@"Retain Count [items=%d], [item=%d], [currentNodeContent=%d], [currentWorkingObject=%d], [paramObjectType=%d], commandParamName=%d",
		  [items retainCount],[item retainCount],[currentNodeContent retainCount],[currentWorkingObject retainCount],
		  [paramObjectType retainCount],[commandParamName retainCount]
		  );*/
	[items release];

	[super dealloc];
}



@end
