//
//  ShareIt.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "HTTPSupport.h"
#import "StringUtil.h"

@interface ShareIt: NSObject<UITextFieldDelegate,HTTPSupport, UIAlertViewDelegate> {
	RivePointAppDelegate *appDelegate;
	HttpTransportAdaptor *httpTransportAdaptor;
	NSString *couponId;
	NSString *poiId;
	UITextField *email;
	UIAlertView *alertViewDialog;
}

@property (nonatomic,retain) NSString *couponId;
@property (nonatomic,retain) NSString *poiId;
-(void) sendCommandExecutionRequest;
-(void) submit;
-(void) reset;
-(void)showShareDialog:(NSString *)errorText;

@end
