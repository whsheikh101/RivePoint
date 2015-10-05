//
//  RegisterViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/28/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "XMLUtil.h"
#import "XMLPostRequest.h"

@interface RegisterViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate,UIScrollViewDelegate,XMLPostRequestDelegates,UIAlertViewDelegate>
{
    RivePointAppDelegate * appDelegate;
    
    IBOutlet UIButton * btnMale;
    IBOutlet UIButton * btnFMale;
    IBOutlet UIButton * btnSingle;
    IBOutlet UIButton * btnMarried;
    IBOutlet UIButton * btnUserImage;
    IBOutlet UITextField * tfEmail;
    IBOutlet UITextField * tfPaswrd;
    IBOutlet UITextField * tfName;
    IBOutlet UITextField * tfAddress;
    IBOutlet UITextField * tfOcupation;
    IBOutlet UITextField * tfInterest;
    IBOutlet UIImageView * IVProfile;
    IBOutlet UIScrollView * scrollView;
    BOOL isMale;
    BOOL isFemale;
    BOOL isSingle;
    BOOL isMerrid;
    BOOL isRegistered;
    UIImage * selectedProfileImage;
    IBOutlet UILabel * lblTitle;
    XMLPostRequest * request;
    BOOL isCameraOpen;
    int calledType;
}

@property (nonatomic) BOOL isUserUpdate; 
@property (nonatomic)int calledType;
@property (nonatomic , retain) UIImage * userImage;

-(IBAction) onMaleBtn;
-(IBAction) onFMaleBtn;
-(IBAction) onSingleBtn;
-(IBAction) onMarriedBtn;
-(IBAction) onSubmitBtn;
-(IBAction) onCancelBtn;
-(IBAction) onProfileImageBtn;

@end
