//
//  AllPhotosViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 2/6/13.
//  Copyright (c) 2013 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RivePointAppDelegate.h"
#import "XMLUtil.h"
#import "XMLPostRequest.h"
#import "UserProfileViewController.h"


@interface AllPhotosViewController : UIViewController<XMLPostRequestDelegates>
{
    IBOutlet UITableView * tableView;
    RivePointAppDelegate * appDelegate;
    IBOutlet UIView * fullImageView;
    IBOutlet CustomImage * IVFullImage;
    XMLPostRequest * fetchRequest;
}

@property (nonatomic , retain) NSMutableArray * photoArrays;
-(IBAction) onFullImageCloseClick;
@end
