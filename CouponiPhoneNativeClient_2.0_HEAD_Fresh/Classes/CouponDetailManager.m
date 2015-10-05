//
//  CouponDetailManager.m
//  RivePoint
//
//  Created by Tashfeen Sultan on 3/22/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import "CouponDetailManager.h"
#import "RivepointConstants.h"

@implementation CouponDetailManager

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{






}

-(void)showDetailAlert: (Poi *)poi coupon:(Coupon *)coupon {
	
	if(!cdvController)
		cdvController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetail" bundle:nil];
	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Rivepoint-Coupons on the Go" message:@"Coupon Details\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	cdvController.view.backgroundColor = [UIColor clearColor];
	cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
	
	[cdvController setDetails:coupon withPoi:poi];
	[theAlert addSubview:cdvController.view];
	[theAlert show];
	[theAlert release];
	
}

-(void)showDetailAlertForSavedAndShared: (Poi *)poi coupon:(Coupon *)coupon andDelegate:(id<UIAlertViewDelegate>)cDelegate{
	
	if(!cdvController)
		cdvController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetail" bundle:nil];
	
	
	UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Rivepoint-Coupons on the Go" message:@"Coupon Details\n\n\n\n\n\n\n\n\n\n" delegate:cDelegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Redeem",nil];
	theAlert.tag = k_Coupon_Alert_Tag;
	cdvController.view.backgroundColor = [UIColor clearColor];
	cdvController.view.frame = CGRectMake(18.0, 80.0, 260.0, 200.0);
//	[cdvController setDetailsForSavedAndShared:coupon withPoi:poi];
    [cdvController setDetails:coupon withPoi:poi];
	[theAlert addSubview:cdvController.view];
	[theAlert show];
	[theAlert release];
	
}

- (void) dealloc
{
	[cdvController release];
	[super dealloc];
}

@end
