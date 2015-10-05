#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CouponViewController.h"
#import "CustomUIImageView.h"

@interface CouponView :CustomUIImageView /* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet CouponViewController *cvController;
}

@end
