//
//  CommandParams.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/16/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommandParam : NSObject {
	NSString *Name;
	NSString *isCollection;
	NSString *collectionType;
	NSString *objectType;
	NSString *paramValue;
	
}
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *isCollection;
@property (nonatomic,retain) NSString *collectionType;
@property (nonatomic,retain) NSString *objectType;
@property (nonatomic,retain) NSString *paramValue;
@end
