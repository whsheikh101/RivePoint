//
//  ViewAllPhotosViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 12/6/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//
#define k_Image_Btn_Tag 111
#define k_CustomView_Tag 81846
#import "ViewAllPhotosViewController.h"
#import "GeneralUtil.h"
#import "XMLUtil.h"
#import "RivepointConstants.h"

@implementation ViewAllPhotosViewController
@synthesize photoArrays= _photoArrays;

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
    NSLog(@"View All Photos View Controller - Receive Memory Warning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) hideLoadingView
{
    self.navigationItem.backBarButtonItem.enabled = YES;
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate.progressHud removeFromSuperview];
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
    
    UserPhotos * _curUserPhoto = [_photoArrays objectAtIndex:_index];
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
}


//-(void) sharedPhotoClicked:(id)sender
//{
//    UIButton * _btn = (UIButton *)sender;
//    int _tag = _btn.tag;
//    int _index = _tag - k_Image_Btn_Tag;
//    
//    UserPhotos * _curUserPhoto = [photoArrays objectAtIndex:_index];
//    NSString * urlString = [_curUserPhoto.imageUrl stringByReplacingOccurrencesOfString:@"?type=8" withString:@"?type=6"];
//    NSURL * _curURL = [NSURL URLWithString:[NSString stringWithFormat:urlString]];
////    NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
////    NSString *urlFileName = @"url";
////    NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
////    NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
////    NSURL * _curURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@servlet/ImageServlet?type=8&photoId=%@",prefixURL,_curUserPhoto.];];
//    IVFullImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_curURL]];
//    
////    CustomImage * cCImage =(CustomImage *)[scrollView viewWithTag:_index+k_CustomView_Tag];
////    if (cCImage != nil) {
////        [self.view addSubview:fullImageView];
////        if (IVFullImage) {
////            if (cCImage.image) {
////                IVFullImage.image = cCImage.image;
////            }
////        }
////    }
//    [self animateViewWithBeginValue:0.1 
//                           EndValue:1.0 
//                  AnimationDuration:0.25 
//                      TransformView:fullImageView];
////    
////    
////    UserPhotos * _photo = [self.photoArrays objectAtIndex:_index];
////    [self.view addSubview:fullImageView];
////    IVFullImage.image = nil;
////    if (IVFullImage) {
////        if (_photo.shareImage) {
////            IVFullImage.image = _photo.shareImage;
////        }
////        else
////            [IVFullImage startDownloadWithUrl:_photo.imageUrl];
////    }
////    [self animateViewWithBeginValue:0.1 
////                           EndValue:1.0 
////                  AnimationDuration:0.25 
////                      TransformView:fullImageView];
//}


-(void) addUserSharedPOIPhotosToScreen
{
    float _x = 0.0;
    float _y = 0.0;
    float _contentSize = 0.0;
    
    int _rowCount = _photoArrays.count/3;
    int _reminder = _photoArrays.count % 3;
    if (_reminder > 0) {
        _rowCount+=1;
    }
    for (int i = 0; i < _rowCount; i++) {
        int _rCount = 3 * i;
        _y = 3 + (100 * i);
        _contentSize += 100.0;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, _contentSize);
        if (_photoArrays.count > _rCount) {
            for (int j = 0;  j < 3; j++) 
            {
                int _cCount = _rCount + j;
                _x = 13 + (100 * j);
                if (_photoArrays.count > _cCount) {
                    UIButton * _btn = [[UIButton alloc]initWithFrame:CGRectMake(_x+2, _y+2, 86, 86)];
                    int _tag = (i * 3)+j;
                    _btn.tag = k_Image_Btn_Tag + _tag;
                    [_btn addTarget:self action:@selector(sharedPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:_btn];
                    [_btn release];
                    
                    CustomImage * imageView = [[CustomImage alloc]initWithFrame:CGRectMake(_x, _y, 90, 90)];
                    imageView.delegate = (id) self;
                    imageView.index = _tag;
                    imageView.tag = _tag+k_CustomView_Tag;
                    UserPhotos * _photo = [_photoArrays objectAtIndex:_tag];
                    if (_photo.shareImage) {
                        imageView.image = _photo.shareImage;
                    }
                    else
                        [imageView startDownloadWithUrl:_photo.imageUrl];
                    _photo.isReqSent = YES;
                    [scrollView addSubview:imageView];
                    [imageView release];
                }
            } 
        }
    }
}


-(void) fetchSharedPhotosFromServer
{
    [appDelegate progressHudView:self.view andText:@"Loading..."];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    NSString * param1=[XMLUtil getParamXMLWithName:@"uid" andValue:userID];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"50"];
    NSString * params = [NSString stringWithFormat:@"%@%@",param1,param2];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_user_Shared_Photo andParams:params];
    fetchRequest = [[XMLPostRequest alloc]init];
    fetchRequest.delegate = (id)self;
    [fetchRequest sendPostRequestWithRequestName:k_Get_user_Shared_Photo_More andRequestXML:reqXML];
//    [postReq release];
}

-(void) fetchedUserSharedPhotosIdsArray:(NSArray *)array
{
    if (array.count > 0)
    {
        NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *urlFileName = @"url";
        NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
        NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
        for (NSString * _id in array) {
            UserPhotos * _photo = [[UserPhotos alloc]init];
            NSString * _url = [NSString stringWithFormat:@"%@%@%@",prefixURL,k_POI_Image_Url,_id];
            _photo.imageUrl = _url;
            _photo.isReqSent = NO;
            [_photoArrays addObject:_photo];
            [_photo release];
        }
        [self addUserSharedPOIPhotosToScreen];
    }
    if (_photoArrays.count > 15) {
        [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:8.0];
    }
    else
        [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:5.0];
    fetchRequest.delegate = nil;
    [fetchRequest release];
    fetchRequest =nil;
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
    NSLog(@"Error : %@",errorMsg);
}


-(void)onCancelAction:(id)sender
{
    for (int i = 0; i < _photoArrays.count; i++) {
        int curCIVTag = i+k_CustomView_Tag;
        CustomImage * _cIView = (CustomImage * )[scrollView viewWithTag:curCIVTag];
        if (_cIView && [_cIView isKindOfClass:[CustomImage class]]) {
            [_cIView stopLoadingImage];
        }
    }
    //    [self.photoArrays removeAllObjects];
    NSArray * _cSubViewArray = [self.view subviews];
    for (UIView * curentSubView in _cSubViewArray) {
        if (curentSubView.tag != 9999) {
            [curentSubView removeFromSuperview];
        }
    }
    appDelegate = nil;
    fetchRequest.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelAction:)] autorelease];
    
    UIImage * buttonImage=[UIImage imageNamed:@"back-profile.png"];
    UIButton * bachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bachBtn.bounds = CGRectMake( 0, 0, buttonImage.size.width, buttonImage.size.height );    
    [bachBtn setImage:buttonImage forState:UIControlStateNormal];
    [bachBtn addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBackBtn = [[UIBarButtonItem alloc]initWithCustomView:bachBtn];
    [self.navigationItem setLeftBarButtonItem:barBackBtn];
    [barBackBtn release];
    
    
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
//    if (self.photoArrays && self.photoArrays.count > 0) {
//        [self addUserSharedPOIPhotosToScreen];
//    }
//    else
//    {
//        NSMutableArray * _tempArray = [[NSMutableArray alloc]init];
    _photoArrays = [[NSMutableArray alloc]init];
//    [_tempArray release];
        [self performSelector:@selector(fetchSharedPhotosFromServer) withObject:nil afterDelay:0.01];
//    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"View All Photos View Controller - View is going to unload");
    scrollView = nil;
    IVFullImage = nil;
    fullImageView= nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -----   ImageDownloadDelegates ------------

-(void) imageDownLoadCompleteForIndex:(int)index withImage:(UIImage *)image
{
    
//    int _tag = index + k_Image_Btn_Tag;
    CustomImage * cCImage =(CustomImage *)[scrollView viewWithTag:index+k_CustomView_Tag];
    if (cCImage) {
        cCImage.delegate = nil;
    }
    
//    UserPhotos * _vPhot0Object = [self.photoArrays objectAtIndex:index];
//    _vPhot0Object.shareImage = image;
}

-(void) onImageClicked
{
    NSLog(@"Image Touched");
}

-(IBAction) onFullImageCloseClick
{
    [fullImageView removeFromSuperview];
}

-(void) viewWillAppear:(BOOL)animated
{
//    self.navigationItem.backBarButtonItem.enabled = NO;
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
}


-(void) dealloc
{
    if (_photoArrays) {
        [_photoArrays release];
    }
    if (scrollView) {
        [scrollView release];
        scrollView = nil;
    }
    
    [IVFullImage release];
    [fullImageView release];
    
    _photoArrays = nil;
    IVFullImage = nil;
    fullImageView= nil;
    [super dealloc];
}

@end
