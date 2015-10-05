//
//  coordinates.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/10/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface coordinates : NSObject {
	NSString *altitude;
	NSString *latitude;
	NSString *longitude;
}
@property (nonatomic, retain) NSString *altitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@end
