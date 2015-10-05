//
//  EmailView.h
//  RivePoint
//
//  Created by Shahzad Mughal on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "HTTPSupport.h"

@class ShareIt;

@interface EmailViewController: UIViewController<UITextFieldDelegate, HTTPSupport, UIAlertViewDelegate> {
	IBOutlet UITextField *email;
	IBOutlet UIButton *submit;
	IBOutlet UIButton *reset;
    IBOutlet UIButton *cancelButton;
	IBOutlet RivePointAppDelegate *appDelegate;
	HttpTransportAdaptor *httpTransportAdaptor;
    ShareIt *shareIt; 
    
}

@property (nonatomic,assign) ShareIt *shareIt;

-(void) sendCommandExecutionRequest;
-(IBAction) submit;
-(IBAction) reset;
-(IBAction) cancel;

@end
