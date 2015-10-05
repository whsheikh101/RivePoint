//
//  ReviewRatingViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/11/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poi.h"
#import "Coupon.h"
#import "RivePointAppDelegate.h"
#import "HTTPSupport.h"
#import "HttpTransportAdaptor.h"
#import "XMLPostRequest.h"
#import "PhotoUploadViewController.h"

@protocol ReviewAddedDelegate <NSObject>

-(void) userAddedNewReview;

@end

@interface ReviewRatingViewController : UIViewController<HTTPSupport, UIImagePickerControllerDelegate,UIScrollViewDelegate,XMLPostRequestDelegates,photoUploadDelegate>
{
    Poi * poi;
    RivePointAppDelegate * appDelegate;
    NSMutableArray * commentArray;
    BOOL isWantComment;
    int yourRating;
    BOOL shouldResign;
    IBOutlet UIImageView * textViewBg;
    IBOutlet UIImageView * reviewBG;
    
    id<ReviewAddedDelegate>delegate;
    
    IBOutlet UILabel * lblReviewCount;
    IBOutlet UILabel * lblDistance;
    BOOL isContentSizeChange;
    XMLPostRequest * request;
    IBOutlet UIImageView * ratingImageView;
    BOOL isDisappear;
}

@property (nonatomic , retain) Coupon * coupon;
@property (nonatomic , retain)id<ReviewAddedDelegate>delegate;
@property (nonatomic, retain) IBOutlet UILabel * lblVenderName;
@property (nonatomic, retain) IBOutlet UILabel * lblAddressOne;
@property (nonatomic, retain) IBOutlet UILabel * lblAddressTwo;
@property (nonatomic, retain) IBOutlet UIImageView * venderImage;
@property (nonatomic, retain) IBOutlet UIButton * btnUploadPhote;
@property (nonatomic, retain) IBOutlet UIButton * btnPhoneNo;
//@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UIButton * btnSave;
@property (nonatomic , retain) IBOutlet UITextView * commentField;
@property (nonatomic, retain) IBOutlet UIButton * star1;
@property (nonatomic, retain) IBOutlet UIButton * star2;
@property (nonatomic, retain) IBOutlet UIButton * star3;
@property (nonatomic, retain) IBOutlet UIButton * star4;
@property (nonatomic, retain) IBOutlet UIButton * star5;
@property (nonatomic , retain) IBOutlet UIScrollView * scrollView;

-(IBAction) onPhoneNoBtnClicked;
-(IBAction) onPhotoUploadBtnClicked;
-(IBAction) onCommentSaveBtn;

-(IBAction) onOneStar;
-(IBAction) onTwoStar;
-(IBAction) onThreeStar;
-(IBAction) onFourStar;
-(IBAction) onFiveStar;


@end
