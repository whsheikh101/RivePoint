//
//  HttpTransportAdaptor.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/10/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MainView.h"

@interface HttpTransportAdaptor : NSObject {
	NSMutableData *xmlResponse;
	NSObject *callerReference;
	NSURLConnection *connectionRef;
	NSMutableURLRequest *theRequest;
	
}
@property (nonatomic,retain) NSMutableData *xmlResponse;
-(NSData *)sendXMLRequest:(NSString *)xmlRequest referenceOfCaller:(NSObject *)caller ;
-(void)cancelRequest;
-(void) setRefranceToNil;
@end
