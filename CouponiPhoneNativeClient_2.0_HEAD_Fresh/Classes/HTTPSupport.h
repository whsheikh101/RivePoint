//
//  HTTPSupport.h
//  RivePoint
//
//  Created by Shahzad Mughal on 3/2/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTransportAdaptor.h"

@protocol HTTPSupport 

@required
-(void) processHttpResponse:(NSData *) response;
@required
-(void)communicationError:(NSString *)errorMsg;

@end
