#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Coupon.h"
#import "Poi.h"

@interface CouponDetailViewController : UIViewController {
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *expiryLabel;
	IBOutlet UILabel *vendorLabel;
	IBOutlet UILabel *addressLabel;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UILabel *distanceShowLabel;
	IBOutlet UILabel *phoneLabel;
	IBOutlet UIButton *phoneButton;

}

@property (nonatomic,retain) IBOutlet UIButton *phoneButton;


- (void) setDetails:(Coupon *)coupon withPoi:(Poi *)poi; 
- (void) setDetailsForSavedAndShared:(Coupon *) withPoi:(Poi *)poi;
-(IBAction) phoneNumberClicked;
@end
