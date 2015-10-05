//
//  LocationUpdater.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MainViewController.h"
@class LocationUpdater;

@interface LocationButtonController : UIViewController {
	IBOutlet UIButton *locationButton;
	MainViewController *mvController;
	LocationUpdater *locationUpdater;
}
@property (nonatomic,assign) UIButton *locationButton;

-(IBAction)updateLocation; 
-(void)setReferenceController:(UIViewController *) reference;

 @end
