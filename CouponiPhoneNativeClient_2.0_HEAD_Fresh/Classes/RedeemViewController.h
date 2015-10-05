//
//  RedeemViewController.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/26/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemViewController : UIViewController
{
    
}

@property (nonatomic , retain) IBOutlet UIImageView * qrImageView;
@property (nonatomic , retain) IBOutlet UILabel * lblRedeem;
@property (nonatomic , retain) IBOutlet UILabel * lblThanku;
@property (nonatomic , retain) UIImage * qrImage;

-(IBAction) onNextBtn;

@end
