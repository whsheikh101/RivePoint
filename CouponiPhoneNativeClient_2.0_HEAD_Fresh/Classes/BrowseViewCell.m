//
//  BrowseViewCellController.m
//  RivePoint
//
//  Created by Vajih Khan on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewCell.h"


@implementation BrowseViewCell
@synthesize vendorName;
@synthesize vendorImage;



- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    
[vendorName release];
[vendorImage release];
    vendorName = nil;
    vendorImage = nil;
    [super dealloc];

}

- (void)setCellData:(NSInteger )selectedRow{
//	NSArray *categoryNames = [[NSArray alloc] initWithObjects:@"Coffee",@"American",@"Chinese",@"Italian", @"Fast Food", @"Mexican",@"Snacks", nil];
//	NSArray *categoryIcons = [[NSArray alloc] initWithObjects:@"coffee.png",@"american.png",@"chinese.png",@"Italian.png",@"fasfood.png",@"mexican.png",@"snacks.png", nil];
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];

	vendorName.text = [appDelegate.categoryNames objectAtIndex:selectedRow];
	vendorImage.image = [UIImage imageNamed:[appDelegate.categoryIcons objectAtIndex:selectedRow]];
	self.backgroundColor = [UIColor clearColor];
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod.png"]];
	self.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod_ov.png"]];
	self.selectedBackgroundView = view;
	[view release]; 
}
- (void)setCellDataForMyCoupons:(NSInteger )selectedRow{
	//	NSArray *categoryNames = [[NSArray alloc] initWithObjects:@"Coffee",@"American",@"Chinese",@"Italian", @"Fast Food", @"Mexican",@"Snacks", nil];
	//	NSArray *categoryIcons = [[NSArray alloc] initWithObjects:@"coffee.png",@"american.png",@"chinese.png",@"Italian.png",@"fasfood.png",@"mexican.png",@"snacks.png", nil];
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	vendorName.text = [appDelegate.optionNames objectAtIndex:selectedRow];
	vendorImage.image = [UIImage imageNamed:[appDelegate.optionIcons objectAtIndex:selectedRow]];
	self.backgroundColor = [UIColor clearColor];
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod.png"]];
	self.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_no_pod_ov.png"]];
	self.selectedBackgroundView = view;
	[view release]; 
}
@end
