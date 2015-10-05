//
//  LoginViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/28/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "RivepointConstants.h"
#import "XMLUtil.h"
#import "XMLPostRequest.h"

@protocol UserLoginDelegates <NSObject>
@optional

-(void) userLoggedinSuccessfully;

@end

@interface LoginViewController : UIViewController<XMLPostRequestDelegates>
{
    RivePointAppDelegate * appDelegate;
    IBOutlet UITextField * tfEmail;
    IBOutlet UITextField * tfPaswrd;
    id<UserLoginDelegates>delegate;
    int CalledType;
    IBOutlet UIToolbar * toolBar;
}

@property (nonatomic , retain)id<UserLoginDelegates>delegate;
@property (nonatomic) int CalledType;

-(IBAction) onLoginBtn;
-(IBAction) onCancelBtn;
-(IBAction) onRegisterBtn;

@end
