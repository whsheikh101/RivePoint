//
//  User.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/18/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *sid;
	NSString *uid;
	NSString *pwd;
	NSString *email;
}
@property (nonatomic,retain) NSString *sid;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *pwd;
@property (nonatomic,retain) NSString *email;


@end
