//
//  LabelViewCell.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 5/7/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelViewCell : UITableViewCell {
	IBOutlet UILabel *uiLlabel;
}
-(void) setLabel:(NSString *)textLabel;
@end
