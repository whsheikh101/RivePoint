//
//  RegisterViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/28/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "RegisterViewController.h"
#import "GeneralUtil.h"
#import "RivepointConstants.h"
#import "RivePointSetting.h"
#import "Base64.h"

@implementation RegisterViewController
@synthesize isUserUpdate;
@synthesize userImage;
@synthesize calledType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) showErrorWithheading:(NSString *) head andDescription:(NSString *) desc
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:head message:desc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Register View Controller - Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void) viewWillDisappear:(BOOL)animated
{
    if (isCameraOpen == NO) {
        scrollView.delegate = nil;
        tfAddress.delegate = nil;
        tfEmail.delegate = nil;
        tfInterest.delegate = nil;
        tfName.delegate = nil;
        tfOcupation.delegate = nil;
        tfPaswrd.delegate = nil;
    }
    else
        isCameraOpen = NO;
    
    [super viewWillDisappear:YES];
}

-(void) dealloc
{
    [lblTitle release];
    [tfAddress release];
    [tfEmail release];
    [tfInterest release];
    [tfName release];
    [tfOcupation release];
    [tfPaswrd release];
    [IVProfile release];
    [scrollView release];
    [btnFMale release];
    [btnMale release];
    [btnMarried release];
    [btnSingle release];
    [btnUserImage release];
    [selectedProfileImage release];
    [userImage release];
    
    lblTitle = nil;
    tfAddress = nil;
    tfEmail = nil;
    tfInterest = nil;
    tfName = nil;
    tfOcupation = nil;
    tfPaswrd = nil;
    IVProfile = nil;
    scrollView = nil;
    btnFMale = nil;
    btnMale = nil;
    btnMarried = nil;
    btnSingle = nil;
    btnUserImage = nil;
    selectedProfileImage = nil;
    userImage = nil;
    [super dealloc];
    NSLog(@"RegisterViewController dealloc Called");
}

-(void) hideKeyBoard
{
    scrollView.contentSize = CGSizeMake(320, 700);
    [tfEmail resignFirstResponder];
    [tfPaswrd resignFirstResponder];
    [tfName resignFirstResponder];
    [tfAddress resignFirstResponder];
    [tfOcupation resignFirstResponder];
    [tfInterest resignFirstResponder];
}

-(void) setUserInfoFromUserDefaults
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if (self.userImage) {
        IVProfile.image = self.userImage;
    }
    NSString * _name = [userDefault valueForKey:k_User_Name];
    tfName.text = _name;
    NSString * _email = [userDefault valueForKey:k_User_Email];
    tfEmail.text = _email;
    NSString * _status = [userDefault valueForKey:k_User_Status];
    if ([_status isEqualToString:@"Single"]) {
        isSingle = YES;
        isMerrid = NO;
        [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
        [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
    else
        if ([_status isEqualToString:@"Married"]) {
            isSingle = NO;
            isMerrid = YES;
            [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
            [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        }
    else
        {
            isSingle = NO;
            isMerrid = NO;
            [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
            [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        }
        
    NSString * _gender = [userDefault valueForKey:k_User_Gender];
    if ([_gender isEqualToString:@"M"]) {
        isMale = YES;
        [btnMale setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
        [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
    else
        if ([_gender isEqualToString:@"F"]) {
            isMale = NO;
            isFemale = YES;
            [btnMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
            [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
        }
    else
    {
        isMale = NO;
        isFemale = NO;
        [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        [btnMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
        
    NSString * _psd = [userDefault valueForKey:k_User_Password];
    tfPaswrd.text = _psd;
    NSString * _address = [userDefault valueForKey:k_User_Address];
    tfAddress.text = _address;
    NSString * _ocupation = [userDefault valueForKey:k_User_Prof];
    tfOcupation.text = _ocupation;
    NSString * _interset = [userDefault valueForKey:k_User_Interst];
    tfInterest.text = _interset;
}

-(void) updateUserProfileInfo
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * _namet = tfName.text;
    NSString * _emailT = tfEmail.text;
    NSString * _statusT = @"";
    if (isSingle== YES) {
        _statusT = @"Single";
    }
    if (isMerrid == YES) {
        _statusT = @"Married";
    }
//    else
//        _statusT = @"Married";
    NSString * _genderT = @"";
    if (isMale == YES) {
        _genderT = @"M";
    }
    
    if (isFemale == YES) {
        _genderT = @"F";
    }
    
//    else
//        _genderT = @"F";
    NSString * _addressT = tfAddress.text;
    NSString * _ocupationT = tfOcupation.text;
    NSString * _interstT = tfInterest.text;
    [userDefault setValue:_namet forKey:k_User_Name];
    [userDefault setValue:_emailT forKey:k_User_Email];
    [userDefault setValue:_statusT forKey:k_User_Status];
    [userDefault setValue:_genderT forKey:k_User_Gender];
    [userDefault setValue:_addressT forKey:k_User_Address];
    [userDefault setValue:_ocupationT forKey:k_User_Prof];
    [userDefault setValue:_interstT forKey:k_User_Interst];
    
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [GeneralUtil setRivepointLogo:self.navigationItem];
    scrollView.contentSize = CGSizeMake(320, 700);
    isMale = NO;
    isSingle = NO;
    isFemale = NO;
    isMerrid = NO;
    isRegistered = NO;
    isCameraOpen = NO;
    if (self.isUserUpdate == YES)
    {
        lblTitle.text = @"UPDATE PROFILE";
        [self setUserInfoFromUserDefaults];
        tfEmail.enabled = NO;
    }
    else
        lblTitle.text = @"REGISTER";
}

- (void)viewDidUnload
{
    NSLog(@"Register View Controller - View is going to unload");
    
    lblTitle = nil;
    tfAddress = nil;
    tfEmail = nil;
    tfInterest = nil;
    tfName = nil;
    tfOcupation = nil;
    tfPaswrd = nil;
    IVProfile = nil;
    scrollView = nil;
    btnFMale = nil;
    btnMale = nil;
    btnMarried = nil;
    btnSingle = nil;
    btnUserImage = nil;
    selectedProfileImage = nil;
    userImage = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) onMaleBtn
{
    isMale = YES;
    isFemale = NO;
    [self hideKeyBoard];
    [btnMale setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
}

-(IBAction) onFMaleBtn
{
    isMale = NO;
    isFemale = YES;
    [self hideKeyBoard];
    [btnMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
}

-(IBAction) onSingleBtn
{
    isSingle = YES;
    isMerrid = NO;
    [self hideKeyBoard];
    [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
    [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
}

-(IBAction) onMarriedBtn
{
    isSingle = NO;
    isMerrid = YES;
    [self hideKeyBoard];
    [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-on.png"] forState:UIControlStateNormal];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) requestFailWithError:(NSString *)errorMsg
{
//    [self showErrorWithheading:@"Rive Point" andDescription:errorMsg];
    NSLog(@"RigisterViewController %@",errorMsg);
}

-(void) userRegisterWithResponseStatus:(NSString *)_status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([_status isEqualToString:@"-1"]) {
        [self showErrorWithheading:@"Info" andDescription:@"Registration fail. Please try again!"];
    }
    else
        if ([_status isEqualToString:@"-2"]) {
            [self showErrorWithheading:@"Info" andDescription:@"Email Address already exists!"];
        }
    else
    {
        isRegistered = YES;
        [[NSUserDefaults standardUserDefaults] setValue:_status forKey:k_LoggedIn_User_Id];
        [appDelegate fetchUserLogedInId];
        [self updateUserProfileInfo];
        [self showErrorWithheading:@"Congrats!" andDescription:@"Successfully Registered!"];
    }
    request.delegate = nil;
    [request release];
    request = nil;
    
}


UIImage* rotateUIImage(const UIImage* src, float angleDegrees)  {   
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(IBAction) onSubmitBtn
{
    [self hideKeyBoard];
    
    NSString * _email = tfEmail.text;
    if (_email || _email.length > 0) 
    {
        if ([self NSStringIsValidEmail:_email] == NO)
        {
            [self showErrorWithheading:@"Error" andDescription:@"Please enter a valid email!"];
            return; 
        }
    }
    else
    {
        [self showErrorWithheading:@"Info" andDescription:@"Please enter email!"];
        return; 
    }
    
    NSString * _pswd = tfPaswrd.text;
    if (!_pswd || _pswd.length <= 0) 
    {
        [self showErrorWithheading:@"Info" andDescription:@"Please enter password!"];
        return; 
    }
    else
        if (_pswd.length < 6) {
            [self showErrorWithheading:@"Info" andDescription:@"Password must contain atleast 6 characters!"];
            return; 
        }
    
    NSString * _name = tfName.text;
    if (!_name || _name.length <= 0) 
    {
        [self showErrorWithheading:@"Info" andDescription:@"Please enter name!"];
        return;
    }
    
    NSString * _gender = @"";
    NSString * _status = @"";
    if (isMale == YES) {
        _gender = @"M";
    }
    else
        if (isFemale == YES) {
            _gender = @"F";
        }
        
    if (isSingle == YES) {
        _status = @"Single";
    }
    else
        if (isMerrid == YES) {
            _status = @"Married";
        }
    NSString * _address = tfAddress.text;
    if (!_address || _address.length <= 0) {
        _address = @"";
    }
    
    NSString * _ocupation = tfOcupation.text;
    if (!_ocupation || _ocupation.length <= 0) {
        _ocupation = @"";
    }
    
    NSString * _interst = tfInterest.text;
    if (!_ocupation || _interst.length <= 0) {
        _interst = @"";
    }
    [[NSUserDefaults standardUserDefaults] setValue:_pswd forKey:k_User_Password];
    NSString * param1 = [XMLUtil getParamXMLWithName:@"email" andValue:_email];
    NSString * param2 = [XMLUtil getParamXMLWithName:@"userName" andValue:_name];
    NSString * param3 = [XMLUtil getParamXMLWithName:@"pwd" andValue:_pswd];
    NSString * param4 = [XMLUtil getParamXMLWithName:@"gender" andValue:_gender];
    NSString * param5 = [XMLUtil getParamXMLWithName:@"maritalStatus" andValue:_status];
    NSString * param6 = [XMLUtil getParamXMLWithName:@"address" andValue:_address];
    NSString * param7 = [XMLUtil getParamXMLWithName:@"occupation" andValue:_ocupation];
    NSString * param8 = [XMLUtil getParamXMLWithName:@"interest" andValue:_interst];
    NSString * param9 = @"";
    if (selectedProfileImage) {
        
//        UIImage * _rotImage = rotateUIImage(selectedProfileImage, 90.0);
//        NSData *imageData = UIImageJPEGRepresentation(_rotImage, K_Image_Compress_Quality);
        NSData *imageData = UIImageJPEGRepresentation(selectedProfileImage, K_Image_Compress_Quality);
        NSString * imageSTR = [imageData base64Encoding];
        param9 = [XMLUtil getParamXMLWithName:@"imageBytes" andValue:imageSTR];
    }
    if (self.isUserUpdate == NO) {
        [appDelegate progressHudView:self.view andText:@"Loading..."];
        NSString * param10 = [XMLUtil getParamXMLWithName:@"sid" andValue:appDelegate.setting.subsId];
        NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",param1,param2,param3,param4,param5,param6,param7,param8,param9,param10];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_User_Register andParams:params];
        request = [[XMLPostRequest alloc]init];
        request.delegate = (id) self;
        [request sendPostRequestWithRequestName:k_User_Register andRequestXML:reviewReqXML];
//        [request release];
    }
    else
    {
        [appDelegate progressHudView:self.view andText:@"Loading..."];
        NSString * _userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
        NSString * param10 = [XMLUtil getParamXMLWithName:@"uid" andValue:_userID];
        NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",param1,param2,param3,param4,param5,param6,param7,param8,param9,param10];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_User_Update andParams:params];
        request = [[XMLPostRequest alloc]init];
        request.delegate = (id) self;
        [request sendPostRequestWithRequestName:k_User_Update andRequestXML:reviewReqXML];
//        [request release];
    }
}


-(void) userProfileUpdatedWithStatus:(NSString *)status
{
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
    if ([status isEqualToString:@"1"])
    {
        isRegistered = YES;
        [self updateUserProfileInfo];
        [self showErrorWithheading:@"Congrats!" andDescription:@"Profile updated successfully!"];
    }
    request.delegate = nil;
    [request release];
    request = nil;
}

-(IBAction) onCancelBtn
{
    if (self.isUserUpdate == YES)
    {
        [self hideKeyBoard];
        [self setUserInfoFromUserDefaults];
    }
    else
    {
        [self hideKeyBoard];
        IVProfile.image = [UIImage imageNamed:@"default_avatar_large.jpg"];
        tfName.text = @"";
        tfEmail.text = @"";
        tfAddress.text = @"";
        tfInterest.text = @"";
        tfOcupation.text = @"";
        tfPaswrd.text = @"";
        [btnSingle setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        [btnMarried setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        [btnMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
        [btnFMale setImage:[UIImage imageNamed:@"radio-Btn-off.png"] forState:UIControlStateNormal];
    }
}

-(IBAction) onProfileImageBtn
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"Upload Profile Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Select from gallery", nil];
    [sheet showInView:self.view];
    [sheet release];
}





#pragma mark UIActionSheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        isCameraOpen = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            //You can use isSourceTypeAvailable to check
            imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickController.delegate=(id) self;
            imagePickController.allowsEditing=NO;
            imagePickController.showsCameraControls=YES;
            //This method inherit from UIView,show imagePicker with animation
            [self presentModalViewController:imagePickController animated:YES];
            [imagePickController release]; 
        }
        else
            [self showErrorWithheading:@"Info" andDescription:@"Camera not available!"];
    }
    else
        if (buttonIndex == 1)
        {
            isCameraOpen = YES;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
                //You can use isSourceTypeAvailable to check
                imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickController.delegate=(id) self;
                imagePickController.allowsEditing=NO;
                //This method inherit from UIView,show imagePicker with animation
                [self presentModalViewController:imagePickController animated:YES];
                [imagePickController release]; 
            } 
            else
                [self showErrorWithheading:@"Info" andDescription:@"PhotoLibrary not available!"];
        }
    actionSheet.delegate = nil;
}

-(UIImage *)imageWithImage:(UIImage *)_image1 {
    //UIGraphicsBeginImageContext(newSize);
    CGSize newSize = CGSizeMake(640, 480);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    NSLog(@"\n\n\n\n%@\n\n\n\n",info);
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    if (selectedProfileImage) {
        [selectedProfileImage release];
        selectedProfileImage= nil;
    }
    NSLog(@"Image Size : %@", NSStringFromCGSize(originalImage.size));
    if (originalImage.size.width > 640 && originalImage.size.height > 480) {
        UIImage * _newImage = [self imageWithImage:originalImage];
        selectedProfileImage = [_newImage retain];
        IVProfile.image =_newImage;
    }
    else
    {
        selectedProfileImage = [originalImage retain];
        IVProfile.image =originalImage;
    }
        
    //    imageView.image=[self imageWithImage:originalImage];
    picker.delegate = nil;
    [self dismissModalViewControllerAnimated:YES];
    
//    NSData *imageData = UIImageJPEGRepresentation(originalImage, K_Image_Compress_Quality);
//    NSString * imageSTR = [imageData base64Encoding];
//    NSString * param3 = [XMLUtil getParamXMLWithName:@"uid" andValue:@"21548"];
//   NSString * param2 = [XMLUtil getParamXMLWithName:@"imageBytes" andValue:imageSTR];
//    NSString * params = [NSString stringWithFormat:@"%@%@",param3,param2];
//    int rand = arc4random() % 1000;
//    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
//    NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"addUpdateUserAvatar" andParams:params];
//    XMLPostRequest * request = [[XMLPostRequest alloc]init];
//    request.delegate = (id) self;
//    [request sendPostRequestWithRequestName:k_AddUpdate_User_Photo andRequestXML:reviewReqXML];
//    [request release];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate = nil;
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegates
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    scrollView.contentSize = CGSizeMake(320, 900);
    if (textField == tfEmail) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 150) animated:YES];
    }
    if (textField == tfPaswrd) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 200) animated:YES];
    }
    if (textField == tfName) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 250) animated:YES];
    }
    if (textField == tfAddress) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 450) animated:YES];
    }
    if (textField == tfOcupation) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 500) animated:YES];
    }
    if (textField == tfInterest) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 550) animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfEmail) {
        [tfPaswrd becomeFirstResponder];
    }
    if (textField == tfPaswrd) {
        [tfName becomeFirstResponder];   
    }
    if (textField == tfName) {
        [tfName resignFirstResponder];
    }
    if (textField == tfAddress) {
        [tfOcupation becomeFirstResponder];
    }
    if (textField == tfOcupation) {
        [tfInterest becomeFirstResponder];
    }
    if (textField == tfInterest) {
        [tfInterest resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger textLength = 0;
    textLength = [textField.text length] + [string length] - range.length;
    
    if (tfEmail == textField) {
        if (textLength > 100) {
            return NO;
        }
    }
    if (tfPaswrd == textField) {
        if (textLength > 20) {
            return NO;
        }
    }
    if (tfName == textField) {
        if (textLength > 50) {
            return NO;
        }
    }
    if (tfAddress == textField) {
        if (textLength > 100) {
            return NO;
        }
    }
    if (tfOcupation == textField) {
        if (textLength > 100) {
            return NO;
        }
    }
    if (tfInterest == textField) {
        if (textLength > 100) {
            return NO;
        }
    }
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isRegistered == YES) {
        isRegistered = NO;
        if (self.calledType == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [self.navigationController popToRootViewControllerAnimated:YES];
    }
    alertView.delegate  = nil;
}

@end
