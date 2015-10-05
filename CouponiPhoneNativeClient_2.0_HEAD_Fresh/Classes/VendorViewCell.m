//
//  CouponViewCell.m
//  RivePoint
//
//  Created by Shahnawaz Bagdadi on 2/5/09.
//  Copyright 2009 RivePoint Inc. All rights reserved.
//

#import "VendorViewCell.h"
#import "RivepointConstants.h"
#import "RivePointAppDelegate.h"


@implementation VendorViewCell
#define COUPON_COUNT_IMAGE_X 65
#define COUPON_COUNT_IMAGE_Y 19
#define COUPON_COUNT_IMAGE_HEIGHT 14
#define ONE_COUPON_IMAGE_WIDTH 10
#define COUNT_LABEL_WIDTH 80
#define TOTAL_COUPON_COUNT_IMAGES 6

@synthesize phoneNo;
@synthesize mapURL,poiId,command,poiName;
@synthesize reviewCountLbl;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
       
		// Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBackGroundWithPod{
	[menuPod addSubview:countLabel];
	self.backgroundColor = [UIColor clearColor];
	
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_pod.png"]];
	self.backgroundView = view;
	[view release];
	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_pod_ov.png"]];
	self.selectedBackgroundView = view;
	[view release];
	
	
}

-(void)setBackGround{
	distanceLabel.text = @"";
	milesLabel.text = @"";
	[menuPod addSubview:countLabel];
	self.backgroundColor = [UIColor clearColor];
	
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_saved_bg.png"]];
	self.backgroundView = view;
	[view release];
//	view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_saved_ov.png"]];
//	self.selectedBackgroundView = view;
//	[view release];
	
	
}

- (void)layoutSubviews {
	
}
-(void) setPoiContent:(Poi *) poi{
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	vendorLogo.image= nil;
	@synchronized(poi){
	
	poiRef = poi;
	self.poiId  = poi.poiId;
	self.poiName = poi.name;
	
        
        
	
	UIImage  *imageFromDic = [appDelegate getImageFromLogoDictionary:poi.name command:command];
	if(poi.logoImage || imageFromDic){
		vendorLogo.animationImages = nil;
		if(!imageFromDic){
			vendorLogo.image = poiRef.logoImage;
		}
		else{
			vendorLogo.image = imageFromDic;
		}
	}
	else{
		if([poi.couponCount intValue] > 0)
			[NSThread detachNewThreadSelector:@selector(setVendorLogoImage:) toTarget:self withObject:poi.name];
		else
			vendorLogo.image = [UIImage imageNamed:@"dummy-logo.png"];
    }
     ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-stars-0%d.png",poi.feedbackCount]];
    
     [self.reviewCountLbl setText:[NSString stringWithFormat:@"%d",poi.reviewCount]];

	
	
	couponCountImage.hidden = NO;
	vendorLabel.text = poi.name;
	int couponCount = [poi.couponCount intValue];
	if(couponCount > 0 && couponCount < TOTAL_COUPON_COUNT_IMAGES){
		couponCountImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"couponIcon-%d.png",couponCount]];
		couponCountImage.frame = CGRectMake(COUPON_COUNT_IMAGE_X, COUPON_COUNT_IMAGE_Y, ONE_COUPON_IMAGE_WIDTH*couponCount, COUPON_COUNT_IMAGE_HEIGHT);
		countLabel.frame= CGRectMake(COUPON_COUNT_IMAGE_X + ONE_COUPON_IMAGE_WIDTH*(couponCount + 1), COUPON_COUNT_IMAGE_Y+2, COUNT_LABEL_WIDTH, COUPON_COUNT_IMAGE_HEIGHT);
	} else if(couponCount >= TOTAL_COUPON_COUNT_IMAGES){
		couponCountImage.image = [UIImage imageNamed:@"couponIcon-5+.png"];
		couponCountImage.frame = CGRectMake(COUPON_COUNT_IMAGE_X, COUPON_COUNT_IMAGE_Y, ONE_COUPON_IMAGE_WIDTH*TOTAL_COUPON_COUNT_IMAGES, COUPON_COUNT_IMAGE_HEIGHT);
		countLabel.frame= CGRectMake(COUPON_COUNT_IMAGE_X + ONE_COUPON_IMAGE_WIDTH*(TOTAL_COUPON_COUNT_IMAGES + 1), COUPON_COUNT_IMAGE_Y+2, COUNT_LABEL_WIDTH, COUPON_COUNT_IMAGE_HEIGHT);			
	}else{
		couponCountImage.hidden = YES;
		couponCountImage.frame = CGRectMake(0,0,0,0);
		countLabel.frame= CGRectMake(COUPON_COUNT_IMAGE_X , COUPON_COUNT_IMAGE_Y+2, COUNT_LABEL_WIDTH, COUPON_COUNT_IMAGE_HEIGHT);
	}
	

	
	countLabel.text = [NSString stringWithFormat:@"%@ COUPONS",poi.couponCount];
	
	addressLabel.text = poi.completeAddress;
	

	if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"])
		self.phoneNo = [NSString stringWithFormat:@"tel:%@",poi.phoneNumber];
	if([poi.completeAddress length] > 0)
		self.mapURL = [NSString stringWithFormat:NSLocalizedString(GOOGLE_MAPS_URL,EMPTY_STRING) ,poi.completeAddress];
	}

}


- (void) setVendorLogoImage:(NSString *)name{
	
	@try {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[name retain];
//		UIImage *uiImage;
		NSData *receivedData = [GeneralUtil getVendorSmallLogo:poiId];
		if(receivedData){
            UIImage * venderImg = [UIImage imageWithData:receivedData];
            if([name isEqualToString:poiName]){
                vendorLogo.image = venderImg;
            }
            [appDelegate setImageInLogoDictinary:venderImg key:name command:command];
//            if (venderImg) {
//                uiImage = venderImg;
//            }
//            else
//                uiImage = [UIImage imageNamed:@"dummy-logo.png"];
		}
		else{
			vendorLogo.image = [UIImage imageNamed:@"dummy-logo.png"];
		}
//		if([name isEqualToString:poiName]){
//			vendorLogo.image = uiImage;
//		}
		[name release];
 		[pool release];
		
	}
	@catch (NSException * e) {
		NSLog(@"setVendorLogoImage: Caught %@: %@", [e name], [e  reason]);
	}
}


-(IBAction)phoneClick{
	if(self.phoneNo && [self.phoneNo length] > 0){
		NSURL *url = [NSURL URLWithString:[self.phoneNo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
		
	}
	else{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_NO_PHONE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
		
	}
		
}
-(IBAction)mapClick{
	if(self.mapURL && [self.mapURL length] > 0){
		NSURL *url = [NSURL URLWithString:[self.mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_MAPS_CANT_OPEN,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}
}

-(void) showDistanceLabel:(Poi *)poi{
	NSArray *splitStr =[poi.distance componentsSeparatedByString:@"."];
	
	NSString *decimalStr = [splitStr objectAtIndex:1];
	if([decimalStr length] >= 2){
		decimalStr = [decimalStr substringToIndex:2];
	}
		
	poi.distance = [NSString stringWithFormat:@"%@.%@",[splitStr objectAtIndex:0],decimalStr];
	
	distanceLabel.text = poi.distance;
} 

- (void)dealloc {
	
	[poiName release];
	[poiId release];	
	[mapURL release];
	[phoneNo release];
	[command release];
    
    [vendorLabel release];
	[addressLabel release];
	[milesLabel release];
	[distanceLabel release];
	[countLabel release];
	[couponCountImage release];
	[vendorLogo release];
    [ratingImageView release];
    
    vendorLabel = nil;
	addressLabel = nil;
	milesLabel = nil;
	distanceLabel = nil;
	countLabel = nil;
	couponCountImage = nil;
	vendorLogo = nil;
    ratingImageView = nil;
    
    [super dealloc];
}


@end
