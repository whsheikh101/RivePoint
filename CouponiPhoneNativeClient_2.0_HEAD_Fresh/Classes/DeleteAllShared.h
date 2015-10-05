//
//  DeleteAllShared.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HTTPSupport.h"

@interface DeleteAllShared: NSObject<HTTPSupport,UIAlertViewDelegate> {
	RivePointAppDelegate *appDelegate;
	HttpTransportAdaptor *httpTransportAdaptor;

}

-(void) sendCommandExecutionRequest;
-(void) emptySharedInbox;

@end
