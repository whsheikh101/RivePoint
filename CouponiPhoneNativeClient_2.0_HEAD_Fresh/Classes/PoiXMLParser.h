//
//  poiTest.h
//  HelloWorld
//
//  Created by Ahmer Mustafa on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PoiXMLParser : NSObject {
	NSMutableArray *items;
	NSObject *item; // stands for any class    
	NSMutableString *currentNodeContent;
	
	
	NSString *currentWorkingObject;
	NSObject *parentObject;
	NSString *paramObjectType;
	NSString *commandParamName;
	NSMutableDictionary *dictionary;
}
- (NSMutableDictionary *)getDictionary;
- (id)parseXMLFromData:(NSData *)xmlResponse
			parseError:(NSError *)error;
@end
