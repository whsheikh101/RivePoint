//
//  COTDXMLParser.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/17/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COTDXMLParser : NSObject {
	NSMutableArray *items;
	NSObject *item; // stands for any class    
	NSMutableString *currentNodeContent;
	NSString *currentNodeName;
	NSObject *poiObject;
	int currWorkingObjType;
	
	NSString *commandParamName;
	NSMutableDictionary *dictionary;
	
}
- (NSMutableArray *)getArray;
-(NSMutableDictionary *)getDictionary;
-(void) setArray;
-(id)parseXMLFromData:(NSData *)xmlResponse parseError:(NSError *)error;

@end
