//
//  SponsoredViewCell.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 5/7/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "SponsoredViewCell.h"


@implementation SponsoredViewCell
@synthesize bannerImageView;

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

-(void) setBanner:(Poi *)poi{
	[self setPoi:poi];
	//[NSThread detachNewThreadSelector:@selector(setPoiBannerImage) toTarget:self withObject:nil];
	
	
//		if(!currPoi.banner){
//			NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
//			NSString *urlFileName = @"url";
//			NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
//			NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
//				NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=3&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,currPoi.poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//				NSData *receivedData =  [[NSData alloc] initWithContentsOfURL:url];
//					currPoi.banner = receivedData;
//				UIImageView *view = self.bannerImageView;
//				view.image = [UIImage imageWithData:receivedData];
//		}else{
//			
//			UIImageView *view = self.bannerImageView;
//			view.image = [UIImage imageWithData:currPoi.banner];
//			
//		}
	
	
}

- (void) setPoiBannerImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	if(!currPoi && [currPoi retainCount] > 0)
//	if(!currPoi.banner){
//		NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
//		NSString *urlFileName = @"url";
//		NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
//		NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString];
//		if(currPoi && [currPoi retainCount] > 0){
//			NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@?type=3&poiId=%@",prefixURL,RIVEPOINT_IMAGE_SERVLET,currPoi.poiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//			NSData *receivedData =  [[NSData alloc] initWithContentsOfURL:url];
//			if(!currPoi && [currPoi retainCount] > 0)
//				currPoi.banner = receivedData;
//			UIImageView *view = self.bannerImageView;
//			view.image = [UIImage imageWithData:receivedData];
//		}
//	}else{
//		
//		UIImageView *view = self.bannerImageView;
//		view.image = [UIImage imageWithData:currPoi.banner];
//		
//	}
	
	
	[pool release];
}
-(void) setPoi:(Poi *)poi{
	currPoi = poi;
	
	
}
- (void)dealloc {
    [bannerImageView release];
    bannerImageView = nil;
    
    [super dealloc];
}


@end
