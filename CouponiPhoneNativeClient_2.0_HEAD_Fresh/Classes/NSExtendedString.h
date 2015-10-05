//
//  NSExtendedString.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/25/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSExtendedString : NSObject {
	NSString *backingString;
}
- (unsigned int) indexOf:(char) searchChar;
-(NSExtendedString *) initWithString: (NSString *) origString;
-(NSExtendedString *) initWithExtendedString: (NSExtendedString *) origString;
-(NSString *) string;


@end
