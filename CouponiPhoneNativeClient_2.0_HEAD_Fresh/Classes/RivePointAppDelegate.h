//
//  RivePointAppDelegate.h
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 1/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
#import "SettingManager.h"
#import <CoreLocation/CoreLocation.h>
#import "HTTPSupport.h"
#import "RivepointConstants.h"
#import "HttpTransportAdaptor.h"
#import "Coupon.h"
#import "Poi.h"
#import "GeocodeAddress.h"
#import "GeneralUtil.h"
#import "CustomWindow.h"
//#import "FlurryAPI.h"
//#import "FlurryUtil.h"
#import "MBProgressHUD.h"
#import "SA_OAuthTwitterEngine.h"
#import "Facebook.h"

@class MainViewController;
@class ListCouponsViewController;
@class CouponDetailViewController;
@class SearchVendorController;
@class LocationUpdater;
@class StartupSettingsViewController;
@class MyCouponsViewController;


@interface RivePointAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate,MBProgressHUDDelegate,FBSessionDelegate,SA_OAuthTwitterEngineDelegate,FBDialogDelegate> {
    IBOutlet CustomWindow *window;
    IBOutlet UITabBarController *tabBarController;
	IBOutlet MainViewController *mainController;
	
	IBOutlet UINavigationController *getCouponsNavController;
	IBOutlet UINavigationController *searchNavController;
	IBOutlet UINavigationController *browseNavController;
	IBOutlet UINavigationController *loyaltyNavController;

	IBOutlet UINavigationController *settingNavController;
	
	IBOutlet MyCouponsViewController *myCouponsController;
	
	ListCouponsViewController *listCouponsViewController;
	UINavigationController *navController;
	IBOutlet UITabBar *tabBar;
	NSMutableDictionary *imageLogos;
	
	IBOutlet UIBarButtonItem *browseScreenZIPBarButton;
	
	IBOutlet UITabBarItem *tabBarItem;
	IBOutlet UITabBarItem *settingTabItem;
    UIAlertView *gpsAlertView;
    BOOL showGPSAlert;
	Setting *setting;	
	SettingManager *sManager ;
	CLLocation		  *lastKnownLocation;
	UIBarButtonItem *zipCodeLabel;
	IBOutlet UITabBarItem *savedCouponsTabBar;
	
	NSMutableArray *poiArray;
	NSMutableArray *browseArray;
	NSMutableArray *searchArray;
	NSMutableArray *externalArray;
	NSMutableArray *loyaltyArray;
	
	NSMutableArray *couponArray;
	NSMutableArray *sharedInboxArray;
	NSMutableArray *sharedPoiArray;
	NSMutableArray *sharedCouponArray;
	
	NSMutableDictionary *cotdDictinary;
	NSMutableArray *cotdPoiArray;
	
	Poi *poi;
	int poiId;
	int couponId;
	int couponIndex;
	int poiIndex;
	
	int senderId;
	
	int currentPoiCommand;
	NSString *keyword;
	
	NSString *categoryId;
	BOOL isNewRequest;
	HttpTransportAdaptor *adaptor;
	SearchVendorController *searchVendorController;
	
	
	NSArray *categoryNames;
	NSArray *categoryIcons;
	
	NSArray *optionNames;
	NSArray *optionIcons;
	
	NSString *excludePoiId;
	
	BOOL terminateRequest;
	
	BOOL loadFromPersistantStore,shouldUpdateLocationAtStartup;
	
	LocationUpdater *locationUpdater;
	StartupSettingsViewController *startupSettingsViewController;
	
//	NSMutableDictionary *logoDictionary;
	NSLock *logoDictionaryLock;

//	NSMutableDictionary *browseLogoDictionary;
	NSLock *browseLogoDictionaryLock;	

//	NSMutableDictionary *getCouponsLogoDictionary;
	NSLock *getCouponsLogoDictionaryLock;	
	
//	NSMutableDictionary *searchLogoDictionary;
	NSLock *searchLogoDictionaryLock;

//	NSMutableDictionary *couponPreviewImageDictionary;
	NSLock *couponPreviewImageDictionaryLock;
	
	NSString *rivePointServerURL;
	//NSDictionary *getCouponsLogo;
    
    SA_OAuthTwitterEngine * twitter;
    Facebook * facebook;
    
    BOOL shouldBackToShare;
    NSString * userSubsId;
    
}
@property (strong, nonatomic) UIAlertView *alert;
@property (nonatomic , retain) MBProgressHUD * progressHud;
@property (nonatomic , retain) SA_OAuthTwitterEngine * twitter;
@property (nonatomic , retain) Facebook * facebook;
@property BOOL shouldBackToShare;
@property BOOL shouldNotShareAlert;
//@property NSDictionary *getCouponsLogo;

@property (nonatomic , copy) NSString * userLoginId;

@property BOOL terminateRequest;
@property BOOL loadFromPersistantStore;
@property int couponIndex;
@property int poiIndex;
@property (nonatomic,retain) NSString *excludePoiId;

@property (nonatomic,retain) NSArray *categoryNames;
@property (nonatomic,retain) NSArray *categoryIcons;

@property (nonatomic,retain) NSArray *optionNames;
@property (nonatomic,retain) NSArray *optionIcons;
@property (nonatomic , retain) NSString * userSubsId;

@property (nonatomic, retain)  UITabBar *tabBar;
@property (nonatomic, retain)  UITabBarItem *tabBarItem;
@property (nonatomic, retain)  CustomWindow *window;
@property (nonatomic, retain)  UITabBarController *tabBarController;
@property (nonatomic, retain)  UINavigationController *navController;
@property (nonatomic, retain)  MainViewController *mainController;
@property (nonatomic, retain) UIAlertView *gpsAlertView;
@property (nonatomic, retain) Setting *setting;
@property (nonatomic, retain) SettingManager *sManager;
@property (nonatomic, retain) UIBarButtonItem *zipCodeLabel;
@property (nonatomic,retain) NSMutableDictionary *imageLogos;
@property (nonatomic,retain) CLLocation		  *lastKnownLocation;
@property (nonatomic,retain) StartupSettingsViewController *startupSettingsViewController;
@property (nonatomic,retain) MyCouponsViewController *myCouponsController;

@property BOOL showGPSAlert;
@property BOOL isNewRequest;

@property int currentPoiCommand;
@property (nonatomic,retain) NSString *keyword;
@property (nonatomic,retain) NSString *categoryId;

@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *couponArray;
@property (nonatomic, retain) NSMutableArray *browseArray;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic,retain) NSMutableArray *externalArray;
@property (nonatomic,retain) NSMutableArray *loyaltyArray;
@property (nonatomic,retain) NSMutableArray *sharedPoiArray;
@property (nonatomic,retain) NSMutableArray *sharedCouponArray;
@property (nonatomic,retain) Poi *poi;

@property (nonatomic,retain) NSMutableDictionary *cotdDictinary;
@property (nonatomic,retain) NSMutableArray *cotdPoiArray;

@property (nonatomic,retain) NSMutableArray *sharedInboxArray;

@property (nonatomic,retain)ListCouponsViewController *listCouponsViewController;
@property int poiId;
@property int couponId;

@property int senderId;

-(void)resetCachedObjects;
-(void)resetGetCouponPoiList;
-(void)resetBrowsePoiList;
-(void)showActivityViewer;
-(void)showActivityViewer:(NSString *)message;
-(void)hideActivityViewer;
-(IBAction)hideShowMethod;
-(void) askForUserEmail:(NSObject *)object;
-(void) setSearchVendorController:(SearchVendorController *)svController;
-(BOOL) saveCoupon:(Coupon*)cpn poi:(Poi*)poi;
-(BOOL) poiCouponExists:(Coupon*)cpn poi:(Poi*)poi;
+(double) getCurrentDate; 
-(void)showAlert:(NSString *)messageKey delegate:(NSObject *)delegate;
-(void) updateSavedCouponsTabBarItem;
-(IBAction)zipCodeClickMethod;
-(NSString*) getLocationLabel;
-(NSString*) getLocationLabel:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Latitude:(NSString*)latitude Longitude:(NSString*)longitude;
-(void) updateSettingFromGeoCode:(GeocodeAddress*)code;
-(void) updateZipCode:(GeocodeAddress*) code;
-(void)checkEmail;
-(void) setDefaultSettings;
-(LocationUpdater *) getLocationUpdatorInstance;

-(void) createLogoDictionary;
-(void) setImageInLogoDictinary:(UIImage *)image key:(NSString *)key command:(NSString *)command;
-(UIImage *) getImageFromLogoDictionary:(NSString *)key command:(NSString *)command;
-(void) removeAllFromLogoDictionary:(NSString *)command;
-(void) removeAllFromLogoDictionaries;

-(void) createCouponPreviewImageDictionary;
-(void) setCouponPreviewImageInDictionary:(UIImage *)image key:(NSString *)key;
-(UIImage *) getCouponPreviewImageFromDictionary:(NSString *)key;
-(void) removeAllFromCouponPreviewImageDictionary;
//-(void) setFlurrySession;

-(NSString *) getRivepointServerURLString;
-(void) loadRivepointServerURLString;

-(void) SwitchToTabWithIndex:(int) index;

-(void) progressHudView : (UIView *) view andText:(NSString *)message;
-(void) showAlertWithHeading:(NSString *)heading andDesc:(NSString *)desc;
-(void) fetchUserLogedInId;
-(void) gotoFirstPOITabFromController:(UINavigationController *)controller;
-(void) removeLoadingViewFromSuperView;
-(BOOL) networkStatus;
@end
