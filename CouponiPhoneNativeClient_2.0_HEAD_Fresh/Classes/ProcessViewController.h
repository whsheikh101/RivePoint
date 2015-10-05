//
//  ProcessViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 Netpace Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HTTPSupport.h"
#import "HttpTransportAdaptor.h"
#import "User.h"

@interface ProcessViewController : UIViewController<HTTPSupport,UIAlertViewDelegate> {
	IBOutlet RivePointAppDelegate *appDelegate;
	HttpTransportAdaptor *httpTransportAdaptor;
	User *user;
}

@property (nonatomic,retain) User *user;
-(void)sendCommandExecutionRequest;
@end
