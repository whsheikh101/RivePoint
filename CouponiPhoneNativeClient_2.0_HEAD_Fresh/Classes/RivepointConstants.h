//
//  RivepointConstants.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/24/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RivepointConstants : NSObject {
	#define EMPTY_STRING @"";
	#define KEY_APPLICATION_NAME @"Rivepoint"
	#define RIVEPOINT_MAIN_SERVLET  @"/servlet/GpsFrameworkPocServlet"
	#define RIVEPOINT_IMAGE_SERVLET  @"/servlet/ImageServlet"
	#define GOOGLE_MAPS_URL @"url.google.maps"
	#define KEY_GPS_ALERT @"message.gps.enable.alert"
	#define KEY_ALERT_DEFAULT_SETTINGS @"message.alert.default.settings"
	#define KEY_NO_COUPON_FOUND @"message.no.coupon.found"
	#define KEY_REDEMPTION_LIMIT_EXHAUSTED	@"message.redemption.limit.exhausted"
	#define KEY_COUPON_NOT_AVAILABLE @"message.coupon.not.available"
	#define KEY_INVALID_ZIP_CODE @"message.invalid.zip.code"
	#define KEY_NO_POIS_FOUND @"message.no.poi.found"
	#define KEY_DID_U_MEAN @"message.did.u.mean"
	#define KEY_INVALID_EMAIL @"message.invalid.email"
	#define KEY_NO_SAVED_COUPON_FOUND @"message.no.saved.coupon.found"
	#define KEY_COUPON_DELETED_SUCCESSFULLY @"message.coupon.deleted.successfully"
	#define KEY_COUPON_SHARED_SUCCESS @"message.coupon.shared.successfully"
	#define KEY_COUPON_ALREADY_SAVED @"message.coupon.already.saved"
	#define KEY_COUPON_SAVED_SUCCESSFULLY @"message.coupon.saved.successfully"
	#define KEY_FEEDBACK_REGISTERED_SUCCESSFULLY @"message.feedback.registered.successfully"
	#define KEY_EMPTY_INBOX_SUCCESS @"message.delete.all.shared.coupons.success"
	#define KEY_SHARED_INBOX_IS_EMPTY @"message.shared.inbox.is.empty"
	#define KEY_NO_COTD_FOUND @"message.no.cotd.found"
	#define KEY_DELETE_ALL_COUPONS @"message.delete.all.coupons"
	
	#define KEY_CANT_CALL @"message.cant.call"
	#define KEY_MAPS_CANT_OPEN @"message.maps.cant.open"
	#define KEY_NO_PHONE @"message.no.phone"
	
	#define LABEL_TO_FROM_DATE @"label.to.from.date"
	#define LABEL_REDEMPTION_STATUS @"label.redemption.status"
	#define LABEL_CD_NAME @"label.cd.name"
	#define LABEL_CD_ADDRESS @"label.cd.address"
	#define LABEL_CD_DISTANCE @"label.cd.distance"
	
	#define KEY_SERVICE_NOT_AVAILABLE @"error.service.not.avaiable"
	#define KEY_FAILED_UPDATE_EMAIL @"error.update.email"
	#define KEY_ERROR_COUPON_SAVED @"error.coupon.saved"
	#define KEY_ERROR_DELETE_COUPON @"error.delete.coupon"
	#define KEY_ERROR_SHARING_COUPON @"error.sharing.coupon"
	#define KEY_ERROR_REGISTERING_FEEDBACK @"error.feedback.registraton.failed"
	#define KEY_ERROR_EMPTY_SHARED_COUPON_OPERATION @"error.in.delete.all.shared.coupon.operation"
	#define KEY_ERROR_LOCATION_UPDATE_FAILURE @"error.failed.to.update.location"
	#define KEY_ERROR_LOCATION_SERVICE_NOT_ENABLED @"error.location.service.not.enabled"
	#define KEY_ERROR_LOCATION_NEWWORK_UNAVAILABLE @"error.location.network.unavailable"
	#define KEY_ERROR_LOCATION_USER_DENIAL @"error.location.user.denial"
	#define KEY_ERROR_REVERSE_GEOCODING @"error.reverse.geocoding.location"
	
	#define KEY_CONFIRMATION_SHARED_INBOX_OPERATION @"confirmation.operation.empty.shared.inbox"
	#define KEY_CONFIRMATION_DELETE_COUPON_OPERATION @"confirmation.operation.delete.coupon.inbox"
	#define KEY_CONFIRMATION_DELETE_ALL_COUPON_OPERATION @"confirmation.operation.delete.all.coupons"
	#define KEY_CONFIRMATION_CHANGE_POI_OPERATION @"confirmation.operation.change.poi"
	
	#define DEFAULT_LOGO_VALUE 0
	#define LOGO_PRESENT 1
	#define LOGO_NOT_PRESENT 2
	
	
	#define LEVEL1 @"level1"
	#define LEVEL2 @"level2"
	#define LEVEL3 @"level3"
	#define POI_ID @"poiId"
	#define NO_OF_LEVELS @"noOfLevels"
	#define SEARCH_KEYWORD @"searchKeyword"
	#define CATEGORY_ID @"categoryId"
		
	#define POI_LIST @"poiList"
	//Commands For Persistance
	#define COUPON_LIST 1
    
    #define k_ViewAll_Saved @"SAVED COUPONS"
    #define k_ViewAll_Shared @"SHARED COUPONS"
    #define k_ViewAll_Favorite @"FAVORITES"
    #define GPS_FRAMEWORK_PAYLOAD @"gpsFrameworkPayLoad="
    #define CONTENT_TYPE_VALUE @"application/x-www-form-urlencoded"
    #define CONTENT_TYPE @"Content-Type"
    #define CONTENT_LENGTH @"Content-Length"
    #define HTTP_METHOD @"POST"
    #define CONNECTION_TIME_OUT 60
    #define k_RIVEPOINT_Server_URL @"http://localhost:8080/coupon-server//servlet/GpsFrameworkPocServlet"
    #define k_AddFavPoiReq @"addFavPoi"
    #define k_AddPoiRatingReq @"addPoiRating"
    #define k_AddPoiReviewReq @"addPoiReview"
    #define k_Get_POI_Reviews @"getPoiReviews"
    #define k_Get_Fav_POI @"getFavPoi"
    #define k_Get_Fav_POI_More @"getFavPoiMore"
    #define k_Get_Saved_Cop @"getSavedCoupons"
    #define k_Get_Saved_Cop_More @"getSavedCouponsMore"
    #define k_RedeemCoupon_Call @"redeemCoupon"
    #define k_Get_Share_Cop @"getSharedCoupons"
    #define k_Get_Share_Cop_More @"getSharedCouponsMore"
    #define k_Get_User_Profile @"getUserProfile"
    #define k_User_Login @"loginUser"
    #define k_User_Email @"useremail"
    #define k_User_Password @"usercurrentpassword"
    #define k_Get_User_Image @"getUserAvatar"
    #define k_Add_Poi_Photo @"addPoiPhoto"
    #define k_AddUpdate_User_Photo @"addUpdateUserAvatar"
    #define k_Get_user_Shared_Photo @"getPoiPhotosByUser"
    #define k_Get_user_Shared_Photo_More @"getPoiPhotosByUserMore"
    #define k_Get_POI_Shared_Photo @"getPoiPhotos"
    #define k_Status_OK @"1"
    #define k_Status_AlreadyExist @"2"
    #define K_Status_Fail @"0"
    #define k_LoggedIn_User_Id @"loggedinuserid"
    #define k_Save_Coupon @"saveCoupon"
    #define k_POI_Image_Url @"servlet/ImageServlet?type=8&photoId="
    #define k_Coupon_Alert_Tag 36542
    #define k_User_Register @"registerUser"
    #define k_User_Update @"updateUserProfile"
    #define k_Remove_Fav_POI @"removeFavPoi"
    #define k_Remove_Save_Coupon @"removeSavedCoupon"
    #define k_Remove_Share_coupon @"delSharedCoupon"
    #define k_Delete_All_Faorites @"removeAllFavPoi"
    #define k_Delete_All_Saved @"removeAllSavedCoupon"
    #define k_Delete_All_Shared @"delAllSharedCoupons"
    #define k_Email_Enable @"isemailenable"
    #define k_FB_Share_Notification @"facebookloginnotification"
    #define k_Share_Image_Command @"shareEmail"
    #define k_Twitter_login_Notification @"userwanttologintwitter"
    #define k_Twitter_LoggedIn_Notification @"userhasloggedintwitter"
    #define k_Share_Coupon_Base_Url @"http://www.rivepoint.com/coupon/get/a/b/c/"
    #define k_Tweet_Successful @"twittertweetsuccessful"
    #define k_Tweet_Fail @"twittertweetfail"
    #define k_RP_Login_Call @"RPLoginPageNotification"
    #define k_RP_Register_Call @"RPRegisterNotification"
}

@end
