//
//  ReviewRatingViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/11/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#define COUPON_ARRAY @"couponArray"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define K_RATE_ALERT 3333
#define K_IMAGE_ALERT 4444
#define k_Review_Lbl 54621

#import "ReviewRatingViewController.h"
#import "GeneralUtil.h"
#import "PoiUtil.h"
#import "FileUtil.h"
#import "CommandUtil.h"
#import "PoiFinderNew.h"
#import "ReviewComment.h"
#import "FeedbackManager.h"
#import "HttpTransportAdaptor.h"
#import "CouponManager.h"
#import "PhotoUploadViewController.h"
#import "XMLUtil.h"
#import "RivePointSetting.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"


@implementation ReviewRatingViewController
@synthesize lblAddressOne,lblAddressTwo,lblVenderName;
@synthesize btnSave,btnPhoneNo,btnUploadPhote;
@synthesize venderImage;
//@synthesize tableView;
@synthesize coupon;
@synthesize star1,star2,star3,star4,star5;
@synthesize commentField;
@synthesize scrollView;
@synthesize delegate;

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
    NSLog(@"Review Rating View Controller - Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.            
}


-(void) viewWillDisappear:(BOOL)animated
{
    if (isDisappear == NO) {
        NSArray * subViewArray = [self.scrollView subviews];
        for (UIView * _curView in subViewArray)
        {
            if (_curView.tag == k_Review_Lbl)
            {
                [_curView removeFromSuperview];
            }
        }
        scrollView.delegate = nil;
        commentField.delegate = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:k_RP_Register_Call object:nil];
        [super viewWillDisappear:YES];
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (isDisappear == YES) {
        isDisappear = NO;
    }
}

-(void) dealloc
{
        
    [commentArray release];
    [lblAddressOne release];
    [lblAddressTwo release];
    [lblVenderName release];
    [btnPhoneNo release];
    [btnSave  release];
    [btnUploadPhote release];
    [venderImage release];
    [star1 release];
    [star2 release];
    [star3 release];
    [star4 release];
    [star5  release];
    [commentField release];
    
    lblAddressOne = nil;
    lblAddressTwo = nil;
    lblVenderName = nil;
    btnPhoneNo = nil;
    btnSave = nil;
    btnUploadPhote = nil;
    venderImage = nil;
    [ratingImageView release];
    ratingImageView = nil;
    //    self.tableView = nil;
    star1 = nil;
    star2 = nil;
    star3 = nil;
    star4 = nil;
    star5 = nil;
    commentField = nil;
    commentArray = nil;

    [super dealloc];
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

-(void)setRightBarButton: (int)i{
	if(i==0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else{
        [GeneralUtil setActivityIndicatorView:self.navigationItem];
    }
}

-(void) setRatingStarts
{
    int _reviewCount = poi.feedbackCount;
 
    if (1 <= _reviewCount) {
        [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    }else
        [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    
    if (2 <= _reviewCount) {
        [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    }else
        [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    
    if (3 <= _reviewCount) {
        [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    }else
        [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    
    if (4 <= _reviewCount) {
        [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    }else
        [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    
    if (5 <= _reviewCount) {
        [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    }else
        [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
}


-(void) fetchPOIReviewfromSever
{
    NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
    NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"50"];
    NSString * params = [NSString stringWithFormat:@"%@%@",param1,param2];
    int rand = arc4random() % 1000;
    NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
    NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"getPoiReviews" andParams:params];
    request = [[XMLPostRequest alloc]init];
    request.delegate = (id) self;
    [request sendPostRequestWithRequestName:k_Get_POI_Reviews andRequestXML:reviewReqXML];
//    [request release];
}

-(void) addCommentsToScreen
{
    float _currY = 240;
    
    NSArray * subViewArray = [self.scrollView subviews];
    for (UIView * _curView in subViewArray)
    {
        if (_curView.tag == k_Review_Lbl)
        {
            [_curView removeFromSuperview];
        }
    }
    self.scrollView.contentSize = CGSizeMake(320, 480);
    for (ReviewComment * _currCom in commentArray)
    {
        UILabel * lblComment = [[UILabel alloc]init];
        [lblComment setMinimumFontSize:FONT_SIZE];
        [lblComment setNumberOfLines:0];
        [lblComment setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        lblComment.backgroundColor = [UIColor clearColor];
        lblComment.textColor = [UIColor grayColor];
        lblComment.tag = k_Review_Lbl;
        NSString *text = _currCom.comment;
        CGSize constraint = CGSizeMake(280, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        [lblComment setText:text];
        [lblComment setFrame:CGRectMake(20, _currY,280, MAX(size.height, 24.0f))];
        [self.scrollView addSubview:lblComment];
        _currY+=MAX(size.height-3, 24.0f-7);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.contentSize.height+MAX(size.height-3, 24.0f-7));
        [lblComment release];
        
        UILabel * lblName = [[UILabel alloc]init];
        [lblName setMinimumFontSize:FONT_SIZE];
        [lblName setNumberOfLines:0];
        [lblName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor = [UIColor blackColor];
        lblName.tag = k_Review_Lbl;
        NSString * _name = _currCom.commenter;
        size = [_name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        [lblName setText:_name];
        [lblName setFrame:CGRectMake(20, _currY,280, MAX(size.height, 24.0f))];
        [self.scrollView addSubview:lblName];
        _currY+=MAX(size.height-3, 24.0f);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.contentSize.height+MAX(size.height-3, 24.0f));
        [lblName release];
    }
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.contentSize.height+200);
    textViewBg.frame = CGRectMake(textViewBg.frame.origin.x, _currY+10, textViewBg.frame.size.width, textViewBg.frame.size.height);
    commentField.frame = CGRectMake(commentField.frame.origin.x, _currY+10, commentField.frame.size.width, commentField.frame.size.height);
    float _reviewBGy=(_currY-230)+112;
    reviewBG.frame = CGRectMake(reviewBG.frame.origin.x,reviewBG.frame.origin.y, reviewBG.frame.size.width, _reviewBGy);
    btnSave.frame = CGRectMake(btnSave.frame.origin.x, _currY+90, btnSave.frame.size.width, btnSave.frame.size.height);
    
    
}

-(void) fetchedPoiReviewArray:(NSMutableArray *)reviewArray
{
    [appDelegate removeLoadingViewFromSuperView];
//    [appDelegate.progressHud removeFromSuperview];
    for (ReviewComment * _coment in reviewArray)
    {
        [commentArray addObject:_coment];
    }
    if (commentArray.count > 0)
    {
        [self addCommentsToScreen];
    }
    
    request.delegate = nil;
    [request release];
    request = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.leftBarButtonItem.title = @"Back";
    [GeneralUtil setRivepointLogo:self.navigationItem];
    isWantComment = YES;
    shouldResign = YES;
    isDisappear = NO;
    yourRating = 0;
    isContentSizeChange = NO;
    self.scrollView.contentSize = CGSizeMake(320, 480);
    commentArray = [[NSMutableArray alloc]init];
//    self.commentField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commentTVBG.png"]];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (RivePointAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate progressHudView:self.view andText:@"Loading..."];
   
//    [appDelegate showActivityViewer];
    poi = [GeneralUtil getPoi];
    self.lblVenderName.text = poi.name;
    [NSThread detachNewThreadSelector:@selector(setVendorLogoImage) toTarget:self withObject:nil];
    [self performSelector:@selector(fetchPOIReviewfromSever) withObject:nil afterDelay:0.01];
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
		lblDistance.text = [NSString stringWithFormat:@"%@ MILES", (poi.distance = [GeneralUtil truncateDecimal:poi.distance])];
	}
    
    lblReviewCount.text = [NSString stringWithFormat:@"%d reviews",poi.reviewCount];
    ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating-stars-0%d.png",poi.feedbackCount]];
//    for (int i = 0;  i < 5; i++)
//    {
//        int _x = 101 + (12 * i);
//        UIImageView * star = [[UIImageView alloc]initWithFrame:CGRectMake(_x, 88, 10, 10)];
//        [scrollView addSubview:star];
//        if (poi.feedbackCount > i)
//        {
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star_B.png"]];
//        }
//        else
//            [star setImage:[UIImage imageNamed:@"cell_FB_Star.png"]];
//        [star release];
//    }
    
    [self setRatingStarts];
    NSLog(@"Vender Image Frame : %@",NSStringFromCGRect(venderImage.frame));
    
}

- (void)viewDidUnload
{
    NSLog(@"Review Rating View Controller - View is going to unload");
    self.lblAddressOne = nil;
    self.lblAddressTwo = nil;
    self.lblVenderName = nil;
    self.btnPhoneNo = nil;
    self.btnSave = nil;
    self.btnUploadPhote = nil;
    self.venderImage = nil;
    //    self.tableView = nil;
    self.star1 = nil;
    self.star2 = nil;
    self.star3 = nil;
    self.star4 = nil;
    self.star5 = nil;
    self.commentField = nil;
    ratingImageView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//#pragma mark -------   Table View Delegate and Data Source ----------------
//
//- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
//{
//    return [commentArray count];
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ReviewComment * comm = [commentArray objectAtIndex:indexPath.row];
//	NSString *text = comm.comment;
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat height = MAX(size.height, 24.0f);
//    return height +CELL_CONTENT_MARGIN+20;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    UILabel *label = nil;
//    UILabel *label1 = nil;
//    
//    cell = [tv dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
//        
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        [label setLineBreakMode:UILineBreakModeWordWrap];
//        [label setMinimumFontSize:FONT_SIZE];
//        [label setNumberOfLines:0];
//        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//        [label setTag:1];
//        [[cell contentView] addSubview:label];
//        
//        label1 = [[UILabel alloc]initWithFrame:CGRectZero];
//        [label1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]];
//        [label1 setTag:222];
//        [[cell contentView] addSubview:label1];
//        
//    }
//    
//    ReviewComment * comm = [commentArray objectAtIndex:indexPath.row];
//    NSString *text = comm.comment;
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    if (!label)
//        label = (UILabel*)[cell viewWithTag:1];
//    [label setText:text];
//    [label setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX(size.height, 24.0f))];
//    
//    if (!label1)
//        label1 = (UILabel*)[cell viewWithTag:222];
//    label1.text = comm.commenter;
//    float _y =label.frame.size.height;
//    [label1 setFrame:CGRectMake(0, _y, CELL_CONTENT_WIDTH, 20)];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//

#pragma mark -------   My Actions ----------------

- (void) setVendorLogoImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[GeneralUtil setBigLogo:self.venderImage poiId:poi.poiId];
	[pool release];
}

-(IBAction) onPhoneNoBtnClicked
{
    [PoiUtil dialPhoneNumber:poi];
}

-(IBAction) onPhotoUploadBtnClicked
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Take Image From " message:@"" delegate:self cancelButtonTitle:@"Gallery" otherButtonTitles:@"Camera", nil];
    [alert setTag:K_IMAGE_ALERT];
    [alert show];
    [alert release];
}

-(IBAction) onCommentSaveBtn
{
    [self.commentField resignFirstResponder];
    if (isContentSizeChange == YES) {
        isContentSizeChange = NO;
        self.scrollView.contentSize = CGSizeMake(320, self.scrollView.contentSize.height-180);
    }
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        //    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        self.scrollView.contentSize = CGSizeMake(320, self.scrollView.contentSize.height-180);
        NSString * textSpace = [self.commentField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        textSpace = [textSpace stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //    if (self.commentField.text && self.commentField.text.length > 0)
        //    {
        if (textSpace && textSpace.length > 0)
        {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
            NSString * param2 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            NSString * param3 = [XMLUtil getParamXMLWithName:@"review" andValue:self.commentField.text];
            NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
            NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"addPoiReview" andParams:params];
            request = [[XMLPostRequest alloc]init];
            request.delegate = (id) self;
            [request sendPostRequestWithRequestName:k_AddPoiReviewReq andRequestXML:reviewReqXML];
//            [request release];
            
        }
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];

}

-(void) addPoiReviewRequestCompletedWithSatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"])
    {
        poi.reviewCount+=1;
        [appDelegate showAlertWithHeading:@"Review posted!" andDesc:@""];
        [[self delegate] userAddedNewReview];
        lblReviewCount.text = [NSString stringWithFormat:@"%d reviews",poi.reviewCount];
        isWantComment = YES;
        ReviewComment * comm = [[ReviewComment alloc]init];
        comm.comment = self.commentField.text;
        NSString * _name = [[NSUserDefaults standardUserDefaults] valueForKey:k_User_Email];
        if (_name && _name.length > 0) {
            comm.commenter = _name;
        }
        else
            comm.commenter = @"You";
        [commentArray insertObject:comm atIndex:0];
        [comm release];
//        self.commentField.text = @"Write a review...";
        [self addCommentsToScreen];
        self.commentField.text = @"";

    }
    if ([status isEqualToString:@"0"]) {
        [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Service not found."];
    }
    
    request.delegate = nil;
    [request release];
    request = nil;
}

#pragma mark -------   Star Rating Functions ----------------

-(void) showAlertForRating
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Rate it with %d stars?",yourRating] message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert setTag:K_RATE_ALERT];
    [alert show];
    [alert release];
}

-(IBAction) onOneStar
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
        [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
        [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        yourRating = 1;
        [self showAlertForRating];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
   
}

-(IBAction) onTwoStar
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
    [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    yourRating = 2;
    [self showAlertForRating];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
}

-(IBAction) onThreeStar
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
    [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    yourRating = 3;
    [self showAlertForRating];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
}

-(IBAction) onFourStar
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
    [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    yourRating = 4;
    [self showAlertForRating];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
}

-(IBAction) onFiveStar
{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
    if (userID && userID.length > 0) {
    [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg.png"] forState:UIControlStateNormal];
    yourRating = 5;
    [self showAlertForRating];
    }
    else
    {
        [self callLoginPageToRP];
    }
//        [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
}


-(void) showErrorMessageWithText:(NSString *) str
{
//    [appDelegate hideActivityViewer];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == K_RATE_ALERT)
    {
        if (buttonIndex == 0)
        {
//            NSLog(@"buttonIndex == 0");
//            [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
//            [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
//            [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
//            [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
//            [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
            [self setRatingStarts];
        }
        else
        {
//            NSLog(@"buttonIndex == 1");
//            [appDelegate showActivityViewer];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            if (userID) {
                [appDelegate progressHudView:self.view andText:@"Processing..."];
                NSString * param1 = [XMLUtil getParamXMLWithName:@"poiId" andValue:poi.poiId];
                NSString * param2 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
                NSString * param3 = [XMLUtil getParamXMLWithName:@"rating" andValue:[NSString stringWithFormat:@"%d",yourRating]];
                NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
                int rand = arc4random() % 1000;
                NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
                NSString * rateReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"addPoiRating" andParams:params];
                
                request = [[XMLPostRequest alloc]init];
                request.delegate = (id) self;
                [request sendPostRequestWithRequestName:k_AddPoiRatingReq andRequestXML:rateReqXML];
                //[request release];
            }
            else
            {
                [self callLoginPageToRP];
            }
//                [appDelegate showAlertWithHeading:@"Info" andDesc:@"Please login first!"];
            
        }
    }
    else
        if (alertView.tag == K_IMAGE_ALERT)
        {
            {
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
                        [self showErrorMessageWithText:@"Image Library not Exist!"];
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
        }
    
    alertView.delegate = nil;
   
}

-(void) addPoiRatingRequestCompletedWithSatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"])
    {
        [appDelegate showAlertWithHeading:@"Rated successfully!" andDesc:@""];
    }
    if ([status isEqualToString:@"2"]) {
        [appDelegate showAlertWithHeading:@"Already marked favorite" andDesc:@""];
    }
    if ([status isEqualToString:@"0"]) {
        [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Service not found!"];
    }
    
    request.delegate = nil;
    [request release];
    request = nil;
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    [appDelegate.progressHud removeFromSuperview];
    if ([errorMsg isEqualToString:k_AddPoiRatingReq])
    {
        [self.star1 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star2 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star3 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star4 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
        [self.star5 setImage:[UIImage imageNamed:@"raingStar-bg-gray.png"] forState:UIControlStateNormal];
    }
}



#pragma mark ------- Delegates ----------------

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    if (isWantComment == YES)
    {
        isWantComment = NO;
        self.commentField.text = @"";
        shouldResign = NO;
    }
    isContentSizeChange = YES;
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.contentSize.height+180);
    float _OffSet = self.scrollView.contentSize.height - 480;
    NSLog(@"_OffSet : %.02f",_OffSet);
    [self.scrollView setContentOffset:CGPointMake(0, _OffSet) animated:YES];
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [self.commentField resignFirstResponder];
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"]) {
////        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [textView resignFirstResponder];
//        self.scrollView.contentSize = CGSizeMake(320, self.scrollView.contentSize.height-180);
//        return FALSE;
//    }
    NSInteger textLength = 0;
    textLength = [textView.text length] + [text length] - range.length;
    if (textLength > 500) {
        return NO;
    }
    return TRUE;
}

#pragma mark -------HTTP SUPPORT Delegates ----------------



-(void) processHttpResponse:(NSData *) response{
	[self setRightBarButton:0];
	XMLParser *parser = [[XMLParser alloc]init];
	[parser parseXMLFromData:response className:@"CommandParam" parseError:nil];
	NSArray *result =[parser getArray];
	CommandParam *param =[[result objectAtIndex:0] retain];
	[parser setArray];
	[parser release];
	[result release];
	[response release];	
	
	
	[appDelegate hideActivityViewer];
	if(param && [param.paramValue isEqualToString:@"1"])
    {
		
			coupon.rating = [NSString stringWithFormat:@"%d",yourRating];
		    self.coupon.poiId = poi.poiId;
			CouponManager *cm = [[CouponManager alloc] init];
			if([cm poiCouponExists:self.coupon])
				[cm update:self.coupon];
			[cm release];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_FEEDBACK_REGISTERED_SUCCESSFULLY,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		[alert show];	
		[alert release];
	}
	if(param)
		[param release];
	
}

-(void)communicationError:(NSString *)errorMsg{
	[self setRightBarButton:0];
	[appDelegate hideActivityViewer];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_SERVICE_NOT_AVAILABLE,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (shouldResign == YES)
//    {
//       [self.commentField resignFirstResponder]; 
//    }
//    else
//    {
//        shouldResign = YES;
//    }
//    
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (shouldResign == YES)
//    {
//        [self.commentField resignFirstResponder]; 
//    }
//    else
//    {
//        shouldResign = YES;
//    }
//}

-(void)photoUploadedWithPhotoId:(NSString *)photoID
{
    
}


#pragma mark ------- UIIMAGEPICKER Delegates ----------------

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"%@", editingInfo);
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    PhotoUploadViewController * viewController = [[PhotoUploadViewController alloc]initWithNibName:@"PhotoUploadViewController" bundle:nil];
    viewController.curPOI = poi;
    viewController.delegate = (id) self;
    viewController.imageData = UIImageJPEGRepresentation((UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"], K_Image_Compress_Quality);
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    picker.delegate = nil;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    picker.delegate = nil;
}

@end
