//
//  AllPhotosViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 2/6/13.
//  Copyright (c) 2013 Netpace Systems. All rights reserved.
//

#import "AllPhotosViewController.h"
#define k_Cell_Btn_Tag_1 951
#define k_Cell_Btn_Tag_2 952
#define k_Cell_Btn_Tag_3 953

@implementation AllPhotosViewController
@synthesize  photoArrays = _photoArrays;

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

-(void) hideLoadingView
{
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


-(void) fetchSharedPhotosFromServer
{
    
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
}

-(void) fetchedUserSharedPhotosIdsArray:(NSArray *)array
{
    if (array.count > 0)
    {
        NSLog(@"Photo Total Count : %d",array.count);
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
        [tableView reloadData];
    }
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:_photoArrays.count];
    fetchRequest.delegate  = nil;
    [fetchRequest release];
    fetchRequest =nil;
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
    NSLog(@"Error : %@",errorMsg);
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    _photoArrays = [[NSMutableArray alloc]init];
    [appDelegate progressHudView:self.view andText:@"Loading..."];
    [self performSelector:@selector(fetchSharedPhotosFromServer) withObject:nil afterDelay:0.01];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tableView = nil;
    _photoArrays = nil;
    IVFullImage = nil;
    fullImageView= nil;
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_photoArrays removeAllObjects]; 
    appDelegate = nil;
    
}

-(void) dealloc
{
    [_photoArrays release];
    [tableView release];   
    [IVFullImage release];
    [fullImageView release];
    tableView = nil;
    _photoArrays = nil;
    IVFullImage = nil;
    fullImageView= nil;
    [super dealloc];
}

//-(void) imageDownLoadCompleteForIndex:(int)index withImage:(UIImage *)image
//{
//    
//}
//
//-(void) onImageClicked
//{
//    
//}

-(void) imageDownloadCompleteWithImageData:(UIImage *)image ofIndex:(int)index andSelf:(CellCustomButton *)selfObj
{
    NSLog(@"Image Downloaded....");
    UserPhotos * _photo = (UserPhotos *)[_photoArrays objectAtIndex:index];
    if (_photo) {
        _photo.shareImage = image;
    }
    selfObj.delegate = nil;
}

-(IBAction) onFullImageCloseClick
{
    [fullImageView removeFromSuperview];
}

#pragma mark - Table view data source

-(void) onCellBtn1: (id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3);
    NSLog(@"Image Clicked of Index : %d",objNum);
    UserPhotos * _cuPhoto = [_photoArrays objectAtIndex:objNum];
    [self.view addSubview:fullImageView];
    IVFullImage.image = _cuPhoto.shareImage;
    [self animateViewWithBeginValue:0.1 
                           EndValue:1.0 
                  AnimationDuration:0.25 
                      TransformView:fullImageView];
}

-(void) onCellBtn2: (id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3) +1;
    NSLog(@"Image Clicked of Index : %d",objNum);
    UserPhotos * _cuPhoto = [_photoArrays objectAtIndex:objNum];
    [self.view addSubview:fullImageView];
    IVFullImage.image = _cuPhoto.shareImage;
    [self animateViewWithBeginValue:0.1 
                           EndValue:1.0 
                  AnimationDuration:0.25 
                      TransformView:fullImageView];
}

-(void) onCellBtn3: (id) sender
{
    NSIndexPath *index = [tableView indexPathForCell:(UITableViewCell *) [[sender superview] superview]];
    int objNum = (index.row * 3) +2;
    NSLog(@"Image Clicked of Index : %d",objNum);
    UserPhotos * _cuPhoto = [_photoArrays objectAtIndex:objNum];
    [self.view addSubview:fullImageView];
    IVFullImage.image = _cuPhoto.shareImage;
    [self animateViewWithBeginValue:0.1 
                           EndValue:1.0 
                  AnimationDuration:0.25 
                      TransformView:fullImageView];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noOfCell = 0;
    int comp = (_photoArrays.count / 3);
    int mod = (_photoArrays.count % 3);
    if (mod > 0) {
        noOfCell = comp + 1;
    }
    else
        noOfCell = comp;
    return noOfCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
//        CellCustomButton * btn1 = [[CellCustomButton alloc]initWithFrame:CGRectMake(3, 3, 102, 102)];
//        [btn1 setTag:k_Cell_Btn_Tag_1];
//        [btn1 setContentMode:UIViewContentModeScaleAspectFill];
//        btn1.delegate = self;
//        [btn1 addTarget:self action:@selector(onCellBtn1:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn1];
//        [btn1 release];
//        
//        CellCustomButton * btn2 = [[CellCustomButton alloc]initWithFrame:CGRectMake(109, 3, 102, 102)];
//        [btn2 setTag:k_Cell_Btn_Tag_2];
//        [btn2 setContentMode:UIViewContentModeScaleAspectFill];
//        btn2.delegate = self;
//        [btn2 addTarget:self action:@selector(onCellBtn2:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn2];
//        [btn2 release];
//        
//        CellCustomButton * btn3 = [[CellCustomButton alloc]initWithFrame:CGRectMake(215, 3, 102, 102)];
//        [btn3 setTag:k_Cell_Btn_Tag_3];
//        [btn3 setContentMode:UIViewContentModeScaleAspectFill];
//        btn3.delegate = self;
//        [btn3 addTarget:self action:@selector(onCellBtn3:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn3];
//        [btn3 release];
        
    }
    int objNumber = (indexPath.row * 3);
//    if (objNumber < _photoArrays.count)
//    {
//        CellCustomButton * btn1 = (CellCustomButton *)[cell.contentView viewWithTag:k_Cell_Btn_Tag_1];
//        UserPhotos * _curPhoto1 = (UserPhotos *)[ _photoArrays objectAtIndex:objNumber];
//        if (_curPhoto1.shareImage) {
//            [btn1 setImage:_curPhoto1.shareImage forState:UIControlStateNormal];
//        }
//        else
//            if (_curPhoto1.isReqSent == NO) {
//                _curPhoto1.isReqSent = YES;
//                btn1.index = objNumber;
//                [btn1 startButtonImageDownloadWithUrl:_curPhoto1.imageUrl];
//            }        
//    }
//    
//    if (objNumber+1 < _photoArrays.count)
//    {
//        CellCustomButton * btn2 = (CellCustomButton *)[cell.contentView viewWithTag:k_Cell_Btn_Tag_2];
//        UserPhotos * _curPhoto2 = (UserPhotos *)[ _photoArrays objectAtIndex:objNumber+1];
//        if (_curPhoto2.shareImage) {
//            [btn2 setImage:_curPhoto2.shareImage forState:UIControlStateNormal];
//        }
//        else
//            if (_curPhoto2.isReqSent == NO) {
//                _curPhoto2.isReqSent = YES;
//                btn2.index = objNumber+1;
//                [btn2 startButtonImageDownloadWithUrl:_curPhoto2.imageUrl];
//            } 
//    }           
//    if (objNumber+2 < _photoArrays.count)
//    {
//        CellCustomButton * btn3 = (CellCustomButton *)[cell.contentView viewWithTag:k_Cell_Btn_Tag_3];
//        UserPhotos * _curPhoto3 = (UserPhotos *)[ _photoArrays objectAtIndex:objNumber+2];
//        if (_curPhoto3.shareImage) {
//            [btn3 setImage:_curPhoto3.shareImage forState:UIControlStateNormal];
//        }
//        else
//            if (_curPhoto3.isReqSent == NO) {
//                _curPhoto3.isReqSent = YES;
//                btn3.index = objNumber+2;
//                [btn3 startButtonImageDownloadWithUrl:_curPhoto3.imageUrl];
//            } 
//    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}



@end
