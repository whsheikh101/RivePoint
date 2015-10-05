//
//  MapButtonController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/24/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapViewController;
@class MainViewController;

@interface MapButtonController : UIViewController {
	IBOutlet UIButton *mapButton;
	MapViewController *mapViewController;
	MainViewController *mvController;

}

-(IBAction)mapAllPois;
-(void)setReferenceController:(UIViewController *) reference;

@end
