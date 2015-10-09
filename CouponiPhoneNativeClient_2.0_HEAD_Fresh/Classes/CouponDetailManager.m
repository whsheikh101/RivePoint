//
//  CouponDetailManager.m
//  RivePoint
//
//  Created by Tashfeen Sultan on 3/22/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import "CouponDetailManager.h"
#import "RivepointConstants.h"
#import "CustomIOSAlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CouponDetailManager

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

-(void)showDetailAlert: (Poi *)poi coupon:(Coupon *)coupon {
	
	if(!cdvController)
		cdvController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetail" bundle:nil];
	
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    //cdvController.view.backgroundColor = [UIColor blackColor];
//    cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
    cdvController.view.frame = CGRectMake( 0, 0, 290, 200);
    cdvController.view.layer.cornerRadius = 8;
    cdvController.view.layer.masksToBounds = YES;
    [cdvController setDetails:coupon withPoi:poi];

    //UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    //demoView  = cdvController.view;
    // Add some custom content to the alert view
    alertView.backgroundColor = [UIColor blackColor];
    [alertView setContainerView:cdvController.view];
    
    // Modify the parameters
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", nil]];
    //[alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    [alertView release];
    
     
    /*
//    UIAlertController *theAlert = [[UIAlertController alloc] initWithTitle:@"Rivepoint-Coupons on the Go" message:@"Coupon Details\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"Please wait\n\n\n"
                                                               preferredStyle:UIAlertActionStyleDefault];
	cdvController.view.backgroundColor = [UIColor clearColor];
	cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
	
	[cdvController setDetails:coupon withPoi:poi];
    [theAlert.view addSubview:cdvController.view];
    //[self presentViewController:theAlert animated:NO completion:nil];
	[theAlert show];
	[theAlert release];
	*/
}

-(void)showDetailAlertForSavedAndShared: (Poi *)poi coupon:(Coupon *)coupon andDelegate:(id<UIAlertViewDelegate>)cDelegate{
	
	if(!cdvController)
		cdvController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetail" bundle:nil];
	
	
//	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Rivepoint-Coupons on the Go" message:@"Coupon Details\n\n\n\n\n\n\n\n\n\n" delegate:cDelegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Redeem",nil];
//	theAlert.tag = k_Coupon_Alert_Tag;
//	cdvController.view.backgroundColor = [UIColor clearColor];
//	cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
////	[cdvController setDetailsForSavedAndShared:coupon withPoi:poi];
//    [cdvController setDetails:coupon withPoi:poi];
//	[theAlert addSubview:cdvController.view];
//	[theAlert show];
//	[theAlert release];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    cdvController.view.backgroundColor = [UIColor blackColor];
    //    cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
    cdvController.view.frame = CGRectMake( 0, 0, 290, 200);
    [cdvController setDetails:coupon withPoi:poi];
    
    //UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    //demoView  = cdvController.view;
    // Add some custom content to the alert view
    [alertView setContainerView:cdvController.view];
    
    // Modify the parameters
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", nil]];
    //[alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    [alertView release];
    
	
}

- (void) dealloc
{
	[cdvController release];
	[super dealloc];
}

@end
