//
//  LoginViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/28/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "LoginViewController.h"
#import "GeneralUtil.h"
#import "RegisterViewController.h"
#import "StringUtil.h"

@implementation LoginViewController
@synthesize delegate;
@synthesize CalledType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

-(void) showAlertWithHeading:(NSString *)heading andDesc:(NSString *)desc
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:heading message:desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Login View Controller - Receive Memory Warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    if (self.CalledType == 1) {
        [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbarBG.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        toolBar.hidden = YES;
        NSArray * _loginViewsArray = [self.view subviews];
        for (UIView * loginSV in _loginViewsArray) {
            loginSV.frame = CGRectMake(loginSV.frame.origin.x, loginSV.frame.origin.y-44, loginSV.frame.size.width, loginSV.frame.size.height);
        }
    }
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    tfPaswrd = nil;
    tfEmail = nil;
    toolBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    tfEmail.text = @"";
    tfPaswrd.text = @"";
    
}

-(IBAction) onLoginBtn
{
    NSString * _mail = tfEmail.text;
    NSString * _pswd = tfPaswrd.text;
    if (_mail && _mail.length > 0 && [StringUtil validateEmail:_mail])
    {
        if (_pswd && _pswd.length > 0)
        {
            [appDelegate progressHudView:self.view andText:@"Loading..."];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"email" andValue:_mail];
            NSString * param2 = [XMLUtil getParamXMLWithName:@"pwd" andValue:_pswd];
            NSString * param3 = [XMLUtil getParamXMLWithName:@"sid" andValue:appDelegate.setting.subsId];
            NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
            NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"loginUser" andParams:params];
            XMLPostRequest * request = [[XMLPostRequest alloc]init];
            request.delegate = (id) self;
            [request sendPostRequestWithRequestName:k_User_Login andRequestXML:reviewReqXML];
            [request release];
        }
        else
            [self showAlertWithHeading:@"Error" andDesc:@"Please enter your password!"];
    }
    else
    {
        tfEmail.text = @"";
        tfPaswrd.text = @"";
        [self showAlertWithHeading:@"Error" andDesc:@"Please enter valid email address!"];
    }
        
    
    
    
}

-(void) userSuccessfullyLoggedinWithId:(NSString *)userId
{
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
    if ([userId isEqualToString:@"-1"]) 
    {
        tfPaswrd.text = @"";
        [self showAlertWithHeading:@"Error" andDesc:@"Invalid user email or password!"];
    }
    else
    {   
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:k_LoggedIn_User_Id];
        [[NSUserDefaults standardUserDefaults] setValue:tfEmail.text forKey:k_User_Email];
        [[NSUserDefaults standardUserDefaults] setValue:tfPaswrd.text forKey:k_User_Password];
        if (self.CalledType == 0) {
            [[self delegate] userLoggedinSuccessfully];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
        
}
-(void) requestFailWithError:(NSString *)errorMsg
{
//    [self showAlertWithHeading:@"Error" andDesc:errorMsg];
}

-(IBAction) onCancelBtn
{
    if (self.CalledType == 0) {
        [appDelegate gotoFirstPOITabFromController:self.navigationController];
    }
    else
        [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) onRegisterBtn
{
    if (self.CalledType == 0) {
        RegisterViewController * viewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
        viewController.isUserUpdate = NO;
        viewController.calledType = 0;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
    {
        [self dismissModalViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_RP_Register_Call object:nil userInfo:nil];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfEmail) {
        if ([StringUtil validateEmail:tfEmail.text]) {
            [tfPaswrd becomeFirstResponder];
        }
        else
        {
            tfEmail.text = @"";
            tfPaswrd.text = @"";
            [self showAlertWithHeading:@"Info" andDesc:@"Please enter a valid email address!"];
        }
            
        
    }
    if (textField == tfPaswrd) {
        [tfPaswrd resignFirstResponder];
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tfEmail resignFirstResponder];
    [tfPaswrd resignFirstResponder];
}

-(void) dealloc
{
    
    [tfPaswrd release];
    [tfEmail release];
    [toolBar release];
    toolBar = nil;
    [super dealloc];
}

@end
