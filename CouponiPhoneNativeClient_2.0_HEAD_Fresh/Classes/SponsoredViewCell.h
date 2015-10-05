//
//  SponsoredViewCell.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 5/7/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poi.h"
#import "RivepointConstants.h"

@interface SponsoredViewCell : UITableViewCell {
	IBOutlet UIImageView *bannerImageView;
	Poi *currPoi;
}
@property (nonatomic,retain) IBOutlet UIImageView *bannerImageView;
-(void) setBanner:(Poi *)poi;
-(void) setPoi:(Poi *)poi;
@end
