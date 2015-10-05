//
//  RightBarItemController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RightBarButtonItemsController : UIViewController {
	IBOutlet UIButton *nextButton;
	IBOutlet UIButton *prevButton;
}
@property(nonatomic,retain) UIButton *nextButton;
@property(nonatomic,retain) UIButton *prevButton;
@end
