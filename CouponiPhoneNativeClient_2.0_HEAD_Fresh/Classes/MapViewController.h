//
//  MapViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 10/25/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomAnotation.h"

@class RivePointAppDelegate;
@class ListCouponsViewController;
@class Poi;
@class MainViewController;

@interface MapViewController : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	RivePointAppDelegate *appDelegate;
	CustomAnotation *customAnotation;
	CustomAnotation *userAnotation;
	CustomAnotation *anotation;
	ListCouponsViewController *listCouponsViewController;
	MKCoordinateRegion mapRegion;
	Poi *poi;
	NSMutableArray *annotaionArray;
	MainViewController *mainViewController;
			
}
@property (nonatomic,retain) MKMapView *mapView;

-(IBAction)dismissPresentViewController;
-(void)setMapPosition:(double)latitude longitude:(double)longitude;
-(void)zoomToFitMapAnnotations:(double)latitude longitude:(double)longitude;
-(void)setListCouponViewController:(ListCouponsViewController *)viewController;
-(void)setMainViewController:(MainViewController *)viewController;

-(MKCoordinateRegion)getCoordinateRegion:(double)latitude longitude:(double)longitude;
-(CustomAnotation *)getAnnotation:(NSString *)title poiId:(int)pId latitude:(double)latitude longitude:(double)longitude;
-(CustomAnotation *)getAnnotation:(NSString *)title andSubtilte:(NSString *) subtitle poiId:(int)pId latitude:(double)latitude longitude:(double)longitude;
@end
