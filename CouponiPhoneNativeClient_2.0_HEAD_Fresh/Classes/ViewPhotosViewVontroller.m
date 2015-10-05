//
//  ViewPhotosViewVontroller.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/12/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#define k_IMAGE1 963
#define k_IMAGE2 852
#define k_IMAGE3 741
#define k_BTN1 789
#define k_BTN2 456
#define k_BTN3 123
#define K_IMAGE_ALERT 8938
#define k_Image_Btn_Tag 111
#define k_Image_View_Tag 222

#define k_IMAGE_URL @"http://sphotos-c.ak.fbcdn.net/hphotos-ak-ash4/217459_1891742088829_1216417_n.jpg"


#import "ViewPhotosViewVontroller.h"
#import "GeneralUtil.h"
#import "CustomImage.h"
#import "XMLUtil.h"
#import "RivePointSetting.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@implementation VenderPhoto
@synthesize imageUrl=_imageUrl,venderImage=_venderImage,isReqSent;    

-(void) dealloc
{
    [_imageUrl release];
    [_venderImage release];
    
    _imageUrl = nil;
    _venderImage =nil;
    
    [super dealloc];
}

@end

@implementation ViewPhotosViewVontroller
@synthesize coupon;
@synthesize venderImage;
@synthesize lblDistance,lblAddressOne,lblAddressTwo,lblVenderName,lblReviewCount;
@synthesize btnPhoneNo,btnUploadPhote;

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
    NSLog(@"View Photos View Controller - Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    NSLog(@"View Photos Dealloc In");
    [photoDataArray release];
    [scrollView release];
    [fullImageView release];
    [IVFullImage release];
    [venderImage release];
    [lblVenderName  release];
    [lblReviewCount release];
    [lblDistance  release];
    [lblAddressTwo  release];
    [lblAddressOne  release];
    [btnPhoneNo  release];
    [btnUploadPhote  release];
    [ratingImageView release];
    [imageGalleryBG release];
    
    photoDataArray = nil;
    scrollView  = nil;
    fullImageView = nil;
    IVFullImage = nil;
    [coupon release];
    venderImage = nil;
    lblVenderName= nil;
    lblReviewCount = nil;
    lblDistance = nil;
    lblAddressTwo = nil;
    lblAddressOne = nil;
    btnPhoneNo = nil;
    btnUploadPhote = nil;
    ratingImageView = nil;
    imageGalleryBG = nil;
    
    [super dealloc];
     NSLog(@"View Photos Dealloc Out");
}

-(void) hideLoadingIncon
{
    NSLog(@"Called");
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate.progressHud removeFromSuperview];
}

- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[GeneralUtil setBigLogo:self.venderImage poiId:poi.poiId];
	[pool release];
}

-(void) callRegisterToRP
{
    NSLog(@"callRegisterToRP");
    isDisappear = YES;
    RegisterViewController * rViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    rViewController.calledType = 1;
    [self.navigationController pushViewController:rViewController animated:YES];
    [rViewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
}

-(void) callLoginPageToRP
{
    NSLog(@"callLoginPageToRP");
    isDisappear = YES;
    LoginViewController * loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.CalledType = 1;
    [self presentModalViewController:loginViewController animated:YES];
    [loginViewController release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRegisterToRP) name:k_RP_Register_Call object:nil];
}


-(void) arrangeVenderDataOnScreen
{
    [NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
    self.lblVenderName.text = poi.name;
    NSArray *array = [poi.completeAddress componentsSeparatedByString:@","];
	int addressComponentCount = [array count];
	NSString *string;
	switch (addressComponentCount) {
            
		case 2:
			string = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
			break;
		case 3:
			string = [NSString stringWithFormat:@"%@,%@",[array objectAtIndex:1],
                      [array objectAtIndex:2]];
			break;
		case 6:
		case 5:
		case 4:
			string = [NSString stringWithFormat:@"%@,%@,%@",[array objectAtIndex:1],
					  [array objectAtIndex:2],[array objectAtIndex:3]];
			break;
		default:
			string = [NSString stringWithFormat:@""];
			break;
	}
	
	if(addressComponentCount > 0)
		lblAddressOne.text = [array objectAtIndex:0];
    
	if(addressComponentCount > 1){
		lblAddressTwo.text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
    if(poi.phoneNumber && [poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		[btnPhoneNo setTitle:poi.phoneNumber forState:UIControlStateNormal];
	}
    if([poi.isSponsored isEqualToString:@"true"])
		lblDistance.text = @"";		
	else{
		lblDistance.text = [NSString stringWithFormat:@"%@ miles", (poi.distance = [GeneralUtil truncateDecimal:poi.distance])];
	}
    
    self.lblReviewCount.text = [NSString stringWithFormat:@"%d",poi.reviewCount];
    ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-stars-0%d.png",poi.feedbackCount]];
//    for (int i = 0;  i < 5; i++)
//    {
//        int _x = 91 + (14 * i);
//        UIImageView * star = [[UIImageView alloc]initWithFrame:CGRectMake(_x, 78, 10, 10)];
//        [self.view addSubview:star];
//        if (poi.feedbackCount > i)
//        {
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star_B.png"]];
//        }
//        else
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star.png"]];
//        [star release];
//    }
}

-(void)animateViewWithBeginValue:(float)begin EndValue:(float)end AnimationDuration:(float)duration TransformView:(UIView *)sender
{	
    
	NSValue *touchPointValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 240.0)];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:duration];
//	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformMakeScale(begin,begin);
	sender.transform = transform;
	transform = CGAffineTransformMakeScale(end, end);
	sender.transform = transform;
	[UIView commitAnimations];
}


-(void) downloadImageFromURL:(NSURL *)_curURL
{
   IVFullImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_curURL]]; 
   [activityWheel stopAnimating];
   activityWheel.hidden = YES;
}

-(void) sharedPhotoClicked:(id)sender
{
    UIButton * _btn = (UIButton *)sender;
    int _tag = _btn.tag;
    int _index = _tag - k_Image_Btn_Tag;
//    CustomImage * _curCImage = (CustomImage *)[scrollView viewWithTag:k_Image_View_Tag +_index];
//    if (_curCImage) {
//        if (_curCImage.image) {
//             [self.view addSubview:fullImageView];
//            IVFullImage.image = _curCImage.image;
//        }
//    }
//    
    
    VenderPhoto * _curUserPhoto = [photoDataArray objectAtIndex:_index];
    NSString * urlString = [_curUserPhoto.imageUrl stringByReplacingOccurrencesOfString:@"?type=8" withString:@"?type=6"];
    NSURL * _curURL = [NSURL URLWithString:[NSString stringWithFormat:urlString]];
    [self.view addSubview:fullImageView];
    activityWheel.hidden = NO;
    [activityWheel startAnimating];
    IVFullImage.image = nil;
    [self animateViewWithBeginValue:0.1 
                           EndValue:1.0 
                  AnimationDuration:0.15 
                      TransformView:fullImageView];
    [self performSelector:@selector(downloadImageFromURL:) withObject:_curURL afterDelay:0.01];
    
//    VenderPhoto * _photo = [photoDataArray objectAtIndex:_index];
//    if (IVFullImage) {
//        if (_photo.venderImage) {
//            IVFullImage.image = _photo.venderImage;
//        }
//        else
//            [IVFullImage startDownloadWithUrl:_photo.imageUrl];
//    }
   
}

-(IBAction) onImageFullViewCloseClicked
{
    if (fullImageView) {
        [fullImageView removeFromSuperview];
    }
}

-(void) showPOIPhotosOnScreen
{
    float _x = 0.0;
    float _y = 0.0;
    
    int objCount = photoDataArray.count;
    int noOfRows = objCount / 3;
    int remainder = objCount % 3;
    if (remainder > 0) {
        noOfRows+=1;
    }
    
    for (int i = 0; i < noOfRows; i++) {
        int _rCount = 3 * i;
        _y = 6 + (100 * i);
        if (photoDataArray.count > _rCount) {
            for (int j = 0;  j < 3; j++) {
                int _cCount = _rCount + j;
                _x = 6 + (100 * j);
                if (photoDataArray.count > _cCount) {
                    UIButton * _btn = [[UIButton alloc]initWithFrame:CGRectMake(_x+2, _y+2, 86, 86)];
                    int _tag = (i * 3)+j;
                    _btn.tag = k_Image_Btn_Tag + _tag;
                    [_btn addTarget:self action:@selector(sharedPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:_btn];
                    [_btn release];
                    
                    CustomImage * imageView = [[CustomImage alloc]initWithFrame:CGRectMake(_x, _y, 90, 90)];
                    imageView.delegate = (id) self;
                    imageView.tag = k_Image_View_Tag + _tag;
                    imageView.index = k_Image_View_Tag + _tag;
                    VenderPhoto * _photo = [photoDataArray objectAtIndex:_tag];
                    if (_photo.venderImage) {
                        imageView.image = _photo.venderImage;
                    }
                    else
                        [imageView startDownloadWithUrl:_photo.imageUrl];
                    _photo.isReqSent = YES;
                    [scrollView addSubview:imageView];
                    [imageView release];
                }
            } 
        }
        _y += 100;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, _y);
    }

}


-(void) fetchPoiImageFromServer
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate progressHudView:self.view andText:@"Loading..."];
    NSString * param1=[XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
//    NSString * param1=[XMLUtil getParamXMLWithName:@"poiId" andValue:@"525803"];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"50"];
    NSString * params = [NSString stringWithFormat:@"%@%@",param1,param2];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_POI_Shared_Photo andParams:params];
    postReq = [[XMLPostRequest alloc]init];
    postReq.delegate = (id)self;
    [postReq sendPostRequestWithRequestName:k_Get_POI_Shared_Photo andRequestXML:reqXML];
    //[postReq release];
}

-(void) fetchedPOISharedPhotosIdsArray:(NSArray *)array
{
    if (array.count > 0)
    {
        NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *urlFileName = @"url";
        NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
        NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
        int _count = 0;
        for (NSString * _id in array) {
            VenderPhoto * _photo = [[VenderPhoto alloc]init];
            NSString * _url = [NSString stringWithFormat:@"%@%@%@",prefixURL,k_POI_Image_Url,_id];
            _photo.imageUrl = _url;
            _photo.isReqSent = NO;
            [photoDataArray addObject:_photo];
            [_photo release];
            if (++_count >= 9)
                break;
        }
        [self showPOIPhotosOnScreen];
        [self performSelector:@selector(hideLoadingIncon) withObject:nil afterDelay:4.0];
    }
    else
        [self hideLoadingIncon];
    postReq.delegate = nil;
    [postReq release];
    postReq = nil;
    
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
//    [appDelegate showAlertWithHeading:@"RivePoint" andDesc:errorMsg];
}


-(void) viewWillDisappear:(BOOL)animated
{
    if (isDisappear == NO) {
        
//        for (int i = 0; i < photoDataArray.count; i++) {
//            int curCIVTag = i+k_Image_View_Tag;
//            CustomImage * _cIView = (CustomImage * )[scrollView viewWithTag:curCIVTag];
//            if (_cIView && [_cIView isKindOfClass:[CustomImage class]]) {
//                [_cIView stopLoadingImage];
//            }
//        }
        NSArray * _cSubViewArray = [scrollView subviews];
        for (UIView * curentSubView in _cSubViewArray) {
                [curentSubView removeFromSuperview];
        }
        [photoDataArray removeAllObjects];
        scrollView.delegate = nil;
        appDelegate = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
    }
    
    [super viewWillDisappear:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isDisappear = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    isDisappear = NO;
    self.navigationController.navigationItem.leftBarButtonItem.title = @"Back";
    [GeneralUtil setRivepointLogo:self.navigationItem];
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    poi = [GeneralUtil getPoi];
    [self arrangeVenderDataOnScreen];
    photoDataArray = [[NSMutableArray alloc]init];
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
    [self performSelector:@selector(fetchPoiImageFromServer) withObject:nil afterDelay:0.01];
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        imageGalleryBG.frame = CGRectMake(imageGalleryBG.frame.origin.x, imageGalleryBG.frame.origin.y, imageGalleryBG.frame.size.width, 336);
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 279);
    }
}

- (void)viewDidUnload
{
    NSLog(@"View Photos View Controller - View is going to unload");
    
    coupon = nil;
    venderImage = nil;
    lblVenderName= nil;
    lblReviewCount = nil;
    lblDistance = nil;
    lblAddressTwo = nil;
    lblAddressOne = nil;
    btnPhoneNo = nil;
    btnUploadPhote = nil;
    scrollView  = nil;
    fullImageView = nil;
    IVFullImage = nil;
    ratingImageView = nil;
    imageGalleryBG = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -------   IBACTIONS ------------------

-(IBAction) onPhoneNoClicked
{
    NSLog(@"onPhoneNoClicked");
}

-(IBAction) onUploadPhotoBtnClicked
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Take image from " message:@"" delegate:self cancelButtonTitle:@"Gallery" otherButtonTitles:@"Camera", nil];
        [alert setTag:K_IMAGE_ALERT];
        [alert show];
        [alert release];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
    
    
}

-(void) showErrorMessageWithText:(NSString *) str
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == K_IMAGE_ALERT)
    {
        isDisappear = YES;
            if (buttonIndex == 0)
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
                    imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePickController.delegate= (id) self;
                    imagePickController.allowsEditing=NO;
                    [self presentModalViewController:imagePickController animated:YES];
                    [imagePickController release];
                }
                else
                {
                    [self showErrorMessageWithText:@"Image library not exist!"];
                }
            }
            else
            {
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
                    imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imagePickController.delegate=(id) self;
                    imagePickController.allowsEditing=NO;
                    imagePickController.showsCameraControls=YES;
                    [self presentModalViewController:imagePickController animated:YES];
                    [imagePickController release];
                }
                else
                {
                    [self showErrorMessageWithText:@"Camera not available!"];
                }
            }
    }
    
    alertView.delegate = nil;
}

-(void) removeAllImagesFromScreen
{
    int count = photoDataArray.count;
    for (int i = 0; i < count; i++)
    {
        int cbTag = k_Image_Btn_Tag + i;
        int cvTag = k_Image_View_Tag+i;
        UIView * curBView = [scrollView viewWithTag:cbTag];
        [curBView removeFromSuperview];
        
        UIView * curIView = [scrollView viewWithTag:cvTag];
        [curIView removeFromSuperview];
    }
}

#pragma mark ------- UIIMAGEPICKER Delegates ----------------

-(void) photoUploadedWithPhotoId:(NSString *)photoID
{
    [self removeAllImagesFromScreen];
    isDisappear = NO;
    NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *urlFileName = @"url";
    NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
    NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
    VenderPhoto * _photo = [[VenderPhoto alloc]init];
    NSString * _url = [NSString stringWithFormat:@"%@%@%@",prefixURL,k_POI_Image_Url,photoID];
    _photo.imageUrl = _url;
    _photo.isReqSent = NO;
//    
    if (photoDataArray.count < 9) {
      [photoDataArray addObject:_photo];  
    }
    else
        [photoDataArray replaceObjectAtIndex:0 withObject:_photo];
    [_photo release];
    [self showPOIPhotosOnScreen];
    viewController.delegate = nil;
}

//UIImage* rotateUIImage(const UIImage* src, float angleDegrees)  {   
//    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
//    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
//    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
//    rotatedViewBox.transform = t;
//    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
//    
//    UIGraphicsBeginImageContext(rotatedSize);
//    CGContextRef bitmap = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
//    CGContextRotateCTM(bitmap, angleRadians);
//    
//    CGContextScaleCTM(bitmap, 1.0, -1.0);
//    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

-(UIImage *)imageWithImage:(UIImage *)_image1 {
    //UIGraphicsBeginImageContext(newSize);
    CGSize newSize = CGSizeMake(640, 480);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [_image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
   
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

//    Orientation UIImagePickerControllerMediaMetadata
    [self dismissModalViewControllerAnimated:YES];
    isDisappear = YES;
    viewController = [[PhotoUploadViewController alloc]initWithNibName:@"PhotoUploadViewController" bundle:nil];
    viewController.curPOI = poi;
    viewController.delegate = (id) self;
//    viewController.imageData = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    if (originalImage.size.width > 640 && originalImage.size.height > 480)
    {
        NSLog(@"Orinal Image Size : %@",NSStringFromCGSize(originalImage.size));
        originalImage = [self imageWithImage:originalImage];
        NSLog(@"New Image Size : %@",NSStringFromCGSize(originalImage.size));
    }
    viewController.imageData = UIImageJPEGRepresentation(originalImage, K_Image_Compress_Quality);
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    picker.delegate = nil;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate = nil;
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -----   ImageDownloadDelegates ------------

-(void) imageDownLoadCompleteForIndex:(int)index withImage:(UIImage *)image
{
    CustomImage * _cCImage =(CustomImage *)[scrollView viewWithTag:index];
    if (_cCImage) {
        _cCImage.delegate = nil;
    }
}

-(void) onImageClicked
{
    NSLog(@"Image Touched");
}

@end
