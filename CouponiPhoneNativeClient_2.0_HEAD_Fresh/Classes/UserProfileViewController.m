//
//  UserProfileViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/13/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#define k_IMAGE1 963
#define k_IMAGE2 852
#define k_IMAGE3 741
#define k_BTN1 789
#define k_BTN2 456
#define k_BTN3 123

#define k_Favorite 1010
#define k_Saved 2020
#define k_Shared 3030
#define k_Edit_profile 9942
#define k_UserFav 777
#define k_UserSave 555
#define k_Sub_View_Tag 31313
#define k_Reload_Retry 5124


#define k_Image_Btn_Tag 111
#define k_CustomView_Tag 81846

#define k_IMAGE_URL @"http://sphotos-c.ak.fbcdn.net/hphotos-ak-ash4/217459_1891742088829_1216417_n.jpg"

#import "UserProfileViewController.h"
#import "GeneralUtil.h"
#import "FavoritePoiUtils.h"
#import "Poi.h"
#import "Coupon.h"
#import "CouponManager.h"
#import "RivePointSetting.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "ListCouponsViewController.h"
#import "CouponDetailManager.h"
#import "CouponViewController.h"
#import "ViewAllPhotosViewController.h"
#import "AllPhotosViewController.h"
#import "RegisterViewController.h"

@implementation UserPhotos
@synthesize shareImage,imageUrl,isReqSent;

-(void) dealloc
{
    [imageUrl release];
    [shareImage release];
    
    imageUrl = nil;
    shareImage = nil;
}

@end



@implementation UserProfileViewController
@synthesize lblUserName,lblUserDesign,lblUserStatus,lblUserAddress,lblUserIntersetOne,lblUserIntersetTWo,lblUserEmail;
@synthesize tableView,userInfoView;
//@synthesize tfUserName,tfUserDesign,tfUserStauts,tfUserAddress,tfUserInterset;
@synthesize screenScrollView;
@synthesize lblFavCopCount,lblSaveCopCount,lblShareCopCount;
@synthesize curSelectedCoupon = _curSelectedCoupon;
@synthesize profileImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Profile";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"User Profile View Controller - Receive Memory Warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    [lblUserAddress  release];
    [lblUserDesign  release];
    [lblUserIntersetOne  release];
    [lblUserIntersetTWo  release];
    [lblUserName  release];
    [lblUserStatus  release];
    [lblUserEmail  release];
    [tableView  release];
    [userInfoView  release];
    [screenScrollView release];
    
    lblUserAddress = nil;
    lblUserDesign = nil;
    lblUserIntersetOne = nil;
    lblUserIntersetTWo = nil;
    lblUserName = nil;
    lblUserStatus = nil;
    lblUserEmail = nil;
    tableView = nil;
    userInfoView = nil;
    screenScrollView = nil;
    [_curSelectedCoupon release];
    if (userSavedCoupenArray) {
        [userSavedCoupenArray release];
    }
    if (userFavCouponArray)
    {
        [userFavCouponArray release];
    }
    if (userSharePhotoArray) {
        [userSharePhotoArray release];
    }
    if (userSharedCouponArray) {
        [userSharedCouponArray release];
    }
    [super dealloc];
}


-(void) removeLoadingIcon
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate.progressHud removeFromSuperview];
}

-(void) hideLoadingIcon
{
    callCount++;
    if (callCount == 4 || callCount > 4) {
        [self performSelector:@selector(removeLoadingIcon) withObject:nil afterDelay:4.0];
    }
}

-(void) internetConnectionNotFoundForUserProfile
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Internet connection appears to be offline!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    alert.tag = k_Reload_Retry;
    [alert show];
    [alert release];
}


-(void) clickToFavPoi:(id)sender
{
    NSLog(@"clickToFavPoi  : In");
    UIButton * _btn = (UIButton *)sender;
    int _index = _btn.tag-k_BTN1;
    
    Poi * _curPOI = [userFavCouponArray objectAtIndex:_index];
//    [appDelegate.poiArray addObject:_curPOI];
    if (_curPOI) {
        appDelegate.loadFromPersistantStore = NO;
        if (appDelegate.poi) {
            [appDelegate.poi release];
        }
        if (appDelegate.couponArray) {
            [appDelegate.couponArray removeAllObjects];
            appDelegate.couponArray = nil;
        }
        appDelegate.currentPoiCommand = 7;
        appDelegate.poi = [_curPOI retain];
        isDetailCalled = YES;
        self.title = @"Profile";
        ListCouponsViewController * viewController = [[ListCouponsViewController alloc]initWithNibName:@"ListCouponsView" bundle:nil];
        viewController.isFavoritePOI = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
         NSLog(@"clickToFavPoi Poi Found   Out");
    }
}

-(void) clickToSavedCop:(id)sender
{
    NSLog(@"clickToSavedCop In");
    UIButton * _btn = (UIButton *)sender;
    int _index = _btn.tag-k_BTN2;
    Coupon * _curCoup = [userSavedCoupenArray objectAtIndex:_index];
    if (_curCoup) {
        NSLog(@"Coupon Found...!!");
        _curSelectedCoupon = _curCoup;
        isSaved = YES;
        isShared = NO;
        CouponDetailManager * _manager = [[CouponDetailManager alloc]init];
        [_manager showDetailAlertForSavedAndShared:_curCoup.poi coupon:_curCoup andDelegate:self];
        [_manager release];
    }
    NSLog(@"clickToSavedCop Out");
}

-(void) clickedToSharedCop:(id) sender
{
    NSLog(@"clickedToSharedCop In");
    UIButton * _btn = (UIButton *)sender;
    int _index = _btn.tag-k_BTN3;
    Coupon * _curCoup = [userSharedCouponArray objectAtIndex:_index];
    if (_curCoup) {
         NSLog(@"Coupon Found...!!");
        _curSelectedCoupon = _curCoup;
        isSaved = NO;
        isShared = YES;
        CouponDetailManager * _manager = [[CouponDetailManager alloc]init];
        [_manager showDetailAlertForSavedAndShared:_curCoup.poi coupon:_curCoup andDelegate:self];
        [_manager release];
    }
    NSLog(@"clickedToSharedCop Out");
}

-(void) showFavoritePoiONScreen
{
    if (userFavCouponArray.count > 0)
    {

        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 483, 200, 30)];
        btn1.tag = k_BTN1 + 0;
        [btn1 addTarget:self action:@selector(clickToFavPoi:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn1];
        [btn1 release];
        
        UILabel * lblTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 483, 200, 30)];
        lblTitle1.tag = k_Favorite;
        lblTitle1.backgroundColor = [UIColor clearColor];
        lblTitle1.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle1.textColor = [UIColor blackColor];
        Poi * _poi1 = [userFavCouponArray objectAtIndex:0];
        lblTitle1.text = _poi1.name;
        [screenScrollView addSubview:lblTitle1];
        [lblTitle1 release];
        
        UILabel * lblExpDate1 = [[UILabel alloc]initWithFrame:CGRectMake(224, 483, 105, 30)];
        lblExpDate1.tag = k_Favorite;
        lblExpDate1.backgroundColor = [UIColor clearColor];
        lblExpDate1.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate1.textColor = [UIColor blackColor];
        lblExpDate1.text = [NSString stringWithFormat:@"%@ MILES",_poi1.distance];
        [screenScrollView addSubview:lblExpDate1];
        [lblExpDate1 release];
    }
    
    if (userFavCouponArray.count > 1)
    {
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 512, 280, 1)];
        _seprator.tag = k_Favorite;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, 513, 200, 30)];
        btn2.tag = k_BTN1 + 1;
        [btn2 addTarget:self action:@selector(clickToFavPoi:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn2];
        [btn2 release];
        
        UILabel * lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 513, 200, 30)];
        lblTitle2.tag = k_Favorite;
        lblTitle2.backgroundColor = [UIColor clearColor];
        lblTitle2.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle2.textColor = [UIColor blackColor];
        Poi * _poi2 = [userFavCouponArray objectAtIndex:1];
        lblTitle2.text = _poi2.name;
        [screenScrollView addSubview:lblTitle2];
        [lblTitle2 release];
        
        UILabel * lblExpDate2 = [[UILabel alloc]initWithFrame:CGRectMake(224, 513, 105, 30)];
        lblExpDate2.tag = k_Favorite;
        lblExpDate2.backgroundColor = [UIColor clearColor];
        lblExpDate2.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate2.textColor = [UIColor blackColor];
        lblExpDate2.text = [NSString stringWithFormat:@"%@ MILES",_poi2.distance];;
        [screenScrollView addSubview:lblExpDate2];
        [lblExpDate2 release];
    }
    
    if (userFavCouponArray.count > 2) {
        
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 542, 280, 1)];
        _seprator.tag = k_Favorite;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(20, 543, 200, 30)];
        btn3.tag = k_BTN1 + 2;
        [btn3 addTarget:self action:@selector(clickToFavPoi:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn3];
        [btn3 release];
        
        UILabel * lblTitle3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 543, 200, 30)];
        lblTitle3.tag = k_Favorite;
        lblTitle3.backgroundColor = [UIColor clearColor];
        lblTitle3.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle3.textColor = [UIColor blackColor];
        Poi * _poi3 = [userFavCouponArray objectAtIndex:2];
        lblTitle3.text = _poi3.name;
        [screenScrollView addSubview:lblTitle3];
        [lblTitle3 release];
        
        UILabel * lblExpDate3 = [[UILabel alloc]initWithFrame:CGRectMake(224, 543, 105, 30)];
        lblExpDate3.tag = k_Favorite;
        lblExpDate3.backgroundColor = [UIColor clearColor];
        lblExpDate3.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate3.textColor = [UIColor blackColor];
        lblExpDate3.text = [NSString stringWithFormat:@"%@ MILES",_poi3.distance];;
        [screenScrollView addSubview:lblExpDate3];
        [lblExpDate3 release];
    }
    if (isDetailCalled == NO) {
        [self hideLoadingIcon];
    }
    
}


-(void)fetchFavouritePois
{
   //    [appDelegate showActivityViewer];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"3"];
    NSString * param3 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
    NSString * param4 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
    NSString * param5 = [XMLUtil getStringCommandParam:@"platformType" paramValue:IPHONE_NATIVE_PLATFORM];
    NSString * param6 = [XMLUtil getStringCommandParam:@"version" paramValue:RIVEPOINT_CLIENT_VERSION];
    NSString * param7 = [XMLUtil getStringCommandParam:@"latLngReqd" paramValue:@"1"];
    NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",param1,param2,param3,param4,param5,param6,param7];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"getFavPoi" andParams:params];
//    XMLPostRequest * request = [[XMLPostRequest alloc]init];
     fetchRequest = [[XMLPostRequest alloc]init];
    fetchRequest.delegate = (id) self;
    [fetchRequest sendPostRequestWithRequestName:k_Get_Fav_POI andRequestXML:reviewReqXML];
//    [request release];
}

-(void) fetchFavouritePOIsArray:(NSDictionary *)infoDic
{
//    [self hideLoadingIcon];
    if (infoDic) {
        lblFavCopCount.hidden = NO;
        NSString * _count = [infoDic valueForKey:@"Count"];
        NSArray * favPoiArray = [infoDic valueForKey:@"Array"];
        if (favPoiArray.count > 0) {
            for (Poi * _poi in favPoiArray) {
                [userFavCouponArray addObject:_poi];
            }
            lblFavCopCount.text = [NSString stringWithFormat:@"%@ Favorites",_count];
            [self showFavoritePoiONScreen];
        }
        else
            [self hideLoadingIcon];
        _count = nil;
    }
    
    [fetchRequest release];
    fetchRequest = nil;
    [self performSelector:@selector(fetchUserSharedPoiImages) withObject:nil afterDelay:0.1];
}

-(void) showSavedCouponsOnScreen
{
    if (userSavedCoupenArray.count > 0)
    {
        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 178, 200, 30)];
        btn1.tag = k_BTN2 + 0;
        [btn1 addTarget:self action:@selector(clickToSavedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn1];
        [btn1 release];
        
        UILabel * lblTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 178, 200, 30)];
        lblTitle1.tag = k_Saved;
        lblTitle1.backgroundColor = [UIColor clearColor];
        lblTitle1.font = [UIFont fontWithName:@"ArialMT" size:12];;
        lblTitle1.textColor = [UIColor blackColor];
        Coupon * _coupon1 = [userSavedCoupenArray objectAtIndex:0];
        lblTitle1.text = _coupon1.title;
        [screenScrollView addSubview:lblTitle1];
        [lblTitle1 release];
        
        UILabel * lblExpDate1 = [[UILabel alloc]initWithFrame:CGRectMake(224, 178, 105, 30)];
        lblExpDate1.tag = k_Saved;
        lblExpDate1.backgroundColor = [UIColor clearColor];
        lblExpDate1.font = [UIFont fontWithName:@"ArialMT" size:10];;
        lblExpDate1.textColor = [UIColor blackColor];
        lblExpDate1.text = [NSString stringWithFormat:@"Exp: %@",_coupon1.validTo];
        [screenScrollView addSubview:lblExpDate1];
        [lblExpDate1 release];
    }
    
    if (userSavedCoupenArray.count > 1)
    {
        
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 207, 280, 1)];
        _seprator.tag = k_Saved;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, 208, 200, 30)];
        btn2.tag = k_BTN2 + 1;
        [btn2 addTarget:self action:@selector(clickToSavedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn2];
        [btn2 release];
        
        UILabel * lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 208, 200, 30)];
        lblTitle2.tag = k_Saved;
        lblTitle2.backgroundColor = [UIColor clearColor];
        lblTitle2.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle2.textColor = [UIColor blackColor];
        Coupon * _coupon2 = [userSavedCoupenArray objectAtIndex:1];
        lblTitle2.text = _coupon2.title;
        [screenScrollView addSubview:lblTitle2];
        [lblTitle2 release];
        
        UILabel * lblExpDate2 = [[UILabel alloc]initWithFrame:CGRectMake(224, 208, 105, 30)];
        lblExpDate2.tag = k_Saved;
        lblExpDate2.backgroundColor = [UIColor clearColor];
        lblExpDate2.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate2.textColor = [UIColor blackColor];
        lblExpDate2.text = [NSString stringWithFormat:@"Exp: %@",_coupon2.validTo];;
        [screenScrollView addSubview:lblExpDate2];
        [lblExpDate2 release];
    }
    
    if (userSavedCoupenArray.count > 2) {
        
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 237, 280, 1)];
        _seprator.tag = k_Saved;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(20, 238, 200, 30)];
        btn3.tag = k_BTN2 + 2;
        [btn3 addTarget:self action:@selector(clickToSavedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn3];
        [btn3 release];
        
        UILabel * lblTitle3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 238, 200, 30)];
        lblTitle3.tag = k_Saved;
        lblTitle3.backgroundColor = [UIColor clearColor];
        lblTitle3.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle3.textColor = [UIColor blackColor];
        Coupon * _coupon3 = [userSavedCoupenArray objectAtIndex:2];
        lblTitle3.text = _coupon3.title;
        [screenScrollView addSubview:lblTitle3];
        [lblTitle3 release];
        
        UILabel * lblExpDate3 = [[UILabel alloc]initWithFrame:CGRectMake(224, 238, 105, 30)];
        lblExpDate3.tag = k_Saved;
        lblExpDate3.backgroundColor = [UIColor clearColor];
        lblExpDate3.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate3.textColor = [UIColor blackColor];
        lblExpDate3.text = [NSString stringWithFormat:@"Exp: %@",_coupon3.validTo];;
        [screenScrollView addSubview:lblExpDate3];
        [lblExpDate3 release];
    }

    if (isDetailCalled == NO) {
        [self hideLoadingIcon];
    }
}
-(void) fetchSavedCouponFromServer
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    NSString * param1= [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
    NSString * param2=[XMLUtil getParamXMLWithName:@"platformType" andValue:@"0"];
    NSString * param3=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"3"];
    NSString * param4 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
    NSString * param5 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
    NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@",param1,param2,param3,param4,param5];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_Saved_Cop andParams:params];
//    XMLPostRequest * postReq = [[XMLPostRequest alloc]init];
    fetchRequest = [[XMLPostRequest alloc]init];
    fetchRequest.delegate = (id)self;
    [fetchRequest sendPostRequestWithRequestName:k_Get_Saved_Cop andRequestXML:reqXML];
//    [postReq release];
    
}
-(void) gotSavedCouponArray:(NSDictionary *)infoDic
{
//    [self hideLoadingIcon];
    if (infoDic) {
        lblSaveCopCount.hidden = NO;
        NSString * _count = [infoDic valueForKey:@"Count"];
        NSArray * array = [infoDic valueForKey:@"Array"];
        if (array.count > 0)
        {
            for (Coupon * _coup in array) {
                [userSavedCoupenArray addObject:_coup];
            }
            [self showSavedCouponsOnScreen];
            lblSaveCopCount.text = [NSString stringWithFormat:@"%@ Coupons",_count];
        }
        else
            [self hideLoadingIcon];
        _count = nil;
    }
    
    [fetchRequest release];
    fetchRequest = nil;
    [self performSelector:@selector(fetchSharedAndSendCoupons) withObject:nil afterDelay:0.1];
}

-(void) showSharedCouponOnScreen
{
    
    if (userSharedCouponArray.count > 0)
    {
        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 327, 200, 30)];
        btn1.tag = k_BTN3 + 0;
        [btn1 addTarget:self action:@selector(clickedToSharedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn1];
        [btn1 release];
        
        UILabel * lblTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 327, 200, 25)];
        lblTitle1.tag = k_Shared;
        lblTitle1.backgroundColor = [UIColor clearColor];
        lblTitle1.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle1.textColor = [UIColor blackColor];
        Coupon * _coupon1 = [userSharedCouponArray objectAtIndex:0];
        lblTitle1.text = _coupon1.title;
        [screenScrollView addSubview:lblTitle1];
        [lblTitle1 release];
        
        UILabel * lblEmail = [[UILabel alloc]initWithFrame:CGRectMake(20, 343, 279, 16)];
        lblEmail.tag = k_Shared;
        lblEmail.backgroundColor = [UIColor clearColor];
        lblEmail.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblEmail.textColor = [UIColor blackColor];
        lblEmail.text = [NSString stringWithFormat:@"Shared By : %@",_coupon1.emailSharedVia];
        [screenScrollView addSubview:lblEmail];
        [lblEmail release];
        
        UILabel * lblExpDate1 = [[UILabel alloc]initWithFrame:CGRectMake(224, 327, 105, 25)];
        lblExpDate1.tag = k_Shared;
        lblExpDate1.backgroundColor = [UIColor clearColor];
        lblExpDate1.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate1.textColor = [UIColor blackColor];
        lblExpDate1.text = [NSString stringWithFormat:@"Exp: %@",_coupon1.validTo];
        [screenScrollView addSubview:lblExpDate1];
        [lblExpDate1 release];
    }
    
    if (userSharedCouponArray.count > 1)
    {
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 360, 280, 1)];
        _seprator.tag = k_Shared;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, 360, 200, 30)];
        btn2.tag = k_BTN3 + 1;
        [btn2 addTarget:self action:@selector(clickedToSharedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn2];
        [btn2 release];
        
        UILabel * lblTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 360, 200, 25)];
        lblTitle2.tag = k_Shared;
        lblTitle2.backgroundColor = [UIColor clearColor];
        lblTitle2.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle2.textColor = [UIColor blackColor];
        Coupon * _coupon2 = [userSharedCouponArray objectAtIndex:1];
        lblTitle2.text = _coupon2.title;
        [screenScrollView addSubview:lblTitle2];
        [lblTitle2 release];
        
        UILabel * lblEmail2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 376, 279, 16)];
        lblEmail2.tag = k_Shared;
        lblEmail2.backgroundColor = [UIColor clearColor];
        lblEmail2.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblEmail2.textColor = [UIColor blackColor];
        lblEmail2.text = [NSString stringWithFormat:@"Shared By : %@",_coupon2.emailSharedVia];;
        [screenScrollView addSubview:lblEmail2];
        [lblEmail2 release];
        
        UILabel * lblExpDate2 = [[UILabel alloc]initWithFrame:CGRectMake(224, 360, 105, 25)];
        lblExpDate2.tag = k_Shared;
        lblExpDate2.backgroundColor = [UIColor clearColor];
        lblExpDate2.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate2.textColor = [UIColor blackColor];
        lblExpDate2.text = [NSString stringWithFormat:@"Exp: %@",_coupon2.validTo];;
        [screenScrollView addSubview:lblExpDate2];
        [lblExpDate2 release];
    }
    
    if (userSharedCouponArray.count > 2) {
        
        
        UIImageView * _seprator = [[UIImageView alloc]initWithFrame:CGRectMake(20, 393, 280, 1)];
        _seprator.tag = k_Shared;
        _seprator.image = [UIImage imageNamed:@"cell_seprator.png"];
        [screenScrollView addSubview:_seprator];
        [_seprator release];
        
        UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(20, 393, 200, 30)];
        btn3.tag = k_BTN3 + 2;
        [btn3 addTarget:self action:@selector(clickedToSharedCop:) forControlEvents:UIControlEventTouchUpInside];
        [screenScrollView addSubview:btn3];
        [btn3 release];
        
        UILabel * lblTitle3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 393, 200, 25)];
        lblTitle3.tag = k_Shared;
        lblTitle3.backgroundColor = [UIColor clearColor];
        lblTitle3.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblTitle3.textColor = [UIColor blackColor];
        Coupon * _coupon3 = [userSharedCouponArray objectAtIndex:2];
        lblTitle3.text = _coupon3.title;
        [screenScrollView addSubview:lblTitle3];
        [lblTitle3 release];
        
        UILabel * lblEmail3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 409, 279, 16)];
        lblEmail3.tag = k_Shared;
        lblEmail3.backgroundColor = [UIColor clearColor];
        lblEmail3.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblEmail3.textColor = [UIColor blackColor];
        lblEmail3.text = [NSString stringWithFormat:@"Shared By : %@",_coupon3.emailSharedVia];;
        [screenScrollView addSubview:lblEmail3];
        [lblEmail3 release];
        
        UILabel * lblExpDate3 = [[UILabel alloc]initWithFrame:CGRectMake(224, 393, 105, 25)];
        lblExpDate3.tag = k_Shared;
        lblExpDate3.backgroundColor = [UIColor clearColor];
        lblExpDate3.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExpDate3.textColor = [UIColor blackColor];
        lblExpDate3.text = [NSString stringWithFormat:@"Exp: %@",_coupon3.validTo];;
        [screenScrollView addSubview:lblExpDate3];
        [lblExpDate3 release];
    }
    
    if (isDetailCalled == NO) {
        [self hideLoadingIcon];
    }
}

-(void) fetchSharedAndSendCoupons
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
     NSString * param1= [XMLUtil getParamXMLWithName:@"userId" andValue:userID];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"3"];
//    NSString * param1= [XMLUtil getParamXMLWithName:@"userId" andValue:appDelegate.setting.subsId];
//    NSString * param2=[XMLUtil getParamXMLWithName:@"platformType" andValue:@"0"];
    NSString * param3 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
    NSString * param4 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
    NSString * params = [NSString stringWithFormat:@"%@%@%@%@",param1,param2,param3,param4];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_Share_Cop andParams:params];
//    XMLPostRequest * postReq = [[XMLPostRequest alloc]init];
    fetchRequest = [[XMLPostRequest alloc]init];
    fetchRequest.delegate = (id)self;
    [fetchRequest sendPostRequestWithRequestName:k_Get_Share_Cop andRequestXML:reqXML];
//    [postReq release];
}

-(void) gotSharesAndSendCouponArray:(NSDictionary *)infoDic
{
//    [self hideLoadingIcon];
    if (infoDic) {
        lblShareCopCount.hidden = NO;
        NSString * _count = [infoDic valueForKey:@"Count"];
        NSArray * array = [infoDic valueForKey:@"Array"];
        if (array.count > 0) {
            for (Coupon * _coup in array) {
                [userSharedCouponArray addObject:_coup];
            }
            lblShareCopCount.text = [NSString stringWithFormat:@"%@ Coupons",_count];
            [self showSharedCouponOnScreen];
        }
        else
            [self hideLoadingIcon];
        _count = nil;
    }
    
    [fetchRequest release];
    fetchRequest = nil;
    [self performSelector:@selector(fetchFavouritePois) withObject:nil afterDelay:0.01];
   
}
-(void)animateViewWithBeginValue:(float)begin EndValue:(float)end AnimationDuration:(float)duration TransformView:(UIView *)sender
{	
    
	NSValue *touchPointValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 240.0)];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformMakeScale(begin,begin);
	sender.transform = transform;
	transform = CGAffineTransformMakeScale(end, end);
	sender.transform = transform;
	[UIView commitAnimations];
}

-(void) downloadImageFromURL:(NSURL *)_curURL
{
    IVFullImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_curURL]]; 
    [activityWheel stopAnimating];
    activityWheel.hidden = YES;
}

-(void) sharedPhotoClicked:(id)sender
{
    UIButton * _btn = (UIButton *)sender;
    int _tag = _btn.tag;
    int _index = _tag - k_Image_Btn_Tag;
    
    UserPhotos * _curUserPhoto = [userSharePhotoArray objectAtIndex:_index];
    NSString * urlString = [_curUserPhoto.imageUrl stringByReplacingOccurrencesOfString:@"?type=8" withString:@"?type=6"];
    NSURL * _curURL = [NSURL URLWithString:[NSString stringWithFormat:urlString]];
    [self.view addSubview:fullImageView];
    activityWheel.hidden = NO;
    [activityWheel startAnimating];
    IVFullImage.image = nil;
    [self animateViewWithBeginValue:0.1 
                           EndValue:1.0 
                  AnimationDuration:0.15 
                      TransformView:fullImageView];
    [self performSelector:@selector(downloadImageFromURL:) withObject:_curURL afterDelay:0.01];
}



//-(void) sharedPhotoClicked:(id)sender
//{
//    UIButton * _btn = (UIButton *)sender;
//    int _tag = _btn.tag;
//    int _index = _tag - k_Image_Btn_Tag;
//    CustomImage * cCImage =(CustomImage *)[screenScrollView viewWithTag:_index+k_CustomView_Tag];
//    if (cCImage != nil) {
//        [self.view addSubview:fullImageView];
//        if (IVFullImage) {
//            if (cCImage.image) {
//                IVFullImage.image = cCImage.image;
//            }
//        }
//    }
//    [self animateViewWithBeginValue:0.1 
//                           EndValue:1.0 
//                  AnimationDuration:0.25 
//                      TransformView:fullImageView];
//    
//    UserPhotos * _photo = [userSharePhotoArray objectAtIndex:_index];
//    [self.view addSubview:fullImageView];
//    if (IVFullImage) {
//        if (_photo.shareImage) {
//            IVFullImage.image = _photo.shareImage;
//        }
//        else
//            [IVFullImage startDownloadWithUrl:_photo.imageUrl];
//    }
//    [self animateViewWithBeginValue:0.1 
//                           EndValue:1.0 
//                  AnimationDuration:0.25 
//                      TransformView:fullImageView];
//}


-(void) addUserSharedPOIPhotosToScreen
{
    float _x = 0.0;
    float _y = 0.0;
       
    for (int i = 0; i < 3; i++) {
        int _rCount = 3 * i;
        _y = 641 + (100 * i);
        if (userSharePhotoArray.count > _rCount) {
            for (int j = 0;  j < 3; j++) {
                int _cCount = _rCount + j;
                _x = 13 + (100 * j);
                if (userSharePhotoArray.count > _cCount) {
                    UIButton * _btn = [[UIButton alloc]initWithFrame:CGRectMake(_x+2, _y+2, 86, 86)];
                    int _tag = (i * 3)+j;
                    _btn.tag = k_Image_Btn_Tag + _tag;
                    [_btn addTarget:self action:@selector(sharedPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [screenScrollView addSubview:_btn];
                    [_btn release];
                    
                    CustomImage * imageView = [[CustomImage alloc]initWithFrame:CGRectMake(_x, _y, 90, 90)];
                    imageView.delegate = (id) self;
                    imageView.index = _tag;
                    imageView.tag = _tag+k_CustomView_Tag;
                    UserPhotos * _photo = [userSharePhotoArray objectAtIndex:_tag];
                    [imageView startDownloadWithUrl:_photo.imageUrl];
                    _photo.isReqSent = YES;
                    [screenScrollView addSubview:imageView];
                    [imageView release];
                }
            } 
        }
    }
    [self hideLoadingIcon];
}

-(void) fetchUserSharedPoiImages
{
//    NSString * param1=[XMLUtil getParamXMLWithName:@"uid" andValue:appDelegate.setting.subsId];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    NSString * param1=[XMLUtil getParamXMLWithName:@"uid" andValue:userID];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"10"];
    NSString * params = [NSString stringWithFormat:@"%@%@",param1,param2];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_user_Shared_Photo andParams:params];
//    XMLPostRequest * postReq = [[XMLPostRequest alloc]init];
    fetchRequest = [[XMLPostRequest alloc]init];
    fetchRequest.delegate = (id)self;
    [fetchRequest sendPostRequestWithRequestName:k_Get_user_Shared_Photo andRequestXML:reqXML];
//    [postReq release];
}

-(void) fetchedUserSharedPhotosIdsArray:(NSArray *)array
{
//    [self hideLoadingIcon];
    if (array.count > 0)
    {
        NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *urlFileName = @"url";
        NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
        NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
        for (NSString * _id in array) {
            UserPhotos * _photo = [[UserPhotos alloc]init];
            NSString * _url = [NSString stringWithFormat:@"%@%@%@",prefixURL,k_POI_Image_Url,_id];
            _photo.imageUrl = _url;
            _photo.isReqSent = NO;
            [userSharePhotoArray addObject:_photo];
            [_photo release];
        }
        [self addUserSharedPOIPhotosToScreen];
    }
    else
        [self hideLoadingIcon];
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) fetchUserProfileFromServer
{
    NSString * _email = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Email];
    if (_email)
    {
        NSString * param1 = [XMLUtil getParamXMLWithName:@"email" andValue:_email];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"getUserProfile" andParams:param1];
        XMLPostRequest * request = [[XMLPostRequest alloc]init];
        request.delegate = (id) self;
        [request sendPostRequestWithRequestName:k_Get_User_Profile andRequestXML:reviewReqXML];
        [request release];
    }
}

-(void) fetchedUserProfileString:(NSString *)userString
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSArray * _infoArray = [userString componentsSeparatedByString:@"[~]"];
    NSString * _name = [_infoArray objectAtIndex:0];
    if (![_name isEqualToString:@"null"] && _name.length > 0)
    {
        self.lblUserName.text = _name;
        [userDefault setValue:_name forKey:k_User_Name];
        
    }
    NSString * _email = [_infoArray objectAtIndex:1];
    if (![_email isEqualToString:@"null"] && _email.length > 0)
    {
        self.lblUserEmail.text = _email;
        [userDefault setValue:_email forKey:k_User_Email];
    }
    
    NSString * _gender = [_infoArray objectAtIndex:2];
    if (![_gender isEqualToString:@"null"] && _gender.length > 0) {
        [userDefault setValue:_gender forKey:k_User_Gender];
    }
    
    NSString * _status = [_infoArray objectAtIndex:3];
    if (![_status isEqualToString:@"null"] && _status.length > 0)
    {
        self.lblUserStatus.text = _status;
        [userDefault setValue:_status forKey:k_User_Status];
    }
    NSString * _address = [_infoArray objectAtIndex:4];
    if (![_address isEqualToString:@"null"] && _address.length > 0)
    {
        self.lblUserAddress.text = _address;
        [userDefault setValue:_address forKey:k_User_Address];
    }
    NSString * _ocupation = [_infoArray objectAtIndex:5];
    if (![_ocupation isEqualToString:@"null"] && _ocupation.length > 0)
    {
        self.lblUserDesign.text = _ocupation;
        [userDefault setValue:_ocupation forKey:k_User_Prof];
    }
    NSString * _interest = [_infoArray objectAtIndex:6];
    NSString * _intrst = [_interest stringByReplacingOccurrencesOfString:@"~^~" withString:@""];
    if (![_intrst isEqualToString:@"null"] && _intrst.length > 0)
    {
        
        if (_intrst.length < 29) {
            self.lblUserIntersetOne.text = _intrst;
            self.lblUserIntersetTWo.text = @"";
        }
        else
        {
            NSArray * interspartArray =  [_intrst componentsSeparatedByString:@" "];
            NSString * inters1 = @"";
            NSString * inters2 = @"";
            for (NSString * _str in interspartArray) {
                if (inters1.length < 29) {
                    inters1 = [inters1 stringByAppendingString:[NSString stringWithFormat:@"%@ ",_str]];
                }
                else
                    inters2 = [inters2 stringByAppendingString:[NSString stringWithFormat:@"%@ ",_str]];
            }
            self.lblUserIntersetOne.text = inters1;
            self.lblUserIntersetTWo.text = inters2;
        }
        
        [userDefault setValue:_intrst forKey:k_User_Interst];
    }
}

-(void) setUserInfoFromUserDefaults
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * _name = [userDefault valueForKey:k_User_Name];
    if (_name && _name.length > 0) {
        self.lblUserName.text = _name;
        NSString * _email = [userDefault valueForKey:k_User_Email];
        self.lblUserEmail.text = _email;
        NSString * _status = [userDefault valueForKey:k_User_Status];
        self.lblUserStatus.text = _status;
        NSString * _address = [userDefault valueForKey:k_User_Address];
        self.lblUserAddress.text = _address;
        NSString * _ocupation = [userDefault valueForKey:k_User_Prof];
        self.lblUserDesign.text = _ocupation;
        NSString * _interset = [userDefault valueForKey:k_User_Interst];
        if (_interset.length < 29) {
            self.lblUserIntersetOne.text = _interset;
            self.lblUserIntersetTWo.text = @"";
        }
        else
        {
            NSArray * interspartArray =  [_interset componentsSeparatedByString:@" "];
            NSString * inters1 = @"";
            NSString * inters2 = @"";
            for (NSString * _str in interspartArray) {
                if (inters1.length < 29) {
                    inters1 = [inters1 stringByAppendingString:[NSString stringWithFormat:@"%@ ",_str]];
                }
                else
                    inters2 = [inters2 stringByAppendingString:[NSString stringWithFormat:@"%@ ",_str]];
            }
            self.lblUserIntersetOne.text = inters1;
            self.lblUserIntersetTWo.text = inters2;
        }
    }
    else
        [self performSelector:@selector(fetchUserProfileFromServer) withObject:nil afterDelay:0.0];
}


-(void) removeFavoritePOIFromScreen
{
    NSArray * favVArray = [screenScrollView subviews];
    for (UIView * _favView in favVArray) {
        if (_favView.tag == k_Favorite || _favView.tag == k_BTN1+0 || _favView.tag == k_BTN1+1 || _favView.tag == k_BTN1+2) {
            [_favView removeFromSuperview];
        }
    }
    lblFavCopCount.text = @"0 Favorites";
}

-(void) removeSavedCouponFromScreen
{
    NSArray * savVArray = [screenScrollView subviews];
    for (UIView * _savView in savVArray) {
        if (_savView.tag == k_Saved || _savView.tag == k_BTN2+0 || _savView.tag == k_BTN2+1 || _savView.tag == k_BTN2+2) {
            [_savView removeFromSuperview];
        }
    }
    lblSaveCopCount.text = @"0 Coupons";
}

-(void) removeSharedCouponFromScreen
{
    NSArray * shaVArray = [screenScrollView subviews];
    for (UIView * _shaView in shaVArray) {
        if (_shaView.tag == k_Shared || _shaView.tag == k_BTN3+0 || _shaView.tag == k_BTN3+1 || _shaView.tag == k_BTN3+2) {
            [_shaView removeFromSuperview];
        }
    }
    lblShareCopCount.text = @"0 Coupons";
}

-(void) removeAllObjectFromScrollView
{
    NSArray * scrolSubViewArray = [self.screenScrollView subviews];
    for (UIView * scrollSubView in scrolSubViewArray) {
        if (scrollSubView.tag != k_Sub_View_Tag) {
            [scrollSubView removeFromSuperview];
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [appDelegate.progressHud removeFromSuperview];
    if (isDetailCalled == NO) {
        NSLog(@"This time tab change called");
        [self removeAllObjectFromScrollView];
    }
//    if (isDetailCalled == NO) {
//        NSLog(@"Should Remove All object");
//        [userFavCouponArray removeAllObjects];
//        [userSavedCoupenArray removeAllObjects];
//        [userSharedCouponArray removeAllObjects];
//        [userSharePhotoArray removeAllObjects];
//        [self removeAllObjectFromScrollView];
//    }
    
    [super viewWillDisappear:YES];
}
-(void) showLoadingView
{
    [appDelegate progressHudView:self.view andText:@"Loading...."];
}

-(void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:YES];   
    if (isDetailCalled  == NO) 
    {
        NSLog(@"ViewWillAppear isDetailCalled = NO");
        NSString * _userLID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
        if (_userLID && _userLID.length > 0)
        {
            NSLog(@"ViewWillAppear isDetailCalled = NO");
            [self removeAllObjectFromScrollView];
            [self performSelector:@selector(showLoadingView) withObject:nil afterDelay:0.01];
            isEditMode = NO;
            lblFavCopCount.hidden = YES;
            lblSaveCopCount.hidden = YES;
            lblShareCopCount.hidden = YES;
            lblSaveCopCount.text = @"0 Coupons";
            lblShareCopCount.text = @"0 Coupons";
            lblFavCopCount.text = @"0 Favorites";
            self.screenScrollView.contentSize = CGSizeMake(320, 960);

            [userFavCouponArray removeAllObjects];
            [userSavedCoupenArray removeAllObjects];
            [userSharedCouponArray removeAllObjects];
            [userSharePhotoArray removeAllObjects];
            callCount = 0;
//            [self performSelector:@selector(fetchFavouritePois) withObject:nil afterDelay:0.01];
            [self performSelector:@selector(fetchSavedCouponFromServer) withObject:nil afterDelay:0.01];
//            [self performSelector:@selector(fetchSharedAndSendCoupons) withObject:nil afterDelay:0.07];
//            [self performSelector:@selector(fetchUserSharedPoiImages) withObject:nil afterDelay:1.0];
            NSString * _userId = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            [NSThread detachNewThreadSelector:@selector(getuserProfileImage:) toTarget:self withObject:_userId];
            [self setUserInfoFromUserDefaults];
        }
        else
        {
//            [appDelegate fetchUserLogedInId];
//            NSLog(@"%d",appDelegate.userLoginId.length);
            if (_userLID.length <= 0)
            {
                LoginViewController * viewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                //        viewController.navigationItem.hidesBackButton = YES;
                viewController.CalledType = 0;
                viewController.delegate = (id) self;
                [self.navigationController pushViewController:viewController animated:NO];
                [viewController release];
            }
        }
    }
    else
    {
        NSLog(@"ViewWillAppear isDetailCalled = YES");
        isDetailCalled = NO;
        if (isEditProfile == YES) {
            NSLog(@"ViewWillAppear isEditCalled = YES");
            isEditProfile = NO;
            [self setUserInfoFromUserDefaults];
            NSString * _userId = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            [NSThread detachNewThreadSelector:@selector(getuserProfileImage:) toTarget:self withObject:_userId];
        }
       
    }
}

-(void) userLoggedinSuccessfully
{
//  [appDelegate progressHudView:self.view andText:@"Loading...."];
    isEditMode = NO;
    self.screenScrollView.contentSize = CGSizeMake(320, 960);
    callCount = 0;
//    [appDelegate fetchUserLogedInId];
    [self performSelector:@selector(fetchUserProfileFromServer) withObject:nil afterDelay:0.01];
//    NSString * _userId = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
//    [NSThread detachNewThreadSelector:@selector(getuserProfileImage:) toTarget:self withObject:_userId];
//    [self performSelector:@selector(fetchFavouritePois) withObject:nil afterDelay:0.03];
//    [self performSelector:@selector(fetchSavedCouponFromServer) withObject:nil afterDelay:0.01];
//    [self performSelector:@selector(fetchSharedAndSendCoupons) withObject:nil afterDelay:1.0];
//    [self performSelector:@selector(fetchUserSharedPoiImages) withObject:nil afterDelay:1.3];
}

-(void) getuserProfileImage:(NSString *)userId
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *urlFileName = @"url";
	NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
	NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
    if (prefixURL && prefixURL.length > 0)
    {
        NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@"%@servlet/ImageServlet?type=7&userId=%@",prefixURL,userId]];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        UIImage * _img = [UIImage imageWithData:imageData];
        if (_img) {
            IVUserProfile.image = _img;
        }
        _img=nil;
    }
    prefixURL = nil;
    [pool release];
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Profile";
    [super viewDidLoad];
    isSaved = NO;
    isShared = NO;
    isDetailCalled = NO;
    isEditProfile  = NO;
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    [appDelegate fetchUserLogedInId];
    userSharePhotoArray = [[NSMutableArray alloc]init];
    userSavedCoupenArray = [[NSMutableArray alloc]init];
    userSharedCouponArray =[[NSMutableArray alloc]init]; 
    userFavCouponArray = [[NSMutableArray alloc]init]; 
    
}

- (void)viewDidUnload
{
    NSLog(@"User Profile View Controller - View is going to unload");
    
    self.lblUserAddress = nil;
    self.lblUserDesign = nil;
    self.lblUserIntersetOne = nil;
    self.lblUserIntersetTWo = nil;
    self.lblUserName = nil;
    self.lblUserStatus = nil;
    self.lblUserEmail = nil;
    self.tableView = nil;
    self.userInfoView = nil;
    self.screenScrollView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) onEditBtn
{
    isDetailCalled = YES;
    isEditProfile = YES;
    RegisterViewController * viewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    viewController.isUserUpdate = YES;
    viewController.calledType = 0;
//    if (self.profileImage) {
//        viewController.userImage = self.profileImage;
//    }
    viewController.userImage = IVUserProfile.image;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter your password." message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
//    tfPassword.tag = 1606;
//    myAlertView.tag = k_Edit_profile;
//    tfPassword.placeholder=@"Enter you password";
//    [tfPassword becomeFirstResponder];
//    tfPassword.delegate = (id) self;
//    [tfPassword setBackgroundColor:[UIColor whiteColor]];
//    tfPassword.textAlignment=UITextAlignmentCenter;
//    tfPassword.returnKeyType = UIReturnKeyDone;
//    tfPassword.keyboardType = UIKeyboardTypeEmailAddress;
//    [tfPassword setSecureTextEntry:YES];
//    [myAlertView addSubview:tfPassword];
//    [myAlertView show];
//    [myAlertView release];
}
-(IBAction) onSaveBtn
{
    NSLog(@"onSaveBtn");
}
-(IBAction) onCloseBtn
{
    [self.userInfoView removeFromSuperview];
    [editBtn setEnabled:YES];
}


-(void) requestFailWithError:(NSString *)errorMsg
{
    NSLog(@"UserProfileViewController Calle For Error : Request Fail with Message : %@",errorMsg);
}


-(void) onBtnOnePressed:(id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3) +0;
    NSLog(@"onBtnOnePressed : %d", objNum);
}

-(void) onBtnTwoPressed:(id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3) +1;
    NSLog(@"onBtnTwoPressed : %d",objNum);
}

-(void) onBtnThreePressed:(id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3) +2;
    NSLog(@"onBtnThreePressed : %d",objNum);
}


#pragma mark -------- ViewAll & Delete All Funation


-(void) callDeleteAllAlertWithTag:(int)_cTag
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Want to delete all?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = _cTag;
    [alert show];
    [alert release];
}


-(IBAction) onSaveCouponDeleteAll
{
    if (userSavedCoupenArray.count > 0) {
            [self callDeleteAllAlertWithTag:k_Saved];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No saved coupons found!"];

}

-(IBAction) onSaveCouponViewAll
{
    if (userSavedCoupenArray.count > 0)
    {
        isDetailCalled = YES;
        self.title = @"Profile";
        ViewAllCouponViewController * viewController = [[ViewAllCouponViewController alloc]initWithNibName:@"ViewAllCouponViewController" bundle:nil];
        viewController.isSavedCoupon = YES;
        viewController.delegate = (id) self;
        viewController.cVtitle = k_ViewAll_Saved;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No saved coupons found!"];
    
}

-(IBAction) onShareCouponDeleteAll
{
    if (userSharedCouponArray.count > 0) {
        [self callDeleteAllAlertWithTag:k_Shared];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No shared coupons found!"];
    
}

-(IBAction) onShareCouponViewAll
{
    if (userSharedCouponArray.count > 0)
    {
        isDetailCalled = YES;
        self.title = @"Profile";
        ViewAllCouponViewController * viewController = [[ViewAllCouponViewController alloc]initWithNibName:@"ViewAllCouponViewController" bundle:nil];
        viewController.isSavedCoupon = NO;
        viewController.delegate = (id) self;
        viewController.cVtitle = k_ViewAll_Shared;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No shared coupon found!"];
    
}

-(IBAction) onFavCouponDeleteAll
{
    if (userFavCouponArray.count > 0) {
        [self callDeleteAllAlertWithTag:k_Favorite];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No favorite found!"];
    
}

-(IBAction) onFavCouponViewAll
{
    if (userFavCouponArray.count > 0) {
        isDetailCalled = YES;
        self.title = @"Profile";
        ViewAllCouponViewController * viewController = [[ViewAllCouponViewController alloc]initWithNibName:@"ViewAllCouponViewController" bundle:nil];
//        viewController.couponArray = userFavCouponArray;
        viewController.isSavedCoupon = NO;
        viewController.delegate = (id) self;
        viewController.cVtitle = k_ViewAll_Favorite;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No favorite found!"];
    
}

-(IBAction) onCouponPhotosViewAll
{
    if (userSharePhotoArray.count > 0) {
        isDetailCalled = YES;
        ViewAllPhotosViewController * viewController = [[ViewAllPhotosViewController alloc]initWithNibName:@"ViewAllPhotosViewController" bundle:nil];
//        if (userSharePhotoArray.count < 10) {
//            viewController.photoArrays = userSharePhotoArray;
//        }
//        AllPhotosViewController * viewController = [[AllPhotosViewController alloc]initWithNibName:@"AllPhotosViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
//        viewController = nil;
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No photos found!"];
}


-(void) favoritePOIViewedWithFinalArray:(NSArray *)array
{
    [self removeFavoritePOIFromScreen];
    lblFavCopCount.text = [NSString stringWithFormat:@"%d Favorites",array.count];
    if (userFavCouponArray.count > 0) {
        [userFavCouponArray removeAllObjects];
        [userFavCouponArray removeAllObjects];
        if (array.count > 0) {
            [userFavCouponArray addObject:[array objectAtIndex:0]];
        }
        if (array.count > 1) {
            [userFavCouponArray addObject:[array objectAtIndex:1]];
        }
        if (array.count > 2) {
           [userFavCouponArray addObject:[array objectAtIndex:2]]; 
        }
       [self showFavoritePoiONScreen];
    }
}

-(void)savedCouponViewedWithFinalArray:(NSArray *)array
{
    [self removeSavedCouponFromScreen];
    lblSaveCopCount.text = [NSString stringWithFormat:@"%d Coupons",array.count];
    if (array.count > 0) {
        [userSavedCoupenArray removeAllObjects];
        [userSavedCoupenArray removeAllObjects];
        if (array.count > 0) {
            [userSavedCoupenArray addObject:[array objectAtIndex:0]];
        }
        if (array.count > 1) {
            [userSavedCoupenArray addObject:[array objectAtIndex:1]];
        }
        if (array.count > 2) {
          [userSavedCoupenArray addObject:[array objectAtIndex:2]];  
        }
        [self showSavedCouponsOnScreen];
    }
}

-(void) sharedCouponViewedWithFinalArray:(NSArray *)array
{
    [self removeSharedCouponFromScreen];
    lblShareCopCount.text = [NSString stringWithFormat:@"%d Coupons",array.count];
    if (array.count > 0) {
        [userSharedCouponArray removeAllObjects];
        [userSharedCouponArray removeAllObjects];
        if (array.count > 0) {
           [userSharedCouponArray addObject:[array objectAtIndex:0]]; 
        }
        if (array.count > 1) {
            [userSharedCouponArray addObject:[array objectAtIndex:1]];
        }
        if (array.count > 2) {
            [userSharedCouponArray addObject:[array objectAtIndex:2]];
        }
        [self showSharedCouponOnScreen];
    }
}

-(void) deletedAllFavoritePOIsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"])
    {
        [userFavCouponArray removeAllObjects];
        [self removeFavoritePOIFromScreen];
    }
}

-(void) deletedAllSavedCouponsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [userSavedCoupenArray removeAllObjects];
        [self removeSavedCouponFromScreen];
    }
}

-(void) deletedAllSharedCouonsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [userSharedCouponArray removeAllObjects];
        [self removeSharedCouponFromScreen];
    }
}

//#pragma mark -------- TABLE VIEW DELEGATTES --------------
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
//{
//    int _rowCount = userSharePhotoArray.count / 3;
//    _rowCount = _rowCount + (userSharePhotoArray.count - _rowCount * 3);
//  //  NSLog(@"No of Rows  =  %d", _rowCount);
//    return _rowCount;
//}
//
//
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    
////}
//
//- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"CountryCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        
//        
//        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 93, 93)];
//        btn1.tag = k_BTN1;
//        [btn1 setImage:[UIImage imageNamed:@"photoSharedBg.png"] forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(onBtnOnePressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn1];
//        [btn1 release];
//        
//        CustomImage * image1 = [[CustomImage alloc]initWithFrame:CGRectMake(3, 6, 87, 87)];
//        image1.tag= k_IMAGE1;
//        image1.delegate =(id) self;
//        image1.isSentRequest = NO;
//        [cell.contentView addSubview:image1];
//        [image1 release];
//        
//        UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(103, 3, 93, 93)];
//        btn2.tag = k_BTN2;
//        [btn2 setImage:[UIImage imageNamed:@"photoSharedBg.png"] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(onBtnTwoPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn2];
//        [btn2 release];
//        
//        CustomImage * image2 = [[CustomImage alloc]initWithFrame:CGRectMake(106, 6, 87, 87)];
//        image2.tag= k_IMAGE2;
//        image2.delegate = (id) self;
//        image2.isSentRequest = NO;
//        [cell.contentView addSubview:image2];
//        [image2 release];
//        
//        UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(206, 3, 93, 93)];
//        btn3.tag = k_BTN3;
//        [btn3 setImage:[UIImage imageNamed:@"photoSharedBg.png"] forState:UIControlStateNormal];
//        [btn3 addTarget:self action:@selector(onBtnThreePressed:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn3];
//        [btn3 release];
//        
//        CustomImage * image3 = [[CustomImage alloc]initWithFrame:CGRectMake(209, 6, 87, 87)];
//        image3.tag= k_IMAGE3;
//        image3.delegate = (id) self;
//        image3.isSentRequest = NO;
//        [cell.contentView addSubview:image3];
//        [image3 release];
//        
//    }
//    
//    CustomImage * _image1 = (CustomImage *) [cell.contentView viewWithTag:k_IMAGE1];
//    CustomImage * _image2 = (CustomImage *) [cell.contentView viewWithTag:k_IMAGE2];
//    CustomImage * _image3 = (CustomImage *) [cell.contentView viewWithTag:k_IMAGE3];
//    
//    int _index = indexPath.row * 3;
//    if (_index+1 <= userSharePhotoArray.count)
//    {
//        
//        UserPhotos * _vPhoto = [userSharePhotoArray objectAtIndex:_index];
//        if (_vPhoto.shareImage)
//        {
//            [_image1 setImage:_vPhoto.shareImage];
//        }
//        else
//        {
//            [_image1 setImage:[UIImage imageNamed:@"photoSharedBg.png"]]; 
//            _image1.index = _index;
//            if (_vPhoto.isReqSent == NO)
//            {
//                _vPhoto.isReqSent = YES;
//                [_image1 startDownloadWithUrl:_vPhoto.imageUrl];
//            }
//            
//        }
//    }
//    if (_index+2 <= userSharePhotoArray.count)
//    {
//        
//        UserPhotos * _vPhoto = [userSharePhotoArray objectAtIndex:_index+1];
//        if (_vPhoto.shareImage)
//        {
//            [_image2 setImage:_vPhoto.shareImage];
//        }
//        else
//        {
//            [_image2 setImage:[UIImage imageNamed:@"photoSharedBg.png"]];
//            _image2.index = _index+1;
//            if (_vPhoto.isReqSent == NO)
//            {
//                _vPhoto.isReqSent = YES;
//                [_image2 startDownloadWithUrl:_vPhoto.imageUrl];
//            }
//        }
//        
//    }
//    if (_index+3 <= userSharePhotoArray.count)
//    {
//        
//        UserPhotos * _vPhoto = [userSharePhotoArray objectAtIndex:_index+2];
//        if (_vPhoto.shareImage)
//        {
//            [_image3 setImage:_vPhoto.shareImage];
//        }
//        else
//        {
//            [_image3 setImage:[UIImage imageNamed:@"photoSharedBg.png"]]; 
//            _image3.index = _index+2;
//            if (_vPhoto.isReqSent == NO)
//            {
//                _vPhoto.isReqSent = YES;
//                [_image3 startDownloadWithUrl:_vPhoto.imageUrl];
//            }
//        }
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


#pragma mark -----   ImageDownloadDelegates ------------

-(void) imageDownLoadCompleteForIndex:(int)index withImage:(UIImage *)image
{
//    UserPhotos * _vPhot0Object = [userSharePhotoArray objectAtIndex:index];
//    _vPhot0Object.shareImage = image;
}

-(void) onImageClicked
{
    NSLog(@"Image Touched");
}

-(IBAction) onFullImageCloseClick
{
    [fullImageView removeFromSuperview];
}

#pragma mark -----   TextDelegates ------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark REDEEM COUPON Function

-(void) redeemCurrentSelectedCoupon
{
    if(!_curSelectedCoupon.perUserRedemption || [_curSelectedCoupon.perUserRedemption isEqualToString:@"-1"] || [_curSelectedCoupon.userRedemptionCount intValue] < [_curSelectedCoupon.perUserRedemption intValue])
    {
           Poi *poi = _curSelectedCoupon.poi;
            int userPoints = [poi.userPoints intValue];
            int reqPoints = [_curSelectedCoupon.reqdPoints intValue];
           CouponViewController * cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
            if (_curSelectedCoupon.reqdPoints) {
                if(userPoints < reqPoints){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:@"Your points are less than the required points" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];	
                    [alert release];
                    return;
                }
                cvController.isLoyaltyPoi = YES;  
            }
            isDetailCalled = YES;
            cvController.isSaved = isSaved;
            cvController.isShared = isShared;
            cvController.currCoupon = _curSelectedCoupon;
            cvController.curPOI = poi;
            cvController.numberOfPOICoupons = [poi.couponCount intValue];
            cvController.hidesBottomBarWhenPushed = YES;
            appDelegate.couponId = [_curSelectedCoupon.couponId intValue];
            [self.navigationController pushViewController:cvController animated:YES];
            [cvController release];
	}
	else
		[appDelegate  showAlert:NSLocalizedString(KEY_REDEMPTION_LIMIT_EXHAUSTED,@"") delegate:appDelegate];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == k_Coupon_Alert_Tag) {
        if (buttonIndex == 1) {
            [self redeemCurrentSelectedCoupon];
        }
    }
    
    if (alertView.tag == k_Favorite) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Faorites andParams:param1];
            XMLPostRequest * request = [[XMLPostRequest alloc]init];
            request.delegate = (id)self;
            [request sendPostRequestWithRequestName:k_Delete_All_Faorites andRequestXML:reqXML];
            [request release];
        }
    }
    if (alertView.tag == k_Saved) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Saved andParams:param1];
            XMLPostRequest * request = [[XMLPostRequest alloc]init];
            request.delegate = (id)self;
            [request sendPostRequestWithRequestName:k_Delete_All_Saved andRequestXML:reqXML];
            [request release];
        }
    }
    if (alertView.tag == k_Shared) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Shared andParams:param1];
            XMLPostRequest * request = [[XMLPostRequest alloc]init];
            request.delegate = (id)self;
            [request sendPostRequestWithRequestName:k_Delete_All_Shared andRequestXML:reqXML];
            [request release];
        }
    }
    if (alertView.tag == k_Edit_profile) {
        if (buttonIndex == 1) {
            NSString * _psdtxt = tfPassword.text;
            if (_psdtxt && _psdtxt.length > 0)
            {
                NSString * userPSD = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Password];
                if ([_psdtxt isEqualToString:userPSD]) {
                    RegisterViewController * viewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
                    viewController.isUserUpdate = YES;
                    viewController.calledType = 0;
                    if (self.profileImage) {
                        viewController.userImage = self.profileImage;
                    }
                    [self.navigationController pushViewController:viewController animated:YES];
                    [viewController release];
                }
            }
        }
    }
    if (alertView.tag == k_Reload_Retry) {
        if (buttonIndex == 1) {
            [self removeAllObjectFromScrollView];
            [appDelegate progressHudView:self.view andText:@"Loading...."];
            isEditMode = NO;
            lblSaveCopCount.text = @"0 Coupons";
            lblShareCopCount.text = @"0 Coupons";
            lblFavCopCount.text = @"0 Favourites";
            callCount = 0;
            [self performSelector:@selector(fetchFavouritePois) withObject:nil afterDelay:0.01];
            [self performSelector:@selector(fetchSavedCouponFromServer) withObject:nil afterDelay:0.03];
            [self performSelector:@selector(fetchSharedAndSendCoupons) withObject:nil afterDelay:0.07];
            [self performSelector:@selector(fetchUserSharedPoiImages) withObject:nil afterDelay:1.0];
            NSString * _userId = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            [NSThread detachNewThreadSelector:@selector(getuserProfileImage:) toTarget:self withObject:_userId];
            [self setUserInfoFromUserDefaults];
        }
    }
}


@end
