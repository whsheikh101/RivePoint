//
//  SocialSettingViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/13/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "SocialSettingViewController.h"
#import "GeneralUtil.h"

@implementation SocialSettingViewController
@synthesize fbSwitch,twSwitch,emSwitch;


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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    fbSwitch = nil;
    twSwitch = nil;
    emSwitch = nil;
}


-(void)facebookLogin
{
    if (![appDelegate.facebook isSessionValid])
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                @"user_about_me",
                                @"user_status",
                                @"friends_about_me",
                                nil];
        [appDelegate.facebook authorize:permissions];
        [permissions release];
    }
    
}

-(void) twitterLogin
{
   
    if (![appDelegate.twitter isAuthorized])
    {
        
        [appDelegate.twitter requestRequestToken];
        UIViewController *controller = [[SA_OAuthTwitterController  controllerToEnterCredentialsWithTwitterEngine:appDelegate.twitter delegate:self] retain];  
        [self presentModalViewController: controller animated: YES];
    }	
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view from its nib.
    NSLog(@"My Index is : :  %d ", self.tabBarController.selectedIndex);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) onFBSwitchChangeValue
{
    NSLog(@"onFBSwitchChangeValue");
    if (self.fbSwitch.on == NO)
    {
        NSLog(@"Wnat to Off");
        [appDelegate.facebook logout:appDelegate];
    }
    else
    {
        NSLog(@"Want to On");
        [self facebookLogin];
    }
}

-(IBAction) onTWSwitchChangeValue
{
    NSLog(@"onTWSwitchChangeValue");
    if (self.twSwitch.on == NO)
    {
        NSLog(@"Wnat to Off");
        [appDelegate.twitter clearAccessToken];
        [appDelegate.twitter clearsCookies];
    }
    else
    {
        NSLog(@"Want to On");
        [self twitterLogin];
    }
}

-(IBAction) onEMSwitchChangeValue
{
    NSLog(@"onEMSwitchChangeValue");
    if (self.emSwitch.on == NO)
    {
        NSLog(@"Wnat to Off");
    }
    else
    {
        NSLog(@"Want to On");
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([appDelegate.facebook isSessionValid])
    {
        self.fbSwitch.on = YES;
    }
    else
    {
        self.fbSwitch.on = NO;
    }
    
    if ([appDelegate.twitter isAuthorized])
    {
        self.twSwitch.on = YES;
    }
    else
    {
        self.twSwitch.on = NO;
    }
    
}

#pragma mark -
#pragma mark SA_TwiterEngineViewController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
	NSLog(@"Authenicated for %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

@end
