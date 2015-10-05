//
//  CouponViewCell.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poi.h"
@class RivePointAppDelegate;
@interface VendorViewCell : UITableViewCell {

	
	IBOutlet UILabel *vendorLabel;
	IBOutlet UILabel *addressLabel;
	IBOutlet UILabel *milesLabel;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UILabel *countLabel;
	IBOutlet UIImageView *menuPod;
	
	IBOutlet UIImageView *couponCountImage;
	IBOutlet UIImageView *vendorLogo;
    IBOutlet UIImageView * ratingImageView;
	NSString *phoneNo;
	NSString *mapURL;
	NSString *command;
	
	
	Poi *poiRef;
	NSString *poiId;
	NSString *poiName;
	RivePointAppDelegate *appDelegate;

}

@property (nonatomic , retain) IBOutlet UILabel * reviewCountLbl;

-(void) setPoiContent:(Poi *) poi;
-(IBAction)phoneClick;
-(IBAction)mapClick;
-(void)setBackGroundWithPod;
-(void)setBackGround;
-(void) showDistanceLabel:(Poi *) poi;

@property (nonatomic,retain) NSString *poiName;
@property (nonatomic,retain) NSString *poiId;
@property (nonatomic,retain) NSString *phoneNo;
@property (nonatomic,retain) NSString *mapURL;
@property (nonatomic,retain) NSString *command;

@end
