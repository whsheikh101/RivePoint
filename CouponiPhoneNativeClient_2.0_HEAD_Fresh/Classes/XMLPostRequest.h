//
//  XMLPostRequest.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/22/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLPostRequestDelegates <NSObject>
@optional

-(void) requestFailWithError:(NSString *) errorMsg;
-(void) addPoiFavRequestCompletedWithSatus:(NSString *)status;
-(void) addPoiRatingRequestCompletedWithSatus:(NSString *)status;
-(void) addPoiReviewRequestCompletedWithSatus:(NSString *)status;
-(void) fetchedPoiReviewArray:(NSMutableArray *)reviewArray;
-(void) fetchFavouritePOIsArray:(NSDictionary *)infoDic;
-(void) fetchedUserProfileString:(NSString *)userString;
-(void) poiPhotoUploadedWithStatusCode:(NSString *)status;
-(void) fetchedUserprofileImageWithImageDataString:(NSString *)imageStr;
-(void) userSuccessfullyLoggedinWithId:(NSString *) userId;
-(void) couponSavedWithStatus:(NSString *)status;
-(void) gotSavedCouponArray:(NSDictionary *) infoDic;
-(void) gotSharesAndSendCouponArray:(NSDictionary *) infoDic;
-(void) fetchedUserSharedPhotosIdsArray:(NSArray *) array;
-(void) fetchedPOISharedPhotosIdsArray:(NSArray *) array;
-(void) userRegisterWithResponseStatus:(NSString *) _status;
-(void) favouritePOIRemovedWithStatus:(NSString *)status;
-(void) savedCouponRemovedWithStatus:(NSString *)status;
-(void) sharedCouponRemovedWithStatus:(NSString *)status;
-(void) deletedAllFavoritePOIsWithStatus:(NSString *)status;
-(void) deletedAllSavedCouponsWithStatus:(NSString *)status;
-(void) deletedAllSharedCouonsWithStatus:(NSString *)status;
-(void) userProfileUpdatedWithStatus:(NSString *)status;
-(void) imageSharedViaEmail:(NSString *)status;
-(void) couponRedeemedWithStatus:(NSString *)status;
-(void) internetConnectionNotFoundForUserProfile;

@end


@interface XMLPostRequest : NSObject<NSURLConnectionDelegate>
{
    NSURLConnection * connection;
//    NSData * responseData;
    NSMutableData * responseData;
    id<XMLPostRequestDelegates> delegate;
}

@property (nonatomic , copy) NSString * requestName;
//@property (nonatomic , retain) NSData * responseData;
@property (nonatomic , retain) NSMutableData * responseData;
@property (nonatomic , retain) id<XMLPostRequestDelegates> delegate;

-(void)sendPostRequestWithRequestName:(NSString *)name andRequestXML:(NSString *)xml;
-(void) cancelCurrentRequest;

@end
