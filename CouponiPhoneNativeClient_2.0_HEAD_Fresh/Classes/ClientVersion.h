//
//  ClientVersion.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/20/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClientVersion : NSObject {
	NSString *vendor;
	NSString *version;
	NSString *clientType;
}
@property (nonatomic,retain) NSString *vendor;
@property (nonatomic,retain) NSString *version;
@property (nonatomic,retain) NSString *clientType;
@end
