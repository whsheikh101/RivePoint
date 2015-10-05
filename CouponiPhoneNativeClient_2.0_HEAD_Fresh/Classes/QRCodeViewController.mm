//
//  QRCodeViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 6/6/11.
//  Copyright 2011 Netpace Systems. All rights reserved.
//

#import "QRCodeViewController.h"
//#import "ZXingWidgetController.h"
//#import "QRCodeReader.h"
#import "CouponViewController.h"
@implementation QRCodeViewController
@synthesize coupon;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (RivePointAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    poi = [GeneralUtil getPoi];
    [self openZxingController];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)openZxingController{
    
//    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
//    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
//    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
//    [qrcodeReader release];
//    widController.readers = readers;
//    [readers release];
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    widController.soundToPlay =
//    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
//    [self presentModalViewController:widController animated:YES];
//   // [widController release];
    
}
//- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
//    //self.resultsToDisplay = result;
//    if (self.isViewLoaded) {
//        //  [label setText:resultsToDisplay];
//        
//        //   [resultsView setNeedsDisplay];
//        
//        NSArray *qrcodeComponents = [result componentsSeparatedByString:@"<sep>"];
//        int poiId = [[qrcodeComponents objectAtIndex:0]intValue];
//        //int vendorId = [[qrcodeComponents objectAtIndex:0]intValue];
//        //UIAlertView *alertView = nil;
//        if ([poi.poiId intValue] == poiId) {
//            /*alertView = [[UIAlertView alloc]initWithTitle:@"QRCode" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [alertView show];*/
//            [self dismissModalViewControllerAnimated:NO];
//            if(cvController == nil)
//                cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
//            cvController.isSaved = couponViewCell.isSaved;
//            cvController.numberOfPOICoupons = couponViewCell.numberOfPOICoupons;
//            cvController.hidesBottomBarWhenPushed = YES;
//            [cvController setIsLoyaltyPoi:YES];
//            appDelegate.couponId = [coupon.couponId intValue];
//            appDelegate.couponIndex = couponViewCell.couponIndex;
//            //[self dontReturnToRoot];
//            [[self navigationController] pushViewController:cvController animated:YES];
//        }else{
//            [self dismissModalViewControllerAnimated:NO];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Invalid QRCode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            [alertView release];
//        }
//        
//    }
//    
//    
//}
//
//- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
//    [controller dismissModalViewControllerAnimated:YES];
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//}
-(void) setCouponViewCell:(CouponViewCell *)cell{
    couponViewCell = cell;
}

@end
