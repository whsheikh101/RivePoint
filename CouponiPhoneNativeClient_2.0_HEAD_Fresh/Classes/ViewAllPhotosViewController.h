//
//  ViewAllPhotosViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 12/6/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "XMLPostRequest.h"
#import "UserProfileViewController.h"
#import "CustomImage.h"

@interface ViewAllPhotosViewController : UIViewController<XMLPostRequestDelegates,imageTouchedDelegate>
{
    IBOutlet UIScrollView * scrollView;
    RivePointAppDelegate * appDelegate;
    IBOutlet UIView * fullImageView;
    IBOutlet CustomImage * IVFullImage;
    XMLPostRequest * fetchRequest;
    IBOutlet UIActivityIndicatorView * activityWheel;
}

@property (nonatomic , retain) NSMutableArray * photoArrays;
-(IBAction) onFullImageCloseClick;
@end
