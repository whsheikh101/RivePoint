//
//  PhotoUploadViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/12/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#define K_IMAGE_UPLOAD_URL @"http://192.168.1.192/WebTest/fileupload/doUpload.action"

#import "PhotoUploadViewController.h"
#import "MBProgressHUD.h"
#import "GeneralUtil.h"
#import "RivePointSetting.h"
#import "XMLUtil.h"
//#import "NSDataAdditions.h"
#import "Base64.h"
#import "StringUtil.h"
#import "RivepointConstants.h"

@implementation PhotoUploadViewController
@synthesize lblEmail=_lblEmail,lblShare=_lblShare,lblTwitter=_lblTwitter,lblFacebook=_lblFacebook;
@synthesize facebookBtn = _facebookBtn,twitterBtn=_twitterBtn,emailBtn=_emailBtn,uploadBtn=_uploadBtn;
@synthesize pickedImage=_pickedImage, shareViewBGImage=_shareViewBGImage, captionText=_captionText;
//@synthesize image=_image;
@synthesize shareBtn=_shareBtn;
@synthesize curImageID=_curImageID;
@synthesize curPOI=_curPOI;
@synthesize delegate;
@synthesize curEmailForShare=_curEmailForShare;
@synthesize imageData = _imageData;

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
    
    NSLog(@"Photo Upload View Controller - Receive Memory Warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void) dealloc
{
    NSLog(@"Upload Photo Dealloc Called...In");
    [_lblTwitter release];
    [_lblShare release];
    [_lblFacebook release];
    [_lblEmail release];
    [_facebookBtn release];
    [_twitterBtn release];
    [_emailBtn release];
    [_uploadBtn release];
    [_pickedImage release];
    [_shareViewBGImage release];
    if (_captionText) {
        [_captionText release];
        _captionText = nil;
    }
    
//    [_image release];
    [_imageData release];
    [_shareBtn release];
    [_curImageID release];
    
    _lblTwitter = nil;
    _lblShare = nil;
    _lblFacebook = nil;
    _lblEmail = nil;
    _facebookBtn = nil;
    _twitterBtn = nil;
    _emailBtn = nil;
    _uploadBtn = nil;
    _pickedImage = nil;
    _shareViewBGImage = nil;
    _imageData = nil;
    _shareBtn = nil;
    _curImageID = nil;
    
    [super dealloc];
    NSLog(@"Upload Photo Dealloc Called...Out");
}

-(void) callCountBack
{
    callCount--;
    if (callCount==0) {
//        [appDelegate.progressHud removeFromSuperview];
        [appDelegate removeLoadingViewFromSuperView];
        _shareBtn.hidden = YES;
    }
}

-(UIImage *)imageWithImage:(UIImage *)_image1 scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - View lifecycle

-(void) ArrangeScreenDataForBeforUpload
{
    _shareViewBGImage.hidden = YES;
    _lblEmail.hidden = YES;
    _lblFacebook.hidden = YES;
    _lblShare.hidden = YES;
    _lblTwitter.hidden = YES;
    _facebookBtn.hidden = YES;
    _twitterBtn.hidden = YES;
    _emailBtn.hidden = YES;
    _uploadBtn.hidden = NO;
    _shareBtn.hidden = YES;
}

-(void) ArrangeScreenDataAfterUpload
{
    _shareViewBGImage.hidden = NO;
    _lblEmail.hidden = NO;
    _lblFacebook.hidden = NO;
    _lblShare.hidden = NO;
    _lblTwitter.hidden = NO;
    _facebookBtn.hidden = NO;
    _twitterBtn.hidden = NO;
    _emailBtn.hidden = NO;
    _uploadBtn.hidden = YES;
    _shareBtn.hidden = NO;
//    [self.facebookBtn setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
//    [self.twitterBtn setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
//    [self.emailBtn setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
}

- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    // This key must match the key in postNotificationWithString: exactly.
    if ([appDelegate.facebook isSessionValid]) {
        [_facebookBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
        isFacebook = YES;
        _lblFacebook.textColor = [UIColor blackColor];
    }
    
}

-(void) TweetedSuccessfull
{
    isTwitter = NO;
    lblTWStatus.hidden = NO;
    lblTWStatus.textColor = [UIColor blackColor];
    lblTWStatus.text = @"Tweeted successfully";
    [self callCountBack];
}

-(void) TweetFail
{
    isTwitter = YES;
    _shareBtn.hidden = NO;
    lblTWStatus.hidden = NO;
    lblTWStatus.textColor = [UIColor redColor];
    lblTWStatus.text = @"Tweeted unsuccessfull";
    [self callCountBack];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    callCount = 0;
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    
    isCaptionBlank = YES;
    [GeneralUtil setRivepointLogo:self.navigationItem];
    [self ArrangeScreenDataForBeforUpload];
    currentUploadBytes = 0;
    isEmail = NO;
    isFacebook = NO;
    isTwitter = NO;
    lblFBStatus.hidden = YES;
    lblMailStatus.hidden = YES;
    lblTWStatus.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    _pickedImage.contentMode = UIViewContentModeScaleAspectFit;
    [_pickedImage setImage:[self imageWithImage:[UIImage imageWithData:_imageData] scaledToSize:CGSizeMake(96, 96)]];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(useNotificationWithString:) 
	 name:k_FB_Share_Notification
	 object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TweetedSuccessfull) name:k_Tweet_Successful object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TweetFail) name:k_Tweet_Fail object:nil];

}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    _lblTwitter = nil;
    _lblShare = nil;
    _lblFacebook = nil;
    _lblEmail = nil;
    _facebookBtn = nil;
    _twitterBtn = nil;
    _emailBtn = nil;
    _uploadBtn = nil;
    _pickedImage = nil;
    _shareViewBGImage = nil;
    if (_captionText) {
        _captionText = nil;
    }
    _imageData = nil;
    _shareBtn = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction) onUplaodBtn
{
    //[self showProgressHUD];
    [_captionText resignFirstResponder];
    [self UploadImageToServer];
//    [self ArrangeScreenDataAfterUpload];
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

-(NSString*)encodeURL:(NSString *)string
{
    NSString *newString = [(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
    
    if (newString) 
    {
        return newString;
    }
    
    return @"";
}



-(IBAction) onShareBtn
{
    if (isFacebook==YES || isTwitter ==YES || isEmail==YES) {
        _shareBtn.hidden = YES;
    }
        
    if (isFacebook == YES) {
        callCount++;
        NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *urlFileName = @"url";
        NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
        NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
        NSString * _url = [NSString stringWithFormat:@"%@servlet/ImageServlet?type=6&photoId=%@",prefixURL,_curImageID];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       FACEBOOK_API_KEY, @"app_id",
                                       _url, @"link",
                                       nil];
        [appDelegate.facebook requestWithGraphPath:@"me/links" andParams:params andHttpMethod:@"POST" andDelegate:self];
//        [params release];
    }
    
    if (isTwitter == YES) {
        if ([appDelegate.twitter isAuthorized]) {
            callCount++;
            appDelegate.shouldNotShareAlert = YES;
            NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
            NSString *urlFileName = @"url";
            NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
            NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
            NSString * _url = [NSString stringWithFormat:@"%@servlet/ImageServlet?type=6&photoId=%@",prefixURL,_curImageID];
            [appDelegate.twitter sendUpdate:[NSString stringWithFormat:@"%@ ",_url]];
        }
    }
    
    if (isEmail == YES) {
        callCount++;
        NSString * param1 = [XMLUtil getParamXMLWithName:@"subject" andValue:@"Shared via RivePoint"];
        NSString * param2 = [XMLUtil getParamXMLWithName:@"rcvrEmail" andValue:_curEmailForShare];
        NSString * sndrMail = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Name];
        NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *urlFileName = @"url";
        NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
        NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
        NSString * _url = [NSString stringWithFormat:@"%@servlet/ImageServlet?type=6&photoId=%@",prefixURL,_curImageID];
        NSString *encodedURl = [self encodeURL:_url];
        NSString * body =[NSString stringWithFormat:@"Hi, \n%@ has shared a picture with you. Please visit %@ to view it!",sndrMail,encodedURl];
        NSString * param3 = [XMLUtil getParamXMLWithName:@"emailBody" andValue:body];
        NSString * params = [NSString stringWithFormat:@"%@%@%@",param2,param1,param3];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Share_Image_Command andParams:params];
        request = [[XMLPostRequest alloc]init];
        request.delegate = (id) self;
        [request sendPostRequestWithRequestName:k_Share_Image_Command andRequestXML:reviewReqXML];
//        [request release];
    }
    if (callCount>0) {
        [appDelegate progressHudView:self.view andText:@"Sharing..."];
    }
}

-(IBAction) onFacebookBtn
{
    if ([appDelegate.facebook isSessionValid]) {
        if (isFacebook == NO)
        {
            [_facebookBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
            _lblFacebook.textColor = [UIColor blackColor];
            isFacebook = YES;
        }
        else
        {
            [_facebookBtn setImage:[UIImage imageNamed:@"sas.png"] forState:UIControlStateNormal];
            _lblFacebook.textColor = [UIColor grayColor];
            isFacebook = NO;
        }
    }
    else
    {
        [self facebookLogin];
    }
    
}

-(IBAction) onTwitterBtn
{
    if ([appDelegate.twitter isAuthorized]) {
        if (isTwitter == NO)
        {
            [_twitterBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
            _lblTwitter.textColor = [UIColor blackColor];
            isTwitter = YES;
        }
        else
        {
            [_twitterBtn setImage:[UIImage imageNamed:@"dsd.png"] forState:UIControlStateNormal];
            _lblTwitter.textColor = [UIColor grayColor];
            isTwitter = NO;
        }
    }
    else
    {
        [self twitterLogin];
    }
}

-(void) callEmailInput
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter email address!" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    myAlertView.tag = 1606;
    tfEmail.placeholder=@"Enter you recipent email";
    [tfEmail becomeFirstResponder];
    tfEmail.delegate = (id) self;
    [tfEmail setBackgroundColor:[UIColor whiteColor]];
    tfEmail.textAlignment=UITextAlignmentCenter;
    tfEmail.returnKeyType = UIReturnKeyDone;
    tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [myAlertView addSubview:tfEmail];
    [myAlertView show];
    [myAlertView release];

}


-(IBAction) onEmailBtn
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        BOOL emailEnable = [[NSUserDefaults standardUserDefaults] boolForKey:k_Email_Enable];
        if (emailEnable == YES) {
            if (isEmail == NO)
            {
                [self callEmailInput];
            }
            else
            {
                [_emailBtn setImage:[UIImage imageNamed:@"sdsd.png"] forState:UIControlStateNormal];
                _lblEmail.textColor = [UIColor grayColor];
                isEmail = NO;
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Want to enable email sharing?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 96845;
            [alert show];
            [alert release];
        }
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
        
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1606)
    {
        if (buttonIndex == 1)
        {
            NSString * _email = tfEmail.text;
            if ([StringUtil validateEmail:tfEmail.text]) {
                
                [_emailBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
                _lblEmail.textColor = [UIColor blackColor];
                isEmail = YES;
                _curEmailForShare = [_email copy];
            }
            else
            {
                UIAlertView * alertE = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter valid email address!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                alertE.tag = 81846;
                [alertE show];
                [alertE release];
            }
        }
    }
    if (alertView.tag == 96845) {
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k_Email_Enable];
//            isEmail = YES;
//            self.lblEmail.textColor = [UIColor blackColor];
//            [emailBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
            [self callEmailInput];
        }
    }
    if (alertView.tag == 81846) {
        if (buttonIndex == 1) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter email address!" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
            myAlertView.tag = 1606;
            tfEmail.placeholder=@"Enter you recipent email";
            [tfEmail becomeFirstResponder];
            tfEmail.delegate = (id) self;
            [tfEmail setBackgroundColor:[UIColor whiteColor]];
            tfEmail.textAlignment=UITextAlignmentCenter;
            tfEmail.returnKeyType = UIReturnKeyDone;
            tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
            [myAlertView addSubview:tfEmail];
            [myAlertView show];
            [myAlertView release];
        }
    }
}

-(void)imageSharedViaEmail:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [self callCountBack];
    if ([status isEqualToString:@"true"]) {
        
//        [appDelegate showAlertWithHeading:@"Email sent successfully" andDesc:@""];
        isEmail = NO;
        lblMailStatus.hidden = NO;
        lblMailStatus.textColor = [UIColor blackColor];
        lblMailStatus.text = @"Email sent successfully";
        
    }
    if ([status isEqualToString:@"false"]) {
        
//        [appDelegate showAlertWithHeading:@"Email sent fail" andDesc:@""];
        isEmail = YES;
        _shareBtn.hidden =NO;
        lblMailStatus.hidden = NO;
        lblMailStatus.textColor = [UIColor redColor];
        lblMailStatus.text = @"Email sending failed";
    }
    [_curEmailForShare release];
    request.delegate = nil;
    [request release];
    request = nil;
}

-(void) poiPhotoUploadedWithStatusCode:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"0"]) {
        
        [appDelegate showAlertWithHeading:@"Upload image fail" andDesc:@""];
    }
    else
    {
        [appDelegate showAlertWithHeading:@"Image uploaded successfully" andDesc:@""];
        [[self delegate] photoUploadedWithPhotoId:status];
    }
    _curImageID = [status copy];
    [self ArrangeScreenDataAfterUpload];
    request.delegate = nil;
    [request release];
    request = nil;
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [self callCountBack];
}

//change this attachment upload function so that it could upload multiple attachments
-(void) UploadImageToServer
{
    
   // [appDelegate showActivityViewer];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        [appDelegate progressHudView:self.view andText:@"uploading..."];
        NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:_curPOI.poiId];
//        NSData *imageData = UIImageJPEGRepresentation(_image, K_Image_Compress_Quality);
        NSString * imageSTR = [_imageData base64Encoding];
        NSString * param2 = [XMLUtil getParamXMLWithName:@"imageBytes" andValue:imageSTR];
        NSString * param3 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
        NSString * param4 = [XMLUtil getParamXMLWithName:@"desc" andValue:_captionText.text];
        NSString * params = [NSString stringWithFormat:@"%@%@%@%@",param1,param2,param3,param4];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"addPoiPhoto" andParams:params];
        request = [[XMLPostRequest alloc]init];
        request.delegate = (id) self;
        [request sendPostRequestWithRequestName:k_Add_Poi_Photo andRequestXML:reviewReqXML];
//        [request release];  
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
    
}


#pragma mark -----   DELEGATE -------------
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (isCaptionBlank == YES)
    {
        isCaptionBlank = NO;
        _captionText.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

#pragma mark -
#pragma mark SA_TwiterEngineViewController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
    [_twitterBtn setImage:[UIImage imageNamed:@"Share-select-checked.png"] forState:UIControlStateNormal];
    _lblTwitter.textColor = [UIColor blackColor];
    isTwitter = YES;
    controller.delegate = nil;
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Twitter Authentication Canceled.");
}

#pragma mark -
#pragma mark Facebook
-(void) request:(FBRequest *)request1 didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
    request1.delegate = nil;
//    [appDelegate.progressHud removeFromSuperview];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon sharing on your wall has fail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    
    isFacebook = YES;
    _shareBtn.hidden = NO;
    lblFBStatus.hidden = NO;
    lblFBStatus.textColor = [UIColor redColor];
    lblFBStatus.text = @"Fail to post";
    [self callCountBack];
}

-(void) request:(FBRequest *)request1 didLoad:(id)result
{
    request1.delegate = nil;
//    [appDelegate.progressHud removeFromSuperview];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Coupon shared on your wall." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    
    isFacebook = NO;
    lblFBStatus.hidden = NO;
    lblFBStatus.textColor = [UIColor blackColor];
    lblFBStatus.text = @"Posted on your wall.";
    [self callCountBack];
}

@end
