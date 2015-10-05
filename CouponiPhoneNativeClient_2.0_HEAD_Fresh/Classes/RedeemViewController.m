//
//  RedeemViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/26/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "RedeemViewController.h"
#import "GeneralUtil.h"

@implementation RedeemViewController
@synthesize lblRedeem,lblThanku;
@synthesize qrImage = _qrImage,qrImageView=_qrImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Redeem View Controller - Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    _qrImageView.image = _qrImage;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    _qrImageView = nil;
    lblRedeem = nil;
    lblThanku = nil;
    _qrImage = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) onNextBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) dealloc {
    [_qrImageView release];
    [lblRedeem  release];
    [lblThanku  release];
    [_qrImage  release];
    
    _qrImage= nil;
    lblRedeem = nil;
    lblThanku = nil;
    _qrImageView = nil;
    [super dealloc];
}
@end
