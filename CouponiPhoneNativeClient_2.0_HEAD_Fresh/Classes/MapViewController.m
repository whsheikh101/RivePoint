//
//  MapViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 10/25/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "MapViewController.h"
#import "RivePointAppDelegate.h"
#import "ListCouponsViewController.h"
#import "PoiManager.h"

@implementation MapViewController
@synthesize mapView;


-(IBAction)dismissPresentViewController{
    
//    mapView.delegate = nil;
    [self.mapView setDelegate:nil];
	[self dismissModalViewControllerAnimated:YES];
	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[mapView setMapType:MKMapTypeStandard];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
	[mapView setDelegate:self];	
	
	appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
		
	
	/*appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(listCouponsViewController){
		
		customAnotation = [[CustomAnotation alloc] initWithCoordiantes:[[[GeneralUtil getPoi]latitude] doubleValue] 
															 longitude:[[[GeneralUtil getPoi]longitude] doubleValue] 
																 title:nil subtitle:nil];
		newCustomAnotation = [[CustomAnotation alloc] initWithCoordiantes:[appDelegate.setting.latitude doubleValue] 
																				 longitude:[appDelegate.setting.longitute doubleValue] 
																					 title:nil subtitle:nil];
		[mapView setDelegate:self];
		
		
		[mapView addAnnotation:newCustomAnotation];
		
	
	}else {
		customAnotation = [[CustomAnotation alloc] initWithCoordiantes:[appDelegate.setting.latitude doubleValue] 
															 longitude:[appDelegate.setting.longitute doubleValue] 
																 title:nil subtitle:nil];
		
	}

	
	[mapView addAnnotation:customAnotation];
	//mapView.showsUserLocation = YES;*/
}

- (void)viewWillAppear:(BOOL)animated{
	
	[mapView removeAnnotations:annotaionArray];
	
	if(annotaionArray){
		[annotaionArray release];
	}
	
	annotaionArray = [[NSMutableArray alloc]init];
	userAnotation = [self getAnnotation:@"You" poiId:0 latitude:[appDelegate.setting.latitude doubleValue] longitude:[appDelegate.setting.longitute doubleValue]];
	[annotaionArray addObject:userAnotation];
	[mapView setRegion:mapRegion animated:YES];

		
	if(mainViewController){
		
		NSMutableArray *poiArray = [appDelegate poiArray];
		
		int poiIndex = 0;
		for (poi in poiArray) {
            
            NSString * _pName = [NSString stringWithFormat:@"%@ (%@)",poi.name,poi.couponCount];
            NSString * _pAddres = [NSString stringWithFormat:@"%@ (%@ miles)",poi.completeAddress,poi.distance];
            
//			customAnotation = [self getAnnotation:[NSString stringWithFormat:@"%@ (%@)", poi.name,poi.couponCount] poiId:poiIndex latitude:[poi.latitude doubleValue] longitude:[poi.longitude doubleValue]];
            
            customAnotation = [self getAnnotation:_pName andSubtilte:_pAddres poiId:poiIndex latitude:[poi.latitude doubleValue] longitude:[poi.longitude doubleValue]];

			[annotaionArray addObject:customAnotation];
			poiIndex++;
		}
	
	}else if(listCouponsViewController){
		poi = [GeneralUtil getPoi];				
		
        NSString * _pName = [NSString stringWithFormat:@"%@ (%@)",poi.name,poi.couponCount];
        NSString * _pAddres = [NSString stringWithFormat:@"%@ (%@ miles)",poi.completeAddress,poi.distance];
        
//		customAnotation = [self getAnnotation:[NSString stringWithFormat:@"%@ (%@)", poi.name,poi.couponCount] poiId:0 latitude:[poi.latitude doubleValue] longitude:[poi.longitude doubleValue]];
        
//        customAnotation = [self getAnnotation:_pName andSubtilte:_pAddres poiId:0 latitude:[poi.latitude doubleValue] longitude:[poi.longitude doubleValue]];
        MapPoint *dealPin = [[MapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([poi.latitude doubleValue], [poi.longitude doubleValue]) title:_pName subtitle:_pAddres with:0];
		[annotaionArray addObject:dealPin];
		
		[mapView setRegion:mapRegion animated:YES];
				
		}
		
	[mapView addAnnotations:annotaionArray];
		
	
	if(listCouponsViewController){
		
		[mapView selectAnnotation:customAnotation animated:NO];
	
	}else if(!mainViewController){
		[mapView selectAnnotation:userAnotation animated:NO];
	}
	
}

-(void) viewWillDisappear:(BOOL)animated
{
    if (!listCouponsViewController) {
        NSArray * anoViews = [mapView subviews];
        for (UIView * curAnoView in anoViews) {
            [curAnoView removeFromSuperview];
        }
        [mapView removeAnnotations:annotaionArray];
        [annotaionArray removeAllObjects];
    }
    [super viewWillDisappear:YES];
}

/*
- (void)viewDidDisappear:(BOOL)animated{
	
}*/

-(MKCoordinateRegion)getCoordinateRegion:(double)latitude longitude:(double)longitude{
	MKCoordinateRegion annotaionRegion = {{0.0},{0.0}};
	annotaionRegion.center.latitude = latitude;
	annotaionRegion.center.longitude = longitude;
	if(!listCouponsViewController){
		annotaionRegion.span.longitudeDelta = 0.1;
		annotaionRegion.span.latitudeDelta = 0.1;
	}else{
		annotaionRegion.span.longitudeDelta = 0.2;
		annotaionRegion.span.latitudeDelta = 0.2;
	}
	return annotaionRegion;
	
}

-(void)setMapPosition:(double)latitude longitude:(double)longitude{
	[self zoomToFitMapAnnotations:latitude longitude:longitude];
		
}
-(void)zoomToFitMapAnnotations:(double)latitude longitude:(double)longitude
{
    //if([mapView.annotations count] == 0)
     //   return;
    /*
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -mapView.userLocation.location.coordinate.latitude;
    topLeftCoord.longitude = -mapView.userLocation.location.coordinate.longitude;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = mapView.userLocation.location.coordinate.latitude;
    bottomRightCoord.longitude = mapView.userLocation.location.coordinate.longitude;
	*/
	CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

	topLeftCoord.longitude = fmin(topLeftCoord.longitude, longitude);
	topLeftCoord.latitude = fmax(topLeftCoord.latitude, latitude);
	
	bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, longitude);
	bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, latitude);

    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = 0.01; // Add a little extra space on the sides
    region.span.longitudeDelta = 0.01; // Add a little extra space on the sides
    
//	NSLog(@"region.span.longitudeDelta : %f",region.span.latitudeDelta);
//	NSLog(@"region.span.longitudeDelta : %f",region.span.longitudeDelta);
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
}


- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
	
    
	MKAnnotationView *annotationView;
	
	if(annotation == userAnotation){
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"user"];
		[annotationView setCanShowCallout:YES];
		[annotationView setImage:[UIImage imageNamed:@"user.png"]];
			
	}else
    {
        
        CustomAnotation *ann = (CustomAnotation *) annotation;
        CustomAnotation * _curAnnotation = [self getAnnotation:@"" poiId:ann.poiIndex latitude:ann.coordinate.latitude longitude:ann.coordinate.longitude];
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:_curAnnotation reuseIdentifier:@"pin"];
        [annotationView setCanShowCallout:YES];
        
//        UILabel * lblHide1 =(UILabel *) [annotationView viewWithTag:1];
//        if (lblHide1) {
//            lblHide1.hidden = YES;
//        }
        
        if (!listCouponsViewController) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			button.tag = [ann poiIndex];
            [button addTarget:self action:@selector(showCouponListViewController:)  forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = button;
        }
        /*
            UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,50)];
            
            UILabel * lblMain = [[UILabel alloc]initWithFrame:CGRectMake(0,-7, 250, 20)];
            lblMain.backgroundColor = [UIColor clearColor];
            lblMain.font = [UIFont boldSystemFontOfSize:14];
            lblMain.textColor =[UIColor blackColor];
            lblMain.text = ann.title;
            [leftCAV addSubview:lblMain];
            [lblMain release];
            
            UILabel * lblSub = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 250, 35)];
            lblSub.backgroundColor = [UIColor clearColor];
            lblSub.font = [UIFont systemFontOfSize:11];
            lblSub.textColor = [UIColor blackColor];
            lblSub.lineBreakMode = UILineBreakModeWordWrap;
            lblSub.numberOfLines = 2;
            lblSub.text = ann.subtitle;
            [leftCAV addSubview:lblSub];
            [lblSub release];
            annotationView.leftCalloutAccessoryView = leftCAV;
        [leftCAV release];
         */
        
    }
	return annotationView;
}


-(IBAction)showCouponListViewController:(UIView *) sender{
		
	appDelegate.currentPoiCommand = GET_COUPONS;
	appDelegate.poiId = sender.tag ;
	ListCouponsViewController *listCouponController = [[ListCouponsViewController alloc]init];
	[self dismissModalViewControllerAnimated:YES];
	[mainViewController.navigationController pushViewController:listCouponController animated:NO];
//	[listCouponsViewController release];
    [listCouponController release];
}



- (void) mapViewDidFinishLoadingMap: (MKMapView *) map{
	if(listCouponsViewController){
		[map selectAnnotation:customAnotation animated:YES];
					
	}else if(!mainViewController){
		[map selectAnnotation:userAnotation animated:YES];
	}
	
}



-(void)setListCouponViewController:(ListCouponsViewController *)viewController{
	listCouponsViewController = viewController; 
}

-(void)setMainViewController:(MainViewController *)viewController{
	mainViewController = viewController; 
}

-(CustomAnotation *)getAnnotation:(NSString *)title poiId:(int)poiId latitude:(double)latitude longitude:(double)longitude{

	[anotation release];

	anotation = [[CustomAnotation alloc]init];
	anotation.title = title;
	anotation.poiIndex = poiId;
	mapRegion = [self getCoordinateRegion:latitude longitude:longitude]; 
	anotation.coordinate = mapRegion.center;
	
	return anotation; 
	
}

-(CustomAnotation *)getAnnotation:(NSString *)title andSubtilte:(NSString *)subtitle poiId:(int)poiId latitude:(double)latitude longitude:(double)longitude
{
    [anotation release];
    
	anotation = [[CustomAnotation alloc]init];
	anotation.title = title;
    anotation.subtitle = subtitle;
	anotation.poiIndex = poiId;
	mapRegion = [self getCoordinateRegion:latitude longitude:longitude]; 
	anotation.coordinate = mapRegion.center;
	
	return anotation; 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    NSLog(@"MapViewController  didReceiveMemoryWarning");
    mapView = nil;
    anotation = nil;
    listCouponsViewController = nil;
    annotaionArray = nil;
    
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    NSLog(@"MapViewButton  viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [super viewDidUnload];
    mapView = nil;
    anotation = nil;
    listCouponsViewController = nil;
    annotaionArray = nil;
    
}


- (void)dealloc {
	[mapView release];
    if (anotation) {
        [anotation release];
        anotation = nil;
    }   
//    if (listCouponsViewController) {
//        [listCouponsViewController release];
//        listCouponsViewController = nil;
//    }
	[annotaionArray release];
	mapView = nil;
    annotaionArray = nil;
    
    [super dealloc];
}


@end
