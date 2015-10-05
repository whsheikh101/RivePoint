//
//  Base64.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/3/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Base64) 

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(unsigned int) lineLength;

@end