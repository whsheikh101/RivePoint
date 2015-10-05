//
//  ShareViewController.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "OverlayViewController.h"
#import "HTTPSupport.h"

@interface ShareViewController: UIViewController<UITextFieldDelegate, HTTPSupport, UIAlertViewDelegate> {
	IBOutlet UITextField *email;
	IBOutlet UIButton *submit;
	IBOutlet UIButton *reset;
	IBOutlet RivePointAppDelegate *appDelegate;
	HttpTransportAdaptor *httpTransportAdaptor;
	OverlayViewController *ovController;
	NSString *couponId;
	NSString *poiId;
}

@property (nonatomic,retain) NSString *couponId;
@property (nonatomic,retain) NSString *poiId;
-(void) sendCommandExecutionRequest;
-(IBAction) submit;
-(IBAction) reset;
- (IBAction) onClickToChange;
-(void) placeOverlayController;

@end
