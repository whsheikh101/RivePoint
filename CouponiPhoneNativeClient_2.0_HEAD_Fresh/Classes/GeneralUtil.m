//
//  GeneralUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 4/28/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "GeneralUtil.h"
#import "RightBarButtonItemsController.h"
#import "PoiFinderNew.h"
#import "FileUtil.h"

@implementation GeneralUtil
+(void) setRivepointLogo:(UINavigationItem *)item{
	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rivepointLogo.png"]];
	item.titleView = view;
	[view release];
}
+(UISegmentedControl *) setSegmentedContol:(UINavigationItem *)item{

	UISegmentedControl* segmentedControl = [[[UISegmentedControl alloc] initWithItems:
						 [NSArray arrayWithObjects:
						  [UIImage imageNamed:@"back-topbar-icon.png"],
						  [UIImage imageNamed:@"next-topbar-icon.png"],
						  nil]] autorelease];
	//[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 70, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
	segmentedControl.momentary = YES;
	segmentedControl.tintColor = [UIColor blackColor];
	
	
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
	item.rightBarButtonItem = segmentBarItem;
	return segmentedControl;
}

+(Poi *)getPoi{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	Poi *poi;
    
	if(appDelegate.currentPoiCommand == GET_COUPONS)
		poi = [appDelegate.poiArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == BROWSE)
		poi = [appDelegate.browseArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == SEARCH)
		poi = [appDelegate.searchArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == EXTERNAL_COUPON_POIS)
		poi = [appDelegate.externalArray objectAtIndex:appDelegate.poiId];
	else if(appDelegate.currentPoiCommand == 5)
		poi = [appDelegate.sharedPoiArray objectAtIndex:appDelegate.poiIndex];
	else if(appDelegate.currentPoiCommand == 6){
		Coupon *coupon = (Coupon *)[appDelegate.couponArray objectAtIndex:0];
		poi = coupon.poi;
	}
	else if(appDelegate.currentPoiCommand == 7)
		poi = appDelegate.poi;
	else if(appDelegate.currentPoiCommand == GET_LOYALTY_POIS){
		poi = [appDelegate.loyaltyArray objectAtIndex:appDelegate.poiId];
	}
	return poi;
	
}
+(void)setRightBarButton: (int)i controllerReference:(UIViewController *) controllerReference{
	if(i==0){
		controllerReference.navigationItem.rightBarButtonItem = nil;
	}
	else{
		UIActivityIndicatorView *uiActivityIndicatorView;
		uiActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0, 24, 24)];
		uiActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		uiActivityIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
													UIViewAutoresizingFlexibleRightMargin |
													UIViewAutoresizingFlexibleTopMargin |
													UIViewAutoresizingFlexibleBottomMargin);
		[uiActivityIndicatorView autorelease]; 
		UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:uiActivityIndicatorView] autorelease];	
		
		controllerReference.navigationItem.rightBarButtonItem = rightTopBarItem;
		[uiActivityIndicatorView startAnimating];
	}
}
+(void)phoneClick:(Poi *)poi controllerReference:(UIViewController *) controllerReference{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			[appDelegate showAlert:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:appDelegate];
		}
		
	}
	
}
+(void)mapClick:(Poi *)poi controllerReference:(UIViewController *) controllerReference{
	if([poi.completeAddress length] > 0){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:NSLocalizedString(GOOGLE_MAPS_URL,EMPTY_STRING) ,poi.completeAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_MAPS_CANT_OPEN,EMPTY_STRING) delegate:controllerReference cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}
}
+(NSString *)getLongFormatDate: (NSString *) inputDateString{
	double sec = 1000.00f;
	NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([inputDateString doubleValue])/sec];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle]; 
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle]; 
	NSString *formattedDateString =   [dateFormatter stringFromDate:toDate];
	[dateFormatter release];
	
	return formattedDateString;
}
+(NSData *)getVendorSmallLogo:(NSString *)poiId {
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *prefixURL = [appDelegate getRivepointServerURLString];
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=5&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *receivedData =  [[[NSData alloc] initWithContentsOfURL:url] autorelease];
//	NSLog(@"attributes: Received data length %d", [receivedData length]);
	if(receivedData && [receivedData length] > 0)
		return receivedData;
	return nil;

}
+(void)fillWithVendorSmallLogo:(NSArray *)poiList{
	return;
/*
	for(Poi *poi in poiList){
		if(poi.logoPresentStatus == DEFAULT_LOGO_VALUE){
			if(poi.couponCount && [poi.couponCount intValue] > 0){
				NSData *obtainedData = [GeneralUtil getVendorSmallLogo:poi.poiId];
				if(obtainedData){
					poi.logo = obtainedData;
				

					UIImage *uiImage = [UIImage imageWithData:obtainedData];
					if( uiImage.size.height > 45 || uiImage.size.width > 56){
						uiImage = [GeneralUtil scaleImage:uiImage width:56 height:45];
					} 
					
					poi.logoImage = uiImage;
				
					poi.logoPresentStatus = LOGO_PRESENT;
					continue;
				}
			}

			poi.logoImage = [UIImage imageNamed:@"dummy-logo.png"];
			poi.logoPresentStatus = LOGO_NOT_PRESENT;


		}
		

	}
	*/

}
+(void)fillWithSameVendorLogo:(NSArray *)poiList{
	Poi *firstPOI;
	if([poiList count] > 0){
		firstPOI = [poiList objectAtIndex:0];
		NSData *obtainedData = [GeneralUtil getVendorSmallLogo:firstPOI.poiId];
		if(obtainedData){
//			firstPOI.logo = obtainedData;
			UIImage *uiImage = [UIImage imageWithData:obtainedData];
			if( uiImage.size.height > 45 || uiImage.size.width > 56){
				uiImage = [GeneralUtil scaleImage:uiImage width:56 height:45];
			} 
			
			firstPOI.logoImage = uiImage;
			
			firstPOI.logoPresentStatus = LOGO_PRESENT;
		}
		else{
			firstPOI.logoImage = [UIImage imageNamed:@"dummy-logo.png"];
			firstPOI.logoPresentStatus = LOGO_NOT_PRESENT;
			
		}
		
		for(Poi *poi in poiList){
			if(poi.logoPresentStatus == DEFAULT_LOGO_VALUE){				
				poi.logoImage = firstPOI.logoImage;
				poi.logoPresentStatus = LOGO_PRESENT;				
			}
		}
		
	}
	

}
+(NSString *)truncateDecimal:(NSString *) str{
	if(!str)
		return str;
	
	NSArray *splitStr =[str componentsSeparatedByString:@"."];
	
	NSString *decimalStr = [splitStr objectAtIndex:1];
	if([decimalStr length] >= 2){
		decimalStr = [decimalStr substringToIndex:2];
	}
	
	
	
	return [NSString stringWithFormat:@"%@.%@",[splitStr objectAtIndex:0],decimalStr];
}
+ (UIImage *)scaleImage:(UIImage *)image width:(int)width height:(int)height {   
	CGSize newSize = CGSizeMake(width, height);
	@synchronized(self){
		UIGraphicsBeginImageContext(newSize);   
		[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];   
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();   
		UIGraphicsEndImageContext();   
		return newImage; 
	}
	return image;
} 

+(void) setStringToCoder:(NSString *)str key:(NSString *)key coder:(NSCoder *)encoder{
	if(str)
		[encoder encodeObject:str forKey:key];
	
}
+ (void) setDataToCoder:(NSData *)data key:(NSString *)key coder:(NSCoder *)encoder{
	if(data)
		[encoder encodeObject:data forKey:key];
	
}
+ (void) setImageToCoder:(UIImage *)img key:(NSString *)key coder:(NSCoder *)encoder{
	if(img)
		[encoder encodeObject:UIImageJPEGRepresentation(img, 1.0) forKey:key];
	
}

+(NSString *) updateZipFromPOIList:(NSArray *) array{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];

	@try{
		if(!appDelegate.setting.zip || [appDelegate.setting.zip isEqualToString:@""]){
			Poi *poi;
			for(Poi *p in array){
				if(!p.isSponsored || ![p.isSponsored isEqualToString:@"true"]){
					poi = p;
					break;
				}			
			}
			if(!poi){
				poi = (Poi *)[array objectAtIndex:0];			
			}
		
		
			NSArray *completeAddressArray = [poi.completeAddress componentsSeparatedByString:@","];
			int completeAddressArrayCount =  [completeAddressArray count];
			int zipIndex = completeAddressArrayCount - 1;
			if(zipIndex < 0){
				zipIndex = 0;
			}
			NSString *tempStr =[[completeAddressArray objectAtIndex:zipIndex] 
								stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if([tempStr caseInsensitiveCompare:@"US"] == NSOrderedSame){
				zipIndex = completeAddressArrayCount - 2;
			
				if(zipIndex < 0){
					zipIndex = 0;
				}
				return [[completeAddressArray objectAtIndex:zipIndex] 
						stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			}
			else{
				return tempStr;
			}
		}	
	}
	@catch (NSException * e) {
		NSLog(@"GeneralUtil -> (NSString *) updateZipFromPOIList:(NSArray *) array: Caught %@: %@", [e name], [e  reason]);
	}
	return appDelegate.setting.zip;
}
+(void) setActivityIndicatorView:(UINavigationItem *) navItem{
	UIActivityIndicatorView *uiActivityIndicatorView;
	uiActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0, 24, 24)];
	uiActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	uiActivityIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
												UIViewAutoresizingFlexibleRightMargin |
												UIViewAutoresizingFlexibleTopMargin |
												UIViewAutoresizingFlexibleBottomMargin);
	[uiActivityIndicatorView autorelease]; 
	UIBarButtonItem *rightTopBarItem = [[[UIBarButtonItem alloc] initWithCustomView:uiActivityIndicatorView] autorelease];	
	
	navItem.rightBarButtonItem = rightTopBarItem;
	[uiActivityIndicatorView startAnimating];
}
+ (NSData *)getCouponPreviewImage:(NSString *)couponId{
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *prefixURL = [appDelegate getRivepointServerURLString];
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=2&couponId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,couponId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *receivedData =  [[[NSData alloc] initWithContentsOfURL:url] autorelease];
//	NSLog(@"attributes: Received data length %d", [receivedData length]);
	if(receivedData && [receivedData length] > 0)
		return receivedData;
	return nil;
}
+(void)setBigLogo:(UIImageView *)bigLogoImageView poiId:(NSString *) poiId{
    
	RivePointAppDelegate *appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *prefixURL = [appDelegate getRivepointServerURLString];
	NSLog(@"prefixURL");
	NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=1&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *receivedData =  [[[NSData alloc] initWithContentsOfURL:url] autorelease];
//	NSLog(@"attributes: Received data length %d", [receivedData length]);
	if(receivedData && [receivedData length] > 0)
		bigLogoImageView.image = [UIImage imageWithData:receivedData];
	else
		bigLogoImageView.image = [UIImage imageNamed:@"dummy-logo.png"];	

}


@end
