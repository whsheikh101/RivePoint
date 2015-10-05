//
//  ReloadCell.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 4/27/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "ReloadCell.h"


@implementation ReloadCell

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
	
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load.png"]];
	self.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load-over.png"]];
	label.text = @"";
	self.selectedBackgroundView = view;
	[view release];
}

- (void)dealloc {
    [label release];
    label = nil;
    [super dealloc];
}


@end

