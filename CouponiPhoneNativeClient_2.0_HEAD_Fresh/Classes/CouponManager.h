//
//  CouponManager.h
//  RivePoint
//
//  Created by Shahzad Mughal on 3/25/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coupon.h"

@interface CouponManager : NSObject {

}

-(Coupon*) findByCouponId: (int) cid;
-(NSMutableArray*) findByPoiId: (int) pid;
-(NSMutableArray*) findAll;
-(NSMutableArray*) findCouponsByPoiId: (int) pid;
-(NSMutableArray*) findLoyaltyCouponsByPoiId: (int) pid;
-(BOOL) save: (Coupon*) cpn;
-(BOOL) update: (Coupon*) cpn;
-(BOOL) saveOrUpdate: (Coupon*) cpn;
-(BOOL) poiCouponExists: (Coupon*) cpn;
-(int) getCouponsCount;
-(int) getExpiredCouponsCount;
-(BOOL) deleteCoupon: (Coupon*)cpn;
-(BOOL) savePoiCoupon: (Coupon*) cpn;
-(BOOL) deleteAll;
-(BOOL) deleteCoupons;
@end
