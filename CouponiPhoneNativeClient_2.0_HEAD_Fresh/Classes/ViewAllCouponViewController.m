//
//  ViewAllCouponViewController.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 12/6/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#define k_lblName 1010
#define k_lblExp 2020
#define k_lblDetail 3030

#define k_DA_Fav 1010
#define k_DA_Sav 2020
#define k_DA_She 3030

#import "ViewAllCouponViewController.h"
#import "Coupon.h"
#import "GeneralUtil.h"
#import "Poi.h"
#import "ListCouponsViewController.h"
#import "CouponDetailManager.h"
#import "CouponViewController.h"
#import "XMLUtil.h"

@implementation ViewAllCouponViewController
@synthesize couponArray,cVtitle;
@synthesize isSavedCoupon;
@synthesize curSelectedCoupon = _curSelectedCoupon;
@synthesize curIndexPath = _curIndexPath;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"View All";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"View All Coupon View Controller - Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) fetchDataFromServer
{
    
    if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) 
    {
        NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
        NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
        NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"100"];
        NSString * param3 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
        NSString * param4 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
        NSString * param5 = [XMLUtil getStringCommandParam:@"platformType" paramValue:IPHONE_NATIVE_PLATFORM];
        NSString * param6 = [XMLUtil getStringCommandParam:@"version" paramValue:RIVEPOINT_CLIENT_VERSION];
        NSString * param7 = [XMLUtil getStringCommandParam:@"latLngReqd" paramValue:@"1"];
        NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",param1,param2,param3,param4,param5,param6,param7];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
        NSString * reviewReqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:@"getFavPoi" andParams:params];
        fetchRequest = [[XMLPostRequest alloc]init];
        fetchRequest.delegate = (id) self;
        [fetchRequest sendPostRequestWithRequestName:k_Get_Fav_POI_More andRequestXML:reviewReqXML];
//        [request release];
    }
    else
    {
        if (self.isSavedCoupon == YES) {
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1= [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            NSString * param2=[XMLUtil getParamXMLWithName:@"platformType" andValue:@"0"];
            NSString * param3=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"100"];
            NSString * param4 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
            NSString * param5 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
            NSString * params = [NSString stringWithFormat:@"%@%@%@%@%@",param1,param2,param3,param4,param5];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_Saved_Cop andParams:params];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Get_Saved_Cop_More andRequestXML:reqXML];
//            [postReq release];
        }
        else
        {
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1= [XMLUtil getParamXMLWithName:@"userId" andValue:userID];
            NSString * param2=[XMLUtil getParamXMLWithName:@"fetchSize" andValue:@"100"];
            NSString * param3 = [XMLUtil getParamXMLWithName:@"userLatitude" andValue:appDelegate.setting.latitude];
            NSString * param4 = [XMLUtil getParamXMLWithName:@"userLongitude" andValue:appDelegate.setting.longitute];
            NSString * params = [NSString stringWithFormat:@"%@%@%@%@",param1,param2,param3,param4];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33]; 
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Get_Share_Cop andParams:params];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Get_Share_Cop_More andRequestXML:reqXML];
//            [postReq release];
        }
    }
}

-(void) fetchFavouritePOIsArray:(NSDictionary *)infoDic
{
    
    lblCount.hidden = NO;
    if (infoDic) {
        NSArray * favPoiArray = [infoDic valueForKey:@"Array"];
        if (favPoiArray.count > 0) {
            for (Poi * _poi in favPoiArray) {
                [self.couponArray addObject:_poi];
            }
            lblCount.text = [NSString stringWithFormat:@"%d Favorites",self.couponArray.count];
        }
        [tableView reloadData];
    }
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    fetchRequest.delegate = nil;
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) gotSavedCouponArray:(NSDictionary *)infoDic
{
   
    lblCount.hidden = NO;
    if (infoDic) {
        NSArray * array = [infoDic valueForKey:@"Array"];
        if (array.count > 0)
        {
            for (Coupon * _coup in array) {
                [self.couponArray addObject:_coup];
            }
            lblCount.text = [NSString stringWithFormat:@"%d Coupons",self.couponArray.count];
        }
        [tableView reloadData];
    }
//     [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    fetchRequest.delegate = nil;
    [fetchRequest release];
    fetchRequest = nil;
}

-(void)gotSharesAndSendCouponArray:(NSDictionary *)infoDic
{
   
    lblCount.hidden = NO;
    if (infoDic) {
        NSArray * array = [infoDic valueForKey:@"Array"];
        if (array.count > 0) {
            for (Coupon * _coup in array) {
                [self.couponArray addObject:_coup];
            }
            lblCount.text = [NSString stringWithFormat:@"%d Coupons",self.couponArray.count];
        }
        [tableView reloadData];
    }
//     [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    fetchRequest.delegate = nil;
    [fetchRequest release];
    fetchRequest = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"View All";
    isSaved = NO;
    isShared = NO;
    isEditable = NO;
    shouldNotRemove = NO;
    appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [GeneralUtil setRivepointLogo:self.navigationItem];
    lblTitle.text = self.cVtitle;
    NSMutableArray * _couponArray = [[NSMutableArray alloc]init];
    self.couponArray = _couponArray;
    [_couponArray release];
//    [appDelegate progressHudView:self.view andText:@"Loading..."];
//    [self performSelector:@selector(fetchDataFromServer) withObject:nil afterDelay:0.01];
//    if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
//        lblCount.text = [NSString stringWithFormat:@"%d Favorites",self.couponArray.count];
//    }
//    else
//        lblCount.text = [NSString stringWithFormat:@"%d Coupons",self.couponArray.count];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"View All Coupon View Controller - View is going to unload");
    
   self.couponArray = nil;
   _curSelectedCoupon = nil;
   _curIndexPath = nil;
   self.cVtitle = nil;

    tableView = nil;
    lblCount = nil;
    lblTitle = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    if (shouldNotRemove == NO) {
        [appDelegate progressHudView:self.view andText:@"Loading..."];
        [self performSelector:@selector(fetchDataFromServer) withObject:nil afterDelay:0.01];
    }
    else
        shouldNotRemove = NO;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear In");
    if (shouldNotRemove == NO) {
        if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
            [[self delegate] favoritePOIViewedWithFinalArray:self.couponArray];
        }
        else
        {
            if (self.isSavedCoupon == YES) {
                [[self delegate] savedCouponViewedWithFinalArray:self.couponArray];
            }
            else
            {
                [[self delegate] sharedCouponViewedWithFinalArray:self.couponArray];
            }
        }
        [self.couponArray removeAllObjects];
        [tableView reloadData];
    }
//    appDelegate = nil;
    fetchRequest.delegate = nil;
     NSLog(@"viewWillDisappear Out");
}

-(void) requestFailWithError:(NSString *)errorMsg
{
    NSLog(@"Request Fail with message : %@",errorMsg);
}

-(void) internetConnectionNotFoundForUserProfile
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    [appDelegate showAlertWithHeading:@"RivePoint" andDesc:@"Internet connection appears to be offline!"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 190, 25)];
        lblName.tag = k_lblName;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont fontWithName:@"ArialMT" size:12];
        lblName.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lblName];
        [lblName release];
        
        UILabel * lblExp =[[UILabel alloc]initWithFrame:CGRectMake(200, 3, 110, 25)];
        lblExp.tag = k_lblExp;
        lblExp.backgroundColor = [UIColor clearColor];
        lblExp.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblExp.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lblExp];
        [lblExp release];
        
        UILabel * lblSubTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 290, 13)];
        lblSubTitle.tag = k_lblDetail;
        lblSubTitle.backgroundColor = [UIColor clearColor];
        lblSubTitle.font = [UIFont fontWithName:@"ArialMT" size:10];
        lblSubTitle.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lblSubTitle];
        [lblSubTitle release];
    }
    UILabel * lblN = (UILabel *) [cell.contentView viewWithTag:k_lblName];
    UILabel * lblE = (UILabel *)[cell.contentView viewWithTag:k_lblExp];
    UILabel * lblD = (UILabel *)[cell.contentView viewWithTag:k_lblDetail];
    
    if ([self.cVtitle isEqualToString:k_ViewAll_Favorite])
    {
        Poi * _curPOI = [self.couponArray objectAtIndex:indexPath.row];
        if (_curPOI) {
            lblN.text = _curPOI.name;
            lblE.text = [NSString stringWithFormat:@"%@ MILES",_curPOI.distance];
            lblD.text = _curPOI.completeAddress;
        }
    }
    else
    {
        Coupon * _curCoupon = [self.couponArray objectAtIndex:indexPath.row];
        if (self.isSavedCoupon) {
            lblN.text = _curCoupon.title;
            lblE.text = [NSString stringWithFormat:@"Exp:%@",_curCoupon.validTo];
            NSString * _outLine = @"";
            if (_curCoupon.subTitleLineOne && _curCoupon.subTitleLineOne.length > 0) {
                _outLine = [_outLine stringByAppendingString:_curCoupon.subTitleLineOne];
                _outLine = [_outLine stringByAppendingString:@" "];
            }
            if (_curCoupon.subTitleLineTwo && _curCoupon.subTitleLineOne.length > 0) {
                _outLine = [_outLine stringByAppendingString:_curCoupon.subTitleLineOne];
            }
//            lblD.text = [NSString stringWithFormat:@"%@ %@",_curCoupon.subTitleLineOne,_curCoupon.subTitleLineTwo];
            lblD.text = _outLine;
        }
        else
        {
            lblN.text = _curCoupon.title;
            lblE.text = [NSString stringWithFormat:@"Exp: %@",_curCoupon.validTo];
//            lblD.text = _curCoupon.emailSharedVia; 
            lblD.text = [NSString stringWithFormat:@"Shared By: %@",_curCoupon.emailSharedVia];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
-(void) RemoveCouponOnIndex:(int) _index
{
    if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
        [appDelegate progressHudView:self.view andText:@"Processing..."];
        Poi * _cPOI = [self.couponArray objectAtIndex:_index];
        NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
        NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
        NSString * param2 = [XMLUtil getParamXMLWithName:@"poiId" andValue:_cPOI.poiId];
        NSString * params = [NSString stringWithFormat:@"%@%@",param1,param2];
        int rand = arc4random() % 1000;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
        NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Remove_Fav_POI andParams:params];
        fetchRequest = [[XMLPostRequest alloc]init];
        fetchRequest.delegate = (id)self;
        [fetchRequest sendPostRequestWithRequestName:k_Remove_Fav_POI andRequestXML:reqXML];
//        [request release];
    }
    else
    {
        if (self.isSavedCoupon == YES) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            Coupon * _cCoupon = [self.couponArray objectAtIndex:_index];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            NSString * param2 = [XMLUtil getParamXMLWithName:@"poiId" andValue:_cCoupon.poi.poiId];
            NSString * param3 = [XMLUtil getParamXMLWithName:@"couponId" andValue:_cCoupon.couponId];
            NSString * params = [NSString stringWithFormat:@"%@%@%@",param1,param2,param3];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Remove_Save_Coupon andParams:params];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Remove_Save_Coupon andRequestXML:reqXML];
//            [request release];
        }
        else
        {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            Coupon * _cCoupon = [self.couponArray objectAtIndex:_index];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"shId" andValue:_cCoupon.shareID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Remove_Share_coupon andParams:param1];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Remove_Share_coupon andRequestXML:reqXML];
//            [request release];
        }
    }
}

-(void) removeCellFromTableViewWithStatus:(NSString *)status
{
    if (_curIndexPath) {
        if ([status isEqualToString:@"1"]) {
            [self.couponArray removeObjectAtIndex:_curIndexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_curIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
                lblCount.text = [NSString stringWithFormat:@"%d Favorites",self.couponArray.count];
            }
            else
                lblCount.text = [NSString stringWithFormat:@"%d Coupons",self.couponArray.count];
            
        }
        [_curIndexPath release];
    }
    [appDelegate removeLoadingViewFromSuperView];
}

-(void) favouritePOIRemovedWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
//     [appDelegate removeLoadingViewFromSuperView];
    
    if ([status isEqualToString:@"1"]) {
        [self performSelector:@selector(removeCellFromTableViewWithStatus:) withObject:status afterDelay:0.3]; 
    }
    else
       [appDelegate removeLoadingViewFromSuperView]; 
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) savedCouponRemovedWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
//    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [self performSelector:@selector(removeCellFromTableViewWithStatus:) withObject:status afterDelay:0.3];
    }
    else
        [appDelegate removeLoadingViewFromSuperView]; 
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) sharedCouponRemovedWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
//    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [self performSelector:@selector(removeCellFromTableViewWithStatus:) withObject:status afterDelay:0.3];
    }
    else
        [appDelegate removeLoadingViewFromSuperView]; 
    [fetchRequest release];
    fetchRequest = nil;
}

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     _curIndexPath = [indexPath retain];
     [self RemoveCouponOnIndex:indexPath.row];
     
 }   
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view

 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
        Poi * _curPOI = [self.couponArray objectAtIndex:indexPath.row];
        if (_curPOI) {

            appDelegate.loadFromPersistantStore = NO;
            if (appDelegate.couponArray) {
                [appDelegate.couponArray removeAllObjects];
                appDelegate.couponArray = nil;
            }
            appDelegate.currentPoiCommand = 7;
            appDelegate.poi = _curPOI;
            shouldNotRemove = YES;
            ListCouponsViewController * viewController = [[ListCouponsViewController alloc]initWithNibName:@"ListCouponsView" bundle:nil];
            viewController.isFavoritePOI = YES;
            viewController.curPOI = _curPOI;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        
    }
    else
    {
        if (self.isSavedCoupon == YES) {
            Coupon * _curCoup = [self.couponArray objectAtIndex:indexPath.row];
            _curSelectedCoupon = _curCoup;
            isSaved = YES;
            isShared = NO;
            CouponDetailManager * _manager = [[CouponDetailManager alloc]init];
            [_manager showDetailAlertForSavedAndShared:_curCoup.poi coupon:_curCoup andDelegate:self];
            [_manager release];
        }
        else
        {
            Coupon * _curCoup = [self.couponArray objectAtIndex:indexPath.row];
            _curSelectedCoupon = _curCoup;
            isSaved = NO;
            isShared = YES;
            CouponDetailManager * _manager = [[CouponDetailManager alloc]init];
            [_manager showDetailAlertForSavedAndShared:_curCoup.poi coupon:_curCoup andDelegate:self];
            [_manager release];
        }
    }
}

-(IBAction) onDeleteAllBtn
{
    if (self.couponArray.count > 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Want to delete all?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        if ([self.cVtitle isEqualToString:k_ViewAll_Favorite]) {
            alert.tag = k_DA_Fav;
        }
        else
        {
            if (self.isSavedCoupon == YES) {
                alert.tag = k_DA_Sav;
            }
            else
            {
                alert.tag = k_DA_She;
            }
        } 
        [alert show];
        [alert release];
    }
    else
        [appDelegate showAlertWithHeading:@"Info" andDesc:@"No record found!"];
}

-(void) deletedAllFavoritePOIsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"])
    {
        [self.couponArray removeAllObjects];
        lblCount.text = @"0 Favorites";
        [tableView reloadData];
    }
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) deletedAllSavedCouponsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [self.couponArray removeAllObjects];
        lblCount.text = @"0 Coupons";
        [tableView reloadData];
    }
    [fetchRequest release];
    fetchRequest = nil;
}

-(void) deletedAllSharedCouonsWithStatus:(NSString *)status
{
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    if ([status isEqualToString:@"1"]) {
        [self.couponArray removeAllObjects];
        lblCount.text = @"0 Coupons";
        [tableView reloadData];
    }
    
    [fetchRequest release];
    fetchRequest = nil;
}

-(IBAction) onEditBtn
{
    if (isEditable == NO) {
        tableView.editing = YES;
        isEditable = YES;
        [editBtn setImage:[UIImage imageNamed:@"grayBtn-done.png"] forState:UIControlStateNormal];
    }
    else
    {
        tableView.editing = NO;
        isEditable = NO;
        [editBtn setImage:[UIImage imageNamed:@"grayBtn-edit.png"] forState:UIControlStateNormal];
    }
}

-(void) redeemCurrentSelectedCoupon
{
    if(!_curSelectedCoupon.perUserRedemption || [_curSelectedCoupon.perUserRedemption isEqualToString:@"-1"] || [_curSelectedCoupon.userRedemptionCount intValue] < [_curSelectedCoupon.perUserRedemption intValue])
    {
        shouldNotRemove = YES;
        Poi *poi = _curSelectedCoupon.poi;
        int userPoints = [poi.userPoints intValue];
        int reqPoints = [_curSelectedCoupon.reqdPoints intValue];
        
        CouponViewController * cvController = [[CouponViewController alloc] initWithNibName:@"Coupon" bundle:nil];
        
        if (_curSelectedCoupon.reqdPoints) {
            if(userPoints < reqPoints){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:@"Your points are less than the required points" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];	
                [alert release];
                return;
            }
            cvController.isLoyaltyPoi = YES;  
        }
        
        cvController.isSaved = isSaved;
        cvController.isShared = isShared;
        cvController.currCoupon = _curSelectedCoupon;
        cvController.curPOI = poi;
        cvController.numberOfPOICoupons = [poi.couponCount intValue];
        cvController.hidesBottomBarWhenPushed = YES;
        appDelegate.couponId = [_curSelectedCoupon.couponId intValue];
        [self.navigationController pushViewController:cvController animated:YES];
        [cvController release];
	}
	else
		[appDelegate  showAlert:NSLocalizedString(KEY_REDEMPTION_LIMIT_EXHAUSTED,@"") delegate:appDelegate];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Came here");
    if (alertView.tag == k_Coupon_Alert_Tag) {
        if (buttonIndex == 1) {
            [self redeemCurrentSelectedCoupon];
            NSLog(@"Redeem");
        }
        else
            NSLog(@"Cancel");
    }
    if (alertView.tag == k_DA_Fav) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Faorites andParams:param1];
//            XMLPostRequest * request = [[XMLPostRequest alloc]init];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Delete_All_Faorites andRequestXML:reqXML];
//            [request release];
        }
    }
    if (alertView.tag == k_DA_Sav) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Saved andParams:param1];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Delete_All_Saved andRequestXML:reqXML];
//            [request release];
        }
    }
    if (alertView.tag == k_DA_She) {
        if (buttonIndex == 1) {
            [appDelegate progressHudView:self.view andText:@"Processing..."];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:k_LoggedIn_User_Id];
            NSString * param1 = [XMLUtil getParamXMLWithName:@"uid" andValue:userID];
            int rand = arc4random() % 1000;
            NSString * reqId = [NSString stringWithFormat:@"%d",rand * 33];
            NSString * reqXML = [XMLUtil getFinalXMLOfRequestWithId:reqId andReqName:k_Delete_All_Shared andParams:param1];
            fetchRequest = [[XMLPostRequest alloc]init];
            fetchRequest.delegate = (id)self;
            [fetchRequest sendPostRequestWithRequestName:k_Delete_All_Shared andRequestXML:reqXML];
//            [request release];
        }
    }
    alertView.delegate = nil;
}

-(void) dealloc
{
    NSLog(@"View All Dealloc In");
    if (couponArray) {
        [couponArray release];
        couponArray = nil;
    }
    if (_curSelectedCoupon) {
//        [_curSelectedCoupon release];
        _curSelectedCoupon = nil;
    }
    if (_curIndexPath) {
//        [_curIndexPath release];
        _curIndexPath = nil;
    }
    if (cVtitle) {
        [cVtitle release];
    }
    
    [tableView release];
    [lblCount release];
    [lblTitle release];
    
    tableView = nil;
    lblCount = nil;
    lblTitle = nil;
    [super dealloc];
    NSLog(@"View All Dealloc Out");
}

@end
