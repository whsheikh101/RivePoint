//
//  ViewAllCouponViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 12/6/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "XMLPostRequest.h"

@protocol ViewAllCouponDelegate <NSObject>

-(void) favoritePOIViewedWithFinalArray:(NSArray *)array;
-(void) savedCouponViewedWithFinalArray:(NSArray *)array;
-(void) sharedCouponViewedWithFinalArray:(NSArray *)array;

@end

@interface ViewAllCouponViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,XMLPostRequestDelegates>
{
    IBOutlet UITableView * tableView;
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblCount;
    NSIndexPath * curIndexPath;
    RivePointAppDelegate * appDelegate;
    BOOL isSaved;
    BOOL isShared;
    BOOL isEditable;
    IBOutlet UIButton * editBtn;
    id<ViewAllCouponDelegate>delegate;
    XMLPostRequest * fetchRequest;
    BOOL shouldNotRemove;
    BOOL isDidLoadCalled;
}
@property (nonatomic , retain) Coupon * curSelectedCoupon;
@property (nonatomic , retain) NSIndexPath * curIndexPath;
@property (nonatomic , retain) NSMutableArray * couponArray;
@property (nonatomic , copy) NSString * cVtitle;
@property (nonatomic )BOOL isSavedCoupon;
@property (nonatomic , retain)id<ViewAllCouponDelegate>delegate;

-(IBAction) onDeleteAllBtn;
-(IBAction) onEditBtn;

@end
