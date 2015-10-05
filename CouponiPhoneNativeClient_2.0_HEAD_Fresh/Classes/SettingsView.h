#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RivePointAppDelegate.h"
#import "HttpTransportAdaptor.h"
#import "HTTPSupport.h"
#import "OverlayViewController.h"
@class LocationUpdater;

@interface SettingsView : UIImageView <UITextFieldDelegate, HTTPSupport>{
    IBOutlet UILabel *geoCode;
    IBOutlet UISlider *gpsAccuracy;
    IBOutlet UITextField *zipCode;
    IBOutlet UISwitch *gpsSwitch;
	IBOutlet UILabel *gpsAccuracyLabel;
	IBOutlet RivePointAppDelegate *appDelegate;
    IBOutlet UITextField *email;
//	IBOutlet UIBarButtonItem *cancelBarButtonItem;
	IBOutlet UIButton *update;
	HttpTransportAdaptor *httpTransportAdaptor;
	OverlayViewController *overlayViewController ;
	LocationUpdater *locationUpdator;
	
}

//@property (nonatomic, retain)IBOutlet UIBarButtonItem *cancelBarButtonItem;
//@property (nonatomic, retain) IBOutlet RivePointAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UILabel *geoCode;
@property (nonatomic, retain) OverlayViewController *overlayViewController;

- (IBAction)GPSAccuracyChanged;
- (IBAction)isGPSEnabled;
- (IBAction)zipCodeChanged;
- (IBAction) updateGpsLocation;
- (void)initializeComponents;
-(void) refreshRecords;

@end
