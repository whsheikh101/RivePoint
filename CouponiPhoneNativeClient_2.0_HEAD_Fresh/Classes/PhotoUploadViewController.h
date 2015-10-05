//
//  PhotoUploadViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/12/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLPostRequest.h"
#import "RivePointAppDelegate.h"
#import "Poi.h"
#import "SA_OAuthTwitterController.h"

@protocol photoUploadDelegate <NSObject>

-(void) photoUploadedWithPhotoId:(NSString *)photoID;

@end


@interface PhotoUploadViewController : UIViewController<XMLPostRequestDelegates,UIAlertViewDelegate,SA_OAuthTwitterControllerDelegate,FBRequestDelegate>
{
    BOOL isCaptionBlank;
    NSString * imageUrl;
    int currentUploadBytes;
    int totalBytes;
    RivePointAppDelegate * appDelegate;
    BOOL isFacebook;
    BOOL isTwitter;
    BOOL isEmail;
    UITextField * tfEmail;
    IBOutlet UILabel * lblFBStatus;
    IBOutlet UILabel * lblTWStatus;
    IBOutlet UILabel * lblMailStatus;
    id<photoUploadDelegate>delegate;
    int callCount;
    XMLPostRequest * request;

}

@property (nonatomic , retain)id<photoUploadDelegate>delegate;
//@property (nonatomic , retain) UIImage * image;
@property (nonatomic , retain) NSData * imageData;
@property (nonatomic  ,copy) NSString * curImageID;
@property (nonatomic , retain)Poi * curPOI;
@property (nonatomic , copy) NSString * curEmailForShare;

@property (nonatomic , retain) IBOutlet UIImageView * pickedImage;
@property (nonatomic , retain) IBOutlet UIImageView * shareViewBGImage;
@property (nonatomic , retain) IBOutlet UIButton * uploadBtn;
@property (nonatomic , retain) IBOutlet UIButton * facebookBtn;
@property (nonatomic , retain) IBOutlet UIButton * twitterBtn;
@property (nonatomic , retain) IBOutlet UIButton * emailBtn;
@property (nonatomic , retain) IBOutlet UIButton * shareBtn;
@property (nonatomic , retain) IBOutlet UITextView * captionText;
@property (nonatomic , retain) IBOutlet UILabel * lblShare;
@property (nonatomic , retain) IBOutlet UILabel * lblFacebook;
@property (nonatomic , retain) IBOutlet UILabel * lblTwitter;
@property (nonatomic , retain) IBOutlet UILabel * lblEmail;


-(IBAction) onUplaodBtn;
-(IBAction) onFacebookBtn;
-(IBAction) onTwitterBtn;
-(IBAction) onEmailBtn;
-(void) UploadImageToServer;
-(IBAction) onShareBtn;

@end
