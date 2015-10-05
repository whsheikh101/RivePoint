//
//  Poi.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Poi : NSObject {
	int pk;
	NSString *poiId;
	NSString *poiSequenceNumber;
	NSString *poiCategoryId;
	NSString *name;
	NSString *phoneNumber;
	NSString *completeAddress;
	NSString *distance;
	NSString *couponCount;
	NSString *imageName;
	NSString *imageBytes;
	NSString *isSponsored;
	NSString *isCOTDPoi;
	NSString *latitude;
	NSString *longitude;
	NSString *userPoints;
//	NSData *banner;
//	NSData *bigLogo;
//	NSData *logo;
	UIImage *logoImage;
	int logoPresentStatus;
	int feedbackCount;
    int reviewCount;
    NSString * poiType;
}

@property int logoPresentStatus;
@property int pk;
@property (nonatomic) int feedbackCount;
@property (nonatomic)  int reviewCount;
@property (nonatomic,retain) NSString *poiId;
@property (nonatomic,retain) NSString *poiSequenceNumber;
@property (nonatomic,retain) NSString *poiCategoryId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *completeAddress;
@property (nonatomic,retain) NSString *distance;
@property (nonatomic,retain) NSString *couponCount;
@property (nonatomic,retain) NSString *imageName;
@property (nonatomic,retain) NSString *imageBytes;
@property (nonatomic,retain) NSString *isSponsored;
@property (nonatomic,retain) NSString *isCOTDPoi;
@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) NSString *userPoints;
@property (nonatomic,retain) NSString *poiType;
//@property (nonatomic,assign) NSData *banner;
//@property (nonatomic,copy) NSData *bigLogo;
//@property (nonatomic,copy) NSData *logo;
@property (nonatomic,retain) UIImage *logoImage;
-(void) setBLogo:(NSData *) logo;
+(Poi*) getTestPoi;
@end
