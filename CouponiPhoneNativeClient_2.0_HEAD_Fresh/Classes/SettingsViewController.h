//
//  SettingsViewController.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/11/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "CommandUtil.h"
#import "HttpTransportAdaptor.h"
#import "XMLParser.h"
#import "HTTPSupport.h"
#import "OverlayViewController.h"
#import "SA_OAuthTwitterController.h"
@class MapViewController;

@interface SettingsViewController : UIViewController <UIAlertViewDelegate,HTTPSupport,SA_OAuthTwitterControllerDelegate,FBDialogDelegate> {
    IBOutlet UITextField *zipCode;
	IBOutlet RivePointAppDelegate *appDelegate;
//	IBOutlet UIBarButtonItem *cancelBarButtonItem;
//	IBOutlet UITextField *emailTextField;
	HttpTransportAdaptor *adaptor;
	OverlayViewController *ovController ;
	MapViewController *mapViewController;
    IBOutlet UIButton * btnFB;
    IBOutlet UIButton * btnTwtr;
    IBOutlet UIButton * btnEmail;
    IBOutlet UIScrollView * bgScrollView;
    IBOutlet UIButton * logoutBtn;
}

- (IBAction) zipCodeChanged:(id) sender;
- (IBAction) onClickToChange;
- (IBAction) onClickCancelButton;
- (void)showInvalidZipAlert;
- (void) getGeoCodeAddress:(NSString*)newZip;
- (void)hideOverlay;
- (void) removeOverlay;
- (void) placeOverlayController;
- (void)resetCachedObjects;
- (IBAction) showCurrentLocation;

-(IBAction) onFacebookBtn:(id)sender;
-(IBAction) onTwitterBtn:(id)sender;
-(IBAction) onEmailBtn:(id)sender;
-(IBAction) onLogOutBtn:(id)sender;

@end
