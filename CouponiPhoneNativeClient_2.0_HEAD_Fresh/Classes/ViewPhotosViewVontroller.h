//
//  ViewPhotosViewVontroller.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/12/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "Poi.h"
#import "CustomImage.h"
#import "XMLPostRequest.h"
#import "RivePointAppDelegate.h"
#import "PhotoUploadViewController.h"

@interface VenderPhoto : NSObject
{
    NSString * imageUrl;
    UIImage * venderImage;
    BOOL isReqSent;     
}

@property (nonatomic , copy) NSString * imageUrl;
@property (nonatomic , copy) UIImage * venderImage;
@property (nonatomic) BOOL isReqSent; 
@end

@interface ViewPhotosViewVontroller : UIViewController <imageTouchedDelegate , UIImagePickerControllerDelegate,XMLPostRequestDelegates,photoUploadDelegate>
{
    Poi * poi ;
    NSMutableArray * photoDataArray;
    IBOutlet UIScrollView * scrollView;
    IBOutlet CustomImage *  IVFullImage;
    IBOutlet UIView *  fullImageView;
    RivePointAppDelegate * appDelegate;
    BOOL isDisappear;
    XMLPostRequest * postReq;
    PhotoUploadViewController * viewController;
    IBOutlet UIImageView * ratingImageView;
    IBOutlet UIActivityIndicatorView * activityWheel;
    IBOutlet UIImageView * imageGalleryBG;
}

@property (nonatomic , retain) Coupon * coupon;

@property (nonatomic, retain) IBOutlet UILabel * lblVenderName;
@property (nonatomic, retain) IBOutlet UILabel * lblAddressOne;
@property (nonatomic, retain) IBOutlet UILabel * lblAddressTwo;
@property (nonatomic, retain) IBOutlet UIImageView * venderImage;
@property (nonatomic, retain) IBOutlet UIButton * btnUploadPhote;
@property (nonatomic, retain) IBOutlet UIButton * btnPhoneNo;
@property (nonatomic , retain) IBOutlet UILabel * lblReviewCount;
@property (nonatomic , retain) IBOutlet UILabel * lblDistance;


-(IBAction) onPhoneNoClicked;
-(IBAction) onUploadPhotoBtnClicked;

-(IBAction) onImageFullViewCloseClicked;

@end
