//
//  FeedbackAlertController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackManager;

@interface FeedbackAlertController : UIViewController {
	IBOutlet UIButton *star1;
	IBOutlet UIButton *star2;
	IBOutlet UIButton *star3;
	IBOutlet UIButton *star4;
	IBOutlet UIButton *star5;
	IBOutlet UIButton *reportButton;
	IBOutlet UILabel *ratingLabel;
	int rate;
	int rateType;
	FeedbackManager *feedbackManager;
}

@property(nonatomic,retain) UIButton *star1;
@property(nonatomic,retain) UIButton *star2;
@property(nonatomic,retain) UIButton *star3;
@property(nonatomic,retain) UIButton *star4;
@property(nonatomic,retain) UIButton *star5;
@property int rate;
@property int rateType;


-(void) setImageRating:(int)rating;
-(void) setFeedbackManagerRef:(FeedbackManager *)fm;
@end
