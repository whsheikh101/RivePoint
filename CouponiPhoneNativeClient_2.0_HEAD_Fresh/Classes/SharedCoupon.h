//
//  SharedCoupon.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/3/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SharedCoupon : NSObject {
	NSString *sndrId;
	NSString *sndrEmail;
	NSString *tCntSUsr;
}

@property (nonatomic,retain) NSString *sndrId;
@property (nonatomic,retain) NSString *sndrEmail;
@property (nonatomic,retain) NSString *tCntSUsr;

@end
