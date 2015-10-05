//
//  SocialSettingViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/13/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "SA_OAuthTwitterController.h"

@interface SocialSettingViewController : UIViewController<SA_OAuthTwitterControllerDelegate>
{
    RivePointAppDelegate * appDelegate;
}

@property (nonatomic , retain) IBOutlet UISwitch * fbSwitch;
@property (nonatomic , retain) IBOutlet UISwitch * twSwitch;
@property (nonatomic , retain) IBOutlet UISwitch * emSwitch;

-(IBAction) onFBSwitchChangeValue;
-(IBAction) onTWSwitchChangeValue;
-(IBAction) onEMSwitchChangeValue;
@end
