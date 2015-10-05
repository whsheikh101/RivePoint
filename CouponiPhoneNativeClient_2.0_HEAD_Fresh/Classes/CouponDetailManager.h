//
//  CouponDetailManager.h
//  RivePoint
//
//  Created by Tashfeen Sultan on 3/22/10.
//  Copyright 2010 rrrr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponDetailViewController.h"

@interface CouponDetailManager : NSObject<UIAlertViewDelegate> {
	CouponDetailViewController *cdvController;
}
-(void)showDetailAlert: (Poi *)poi coupon:(Coupon *)coupon;
-(void)showDetailAlertForSavedAndShared: (Poi *)poi coupon:(Coupon *)coupon andDelegate:(id<UIAlertViewDelegate>)cDelegate;
@end
