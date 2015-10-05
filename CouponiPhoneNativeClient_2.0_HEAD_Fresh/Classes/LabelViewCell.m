//
//  LabelViewCell.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 5/7/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "LabelViewCell.h"


@implementation LabelViewCell

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
-(void) setLabel:(NSString *)textLabel{
	uiLlabel.text = textLabel;
}

- (void)dealloc {
    [super dealloc];
}


@end
