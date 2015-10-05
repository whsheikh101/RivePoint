//
//  BrowseViewCellController.h
//  RivePoint
//
//  Created by Vajih Khan on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"

@interface BrowseViewCell : UITableViewCell {
	IBOutlet UIImageView *vendorImage;
	IBOutlet UILabel *vendorName;
	RivePointAppDelegate *appDelegate;
	
}
@property (nonatomic, assign) UILabel *vendorName;
@property (nonatomic, assign) UIImageView *vendorImage;

- (void)setCellData:(NSInteger )selectedRow;
- (void)setCellDataForMyCoupons:(NSInteger )selectedRow;
@end
