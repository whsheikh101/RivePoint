//
//  MoreViewCell.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/31/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import "MoreViewCell.h"


@implementation MoreViewCell

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

-(void)setBackgroundImages{
	self.backgroundColor = [UIColor clearColor];
	
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more-bar.png"]];
	self.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more-bar-ov.png"]];
	self.selectedBackgroundView = view;
	[view release];
}

@end
