//
//  HttpTransportAdaptor.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/10/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "HttpTransportAdaptor.h"
//#import "MainView.h"
#import "PoiFinderNew.h"
#import "RivepointConstants.h"
#import "RivePointAppDelegate.h"

@implementation HttpTransportAdaptor


@synthesize xmlResponse;

-(NSData *)sendXMLRequest:(NSString *)xmlRequest referenceOfCaller:(NSObject *)caller {
	//Reading URL from the text file
	
	NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *urlFileName = @"url";
	NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
	NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
    NSLog(@"%@",prefixURL);
//	NSLog(prefixURL);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",prefixURL,RIVEPOINT_MAIN_SERVLET]];
	NSString *requestParamterForServer = [NSString stringWithFormat:@"%@%@",GPS_FRAMEWORK_PAYLOAD,xmlRequest ];
	theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:CONNECTION_TIME_OUT];	
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [xmlRequest length]];
	[theRequest addValue: CONTENT_TYPE_VALUE forHTTPHeaderField:CONTENT_TYPE];
	[theRequest addValue: msgLength forHTTPHeaderField:CONTENT_LENGTH];
	[theRequest setHTTPMethod: HTTP_METHOD];
	[theRequest setHTTPBody: [requestParamterForServer dataUsingEncoding:NSUTF8StringEncoding]];
	//NSLog(requestParamterForServer);

	callerReference = caller;
	if(connectionRef)
		[connectionRef release];
	connectionRef = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( connectionRef )
	{
		 self.xmlResponse = [NSMutableData data];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
	
	return nil;
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	
		int statusCode = [ response statusCode ];
		if (statusCode == 200)
		{
			[xmlResponse setLength: 0];
		}else {
			[self cancelRequest];
			[((PoiFinderNew *)callerReference) communicationError:@""];
		}
		
	
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[xmlResponse appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
	
	[connection release];
	[xmlResponse release];
	//callerReference = (PoiFinder *)callerReference;
	[((PoiFinderNew *) callerReference) communicationError:error.localizedDescription];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	[connection release];
	connectionRef = nil;
	if([xmlResponse length] != 0){
		
//		NSString *aStr = [[[NSString alloc] initWithData:xmlResponse encoding:NSASCIIStringEncoding]autorelease];
//		NSLog(@"%@",aStr);
		/*NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
		[NSURLCache setSharedURLCache:sharedCache];
		[sharedCache release];*/
		[((PoiFinderNew *) callerReference) processHttpResponse:xmlResponse];
        
	}
	else
	{
		[((PoiFinderNew *)callerReference) communicationError:@""];
		[xmlResponse release];
	}
}
-(void)cancelRequest{
	
	if(connectionRef){
		[connectionRef cancel];
		[connectionRef release];
		if(xmlResponse)
			[xmlResponse release];
	}
}
- (void) dealloc
{
	
	[super dealloc];
}

-(void) setRefranceToNil
{
    callerReference = nil;
}

@end
