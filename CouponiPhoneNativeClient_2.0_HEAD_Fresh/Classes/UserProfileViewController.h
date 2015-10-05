//
//  UserProfileViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/13/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImage.h"
#import "XMLPostRequest.h"
#import "XMLUtil.h"
#import "RivePointAppDelegate.h"
#import "LoginViewController.h"
#import "ViewAllCouponViewController.h"

@interface UserPhotos : NSObject {

    
}

@property (nonatomic , retain) NSString * imageUrl;
@property (nonatomic , retain) UIImage * shareImage;
@property (nonatomic) BOOL isReqSent; 
@end


@interface UserProfileViewController : UIViewController<imageTouchedDelegate,UITextFieldDelegate,XMLPostRequestDelegates,UserLoginDelegates,UIAlertViewDelegate,ViewAllCouponDelegate>
{
    NSMutableArray * userSavedCoupenArray;
    NSMutableArray * userFavCouponArray;
    NSMutableArray * userSharePhotoArray;
    NSMutableArray * userSharedCouponArray;
    IBOutlet UIButton * editBtn;
    BOOL isEditMode;
    RivePointAppDelegate * appDelegate;
    IBOutlet UIImageView * IVUserProfile;
    int callCount;
    
    IBOutlet UIView * fullImageView;
    IBOutlet CustomImage * IVFullImage;
    
    
    BOOL isSaved;
    BOOL isShared;
    UITextField * tfPassword;
    BOOL isDetailCalled;
    BOOL isLoginNow;
    XMLPostRequest * fetchRequest;
    BOOL isEditProfile;
    IBOutlet UIActivityIndicatorView * activityWheel;
    
}

@property (nonatomic, retain) UIImage * profileImage;
@property (nonatomic , retain) Coupon * curSelectedCoupon;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserName;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserStatus;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserAddress;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserDesign;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserIntersetOne;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserIntersetTWo;
@property (nonatomic ,retain) IBOutlet UILabel * lblUserEmail;
@property (nonatomic ,retain) IBOutlet UITableView * tableView;
//@property (nonatomic ,retain) IBOutlet UITextField * tfUserName;
//@property (nonatomic ,retain) IBOutlet UITextField * tfUserStauts;
//@property (nonatomic ,retain) IBOutlet UITextField * tfUserDesign;
//@property (nonatomic ,retain) IBOutlet UITextField * tfUserAddress;
//@property (nonatomic ,retain) IBOutlet UITextView * tfUserInterset;
@property (nonatomic , retain) IBOutlet UIView * userInfoView;
@property (nonatomic ,retain) IBOutlet UIScrollView * screenScrollView;

@property (nonatomic ,retain) IBOutlet UILabel * lblSaveCopCount;
@property (nonatomic ,retain) IBOutlet UILabel * lblFavCopCount;
@property (nonatomic ,retain) IBOutlet UILabel * lblShareCopCount;

-(IBAction) onEditBtn;
-(IBAction) onSaveBtn;
-(IBAction) onCloseBtn;

//-(IBAction) onFetchUserImage;

-(IBAction) onSaveCouponDeleteAll;
-(IBAction) onSaveCouponViewAll;

-(IBAction) onShareCouponDeleteAll;
-(IBAction) onShareCouponViewAll;

-(IBAction) onFavCouponDeleteAll;
-(IBAction) onFavCouponViewAll;

-(IBAction) onCouponPhotosViewAll;

-(IBAction) onFullImageCloseClick;


-(void)fetchFavouritePois;
-(void) fetchSharedAndSendCoupons;
-(void) fetchUserSharedPoiImages;



@end
