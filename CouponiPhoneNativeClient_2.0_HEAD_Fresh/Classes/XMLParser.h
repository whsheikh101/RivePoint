//
//  XMLParser.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/19/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLParser : NSObject {
	NSMutableArray *items;
	NSObject *item; // stands for any class    
	NSMutableString *currentNodeContent;
	NSString *className;
	NSString *currentNodeName;
	
}
- (NSMutableArray *)getArray;
-(void) setArray;
- (id)parseXMLFromData:(NSData *)xmlResponse className:(NSString *) name
			parseError:(NSError *)error;

@end
