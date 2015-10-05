//
//  FeedbackManager.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/2/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "HTTPSupport.h"
#import "Coupon.h"
#import "FeedbackAlertController.h"

@interface FeedbackManager: NSObject<HTTPSupport, UIAlertViewDelegate> {
	IBOutlet RivePointAppDelegate *appDelegate;
	int rate;
	int ratingType;
	HttpTransportAdaptor *httpTransportAdaptor;
	Coupon *coupon;
	Poi *poi;
	FeedbackAlertController *feedbackViewControl;
	UIAlertView *theAlert;
}
@property (nonatomic,retain) Coupon *coupon;
@property (nonatomic,retain) Poi *poi;
-(void) sendCommandExecutionRequest:(NSString *)feedbackType rating:(NSString *)rating;
-(void) setCoupon:(Coupon *)theCoupon;
-(void) setPoi:(Poi *)thePoi;
-(void)showFeedbackAlert;

@end
