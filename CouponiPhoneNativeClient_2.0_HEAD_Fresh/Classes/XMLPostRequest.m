//
//  XMLPostRequest.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 11/22/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "XMLPostRequest.h"
#import "RivepointConstants.h"
#import "TBXML.h"
#import "RivePointAppDelegate.h"
#import "ReviewComment.h"
#import "Poi.h"
#import "Coupon.h"

@implementation XMLPostRequest
@synthesize requestName = _requestName;
@synthesize responseData = _responseData;
@synthesize delegate;

#pragma Request response XML parser Delegates

//double sec = 1000.00f;
//NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([coupon.validTo doubleValue])/sec];

-(void) showResponseAlert:(NSString *)msg
{
    NSLog(@"CameHere");
    RivePointAppDelegate * appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.progressHud removeFromSuperview];
    [appDelegate removeLoadingViewFromSuperView];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"RivePoint" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void) parseXMLForCouponsWithXMLData:(NSData *)xmlData
{
    NSMutableArray * couponArray = [NSMutableArray array];
    NSString * _totalCount = @"";
    TBXML * tbxml = [TBXML tbxmlWithXMLData:xmlData];
    if (tbxml) {
        TBXMLElement * root = tbxml.rootXMLElement;
        if (root) {
            TBXMLElement * response  = [TBXML childElementNamed:@"response" parentElement:root];
            if (response) {
                TBXMLElement * commands = [TBXML childElementNamed:@"commands" parentElement:response];
                if (commands) {
                    TBXMLElement * params = [TBXML childElementNamed:@"commandParams" parentElement:commands];
                    if (params) {
                        TBXMLElement * param = [TBXML childElementNamed:@"commandParam" parentElement:params];
                        if (param) {
                            TBXMLElement * paramValueCount = [TBXML childElementNamed:@"paramValue" parentElement:param];
                            if (paramValueCount) {
                                _totalCount = [TBXML textForElement:paramValueCount];
                            }
                        }
//                        TBXMLElement * param =  [TBXML childElementNamed:@"commandParam" parentElement:params];
                        param =  [TBXML nextSiblingNamed:@"commandParam" searchFromElement:param];
                         if (param) {
                            TBXMLElement * paramValue = [TBXML childElementNamed:@"paramValue" parentElement:param];
                            if (paramValue) {
                                TBXMLElement * vector = [TBXML childElementNamed:@"vector" parentElement:paramValue];
                                if (vector) {
                                    TBXMLElement * copElement = [TBXML childElementNamed:@"element" parentElement:vector];
                                    if (copElement) {
                                        while (copElement)
                                        {
                                            TBXMLElement * coupon = [TBXML childElementNamed:@"coupon" parentElement:copElement];
                                            if (coupon) {
                                                Coupon * curCoupon = [[Coupon alloc]init];
                                                TBXMLElement * couId = [TBXML childElementNamed:@"couponId" parentElement:coupon];
                                                if (couId) {
                                                    NSString * couIdT = [TBXML textForElement:couId];
                                                    curCoupon.couponId = couIdT;
                                                }
//                                                TBXMLElement * couPID = [TBXML childElementNamed:@"poiId" parentElement:coupon];
//                                                if (couPID) {
//                                                    NSString * couPIDT = [TBXML textForElement:couPID];
//                                                    curCoupon.poiId = couPIDT;
//                                                }
                                                TBXMLElement * couTitle = [TBXML childElementNamed:@"title" parentElement:coupon];
                                                if (couTitle) {
                                                    NSString * couTitleT = [TBXML textForElement:couTitle];
                                                    curCoupon.title = couTitleT;
                                                }
                                                TBXMLElement * couSubT1 = [TBXML childElementNamed:@"subTitleLineOne" parentElement:coupon];
                                                if (couSubT1) {
                                                    NSString * couSubT1T = [TBXML textForElement:couSubT1];
                                                    if (couSubT1T && couSubT1T.length > 0 && ![couSubT1T isEqualToString:@"null"]) {
                                                        curCoupon.subTitleLineOne = couSubT1T;
                                                    }else
                                                        curCoupon.subTitleLineOne = @"";
                                                }
                                                TBXMLElement * couSubT2 = [TBXML childElementNamed:@"subTitleLineTwo" parentElement:coupon];
                                                if (couSubT2) {
                                                    NSString * couSubT2T = [TBXML textForElement:couSubT2];
                                                    if (couSubT2T && couSubT2T.length > 0 && ![couSubT2T isEqualToString:@"null"]) {
                                                        curCoupon.subTitleLineTwo = couSubT2T;
                                                    }
                                                    else
                                                        curCoupon.subTitleLineTwo = @"";
                                                }
                                                
                                                TBXMLElement * couUCode = [TBXML childElementNamed:@"couponUniqueCode" parentElement:coupon];
                                                if (couUCode) {
                                                    NSString * couUCodeT = [TBXML textForElement:couUCode];
                                                    curCoupon.pk = [couUCodeT intValue];
                                                }
                                                TBXMLElement * couFrom = [TBXML childElementNamed:@"validFrom" parentElement:coupon];
                                                if (couFrom) {
                                                    NSString * couFromT = [TBXML textForElement:couFrom];
                                                    curCoupon.validFrom = couFromT;
                                                }
                                                TBXMLElement * couTo = [TBXML childElementNamed:@"validTo" parentElement:coupon];
                                                if (couTo) {
                                                    NSString * couToT = [TBXML textForElement:couTo];
                                                    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([couToT doubleValue])/1000];
                                                    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
                                                    [dtfrm setDateFormat:@"MM/dd/yyyy"];
                                                    NSString * nDate = [dtfrm stringFromDate:toDate];
                                                    curCoupon.validTo = [NSString stringWithFormat:@"%@", nDate];
                                                    [dtfrm release];
//                                                    double sec = 1000.00f;
//                                                    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:([couToT doubleValue])/sec];
//                                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//                                                    [dateFormatter setDateStyle:NSDateFormatterShortStyle]; 
//                                                    [dateFormatter setTimeStyle:NSDateFormatterNoStyle]; 
//                                                    NSString *tempDateStr =  [dateFormatter stringFromDate:toDate];
//                                                    NSArray *array = [tempDateStr componentsSeparatedByString:@"/"];
//                                                    int month =  [[array objectAtIndex:0] intValue];
//                                                    int day = [[array objectAtIndex:1] intValue];
//                                                    NSString *dateString = nil;
//                                                    if(month < 10 && day < 10)
//                                                        dateString = [NSString stringWithFormat:@"0%d/0%d/20%@",month,day,[array objectAtIndex:2]];
//                                                    else if(month < 10 && day > 10)
//                                                        dateString = [NSString stringWithFormat:@"0%d/%d/20%@",month,day,[array objectAtIndex:2]];
//                                                    else if(month > 10 && day < 10)
//                                                        dateString = [NSString stringWithFormat:@"%d/0%d/20%@",month,day,[array objectAtIndex:2]];
//                                                    else
//                                                        dateString = [NSString stringWithFormat:@"%d/%d/20%@",month,day,[array objectAtIndex:2]];
//                                                    [dateFormatter release];
//                                                    
//                                                    curCoupon.validTo = dateString;
                                                }
                                                
                                                TBXMLElement * couVenderImageName = [TBXML childElementNamed:@"vendorLogoImageName" parentElement:coupon];
                                                if (couVenderImageName) {
                                                    NSString * couVenderImageNameT = [TBXML textForElement:couVenderImageName];
                                                    curCoupon.vendorLogoImageName = couVenderImageNameT;
                                                }
                                                TBXMLElement * couImageName = [TBXML childElementNamed:@"couponImageName" parentElement:coupon];
                                                if (couImageName) {
                                                    NSString * couImageNameT = [TBXML textForElement:couImageName];
                                                    curCoupon.couponImageName = couImageNameT;
                                                }
                                                TBXMLElement * couType = [TBXML childElementNamed:@"couponType" parentElement:coupon];
                                                if (couType) {
                                                    NSString * couTypeT = [TBXML textForElement:couType];
                                                    curCoupon.couponType = couTypeT;
                                                }
                                                TBXMLElement * couAvailble = [TBXML childElementNamed:@"isAvailable" parentElement:coupon];
                                                if (couAvailble) {
                                                    NSString * couAvailbleT = [TBXML textForElement:couAvailble];
                                                    curCoupon.isAvailable = couAvailbleT;
                                                }
                                                TBXMLElement * couRestiricted = [TBXML childElementNamed:@"isRestrictedCoupon" parentElement:coupon];
                                                if (couRestiricted) {
                                                    NSString * couRestirictedT = [TBXML textForElement:couRestiricted];
                                                    curCoupon.isRestrictedCoupon = couRestirictedT;
                                                }
                                                TBXMLElement * couPerRed = [TBXML childElementNamed:@"perUserRedemption" parentElement:coupon];
                                                if (couPerRed) {
                                                    NSString * couPerRedT = [TBXML textForElement:couPerRed];
                                                    curCoupon.perUserRedemption = couPerRedT;
                                                }
                                                TBXMLElement * couURed = [TBXML childElementNamed:@"userRedemptionCount" parentElement:coupon];
                                                if (couURed) {
                                                    NSString * couURedT = [TBXML textForElement:couURed];
                                                    curCoupon.userRedemptionCount = couURedT;
                                                }
                                                TBXMLElement * couVec = [TBXML childElementNamed:@"vector" parentElement:coupon];
                                                if (couVec) {
                                                    TBXMLElement * couEle = [TBXML childElementNamed:@"element" parentElement:couVec];
                                                    if (couEle) {
                                                        TBXMLElement * couPOI = [TBXML childElementNamed:@"poi" parentElement:couEle];
                                                        if (couPOI) {
                                                            Poi * _poi = [[Poi alloc]init];
                                                            TBXMLElement * cou_PID = [TBXML childElementNamed:@"poiId" parentElement:couPOI];
                                                            NSString * cou_PIDT = [TBXML textForElement:cou_PID];
                                                            _poi.poiId = cou_PIDT;
                                                             curCoupon.poiId = cou_PIDT;
                                                            TBXMLElement * cou_ImageName = [TBXML childElementNamed:@"imageName" parentElement:couPOI];
                                                            if (cou_ImageName) {
                                                                NSString * cou_ImageNameT = [TBXML textForElement:cou_ImageName];
                                                                _poi.imageName = cou_ImageNameT;
                                                            }
                                                            TBXMLElement * cou_distance = [TBXML childElementNamed:@"distance" parentElement:couPOI];
                                                            if (cou_distance) {
                                                                NSString * _PDis = [TBXML textForElement:cou_distance];
                                                                _poi.distance = _PDis;
                                                            }
                                                            TBXMLElement * cou_SeqNo = [TBXML childElementNamed:@"poiSequenceNumber" parentElement:couPOI];
                                                            if (cou_SeqNo) {
                                                                NSString * _PSeqNo = [TBXML textForElement:cou_SeqNo];
                                                                _poi.poiSequenceNumber = _PSeqNo;
                                                            }
                                                            TBXMLElement * cou_Cat = [TBXML childElementNamed:@"poiCategoryId" parentElement:couPOI];
                                                            if (cou_Cat) {
                                                                NSString * _PCat = [TBXML textForElement:cou_Cat];
                                                                _poi.poiSequenceNumber = _PCat;
                                                            }
                                                            TBXMLElement * cou_Name = [TBXML childElementNamed:@"name" parentElement:couPOI];
                                                            if (cou_Name) {
                                                                NSString * _PName = [TBXML textForElement:cou_Name];
                                                                _poi.name = _PName;
                                                            }
                                                            TBXMLElement * cou_Phone = [TBXML childElementNamed:@"phoneNumber" parentElement:couPOI];
                                                            if (cou_Phone) {
                                                                NSString * _PPhone = [TBXML textForElement:cou_Phone];
                                                                _poi.phoneNumber = _PPhone;
                                                            }
                                                            TBXMLElement * cou_Address = [TBXML childElementNamed:@"completeAddress" parentElement:couPOI];
                                                            if (cou_Address) {
                                                                NSString * _PAddress = [TBXML textForElement:cou_Address];
                                                                _poi.completeAddress = _PAddress;
                                                            }
                                                            TBXMLElement * cou_Count = [TBXML childElementNamed:@"couponCount" parentElement:couPOI];
                                                            if (cou_Count) {
                                                                NSString * _PCount = [TBXML textForElement:cou_Count];
                                                                _poi.couponCount = _PCount;
                                                            }
                                                            TBXMLElement * cou_Sponsered = [TBXML childElementNamed:@"isSponsored" parentElement:couPOI];
                                                            if (cou_Sponsered) {
                                                                NSString * _PSponsered = [TBXML textForElement:cou_Sponsered];
                                                                _poi.isSponsored = _PSponsered;
                                                            }
                                                            TBXMLElement * cou_COTD = [TBXML childElementNamed:@"isCOTDPoi" parentElement:couPOI];
                                                            if (cou_COTD) {
                                                                NSString * _PCOTD = [TBXML textForElement:cou_COTD];
                                                                _poi.isCOTDPoi = _PCOTD;
                                                            }
                                                            
                                                            TBXMLElement * cou_PType = [TBXML childElementNamed:@"type" parentElement:couPOI];
                                                            if (cou_PType) {
                                                                NSString * cou_pTypeT = [TBXML textForElement:cou_PType];
                                                                _poi.poiType = cou_pTypeT;
                                                            }
                                                            
                                                            curCoupon.poi = _poi;
                                                            [_poi release];
                                                        }
                                                    }
                                                }
                                                TBXMLElement * couRate = [TBXML childElementNamed:@"rating" parentElement:coupon];
                                                if (couRate) {
                                                    NSString * couRateT = [TBXML textForElement:couRate];
                                                    curCoupon.rating = couRateT;
                                                }
                                                TBXMLElement * couiSCOTD = [TBXML childElementNamed:@"isCOTD" parentElement:coupon];
                                                if (couiSCOTD) {
                                                    NSString * couiSCOTDT = [TBXML textForElement:couiSCOTD];
                                                    curCoupon.isCOTD = couiSCOTDT;
                                                }
                                                TBXMLElement * couShId =[TBXML childElementNamed:@"sharerEmail" parentElement:coupon];
                                                if (couShId) {
                                                    NSString * couShIdT = [TBXML textForElement:couShId];
                                                    curCoupon.emailSharedVia = couShIdT;
                                                }
                                                TBXMLElement * coupSharedID = [TBXML childElementNamed:@"shId" parentElement:coupon];
                                                if (coupSharedID) {
                                                    NSString * shIDText = [TBXML textForElement:coupSharedID];
                                                    curCoupon.shareID = shIDText;
                                                }
                                                [couponArray addObject:curCoupon];
                                                [curCoupon release];
                                            }
                                            copElement = [TBXML nextSiblingNamed:@"element" searchFromElement:copElement];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSMutableDictionary * _infoDic = [NSMutableDictionary dictionary];
    [_infoDic setObject:_totalCount forKey:@"Count"];
    [_infoDic setObject:couponArray forKey:@"Array"];
    if ([_requestName isEqualToString:k_Get_Saved_Cop] || [_requestName isEqualToString:k_Get_Saved_Cop_More])
    {
        [[self delegate]gotSavedCouponArray:_infoDic];
    }
    if ([_requestName isEqualToString:k_Get_Share_Cop] || [_requestName isEqualToString:k_Get_Share_Cop_More])
    {
        [[self delegate]gotSharesAndSendCouponArray:_infoDic];
    }
}

-(void) parseXMLForPOIsWithXMLData:(NSData *)xmlData
{
    RivePointAppDelegate * appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hideActivityViewer];
    NSMutableArray * resultPoiArray = [NSMutableArray array];
    NSString * _totalCount=@"";
    TBXML * tbxml = [TBXML tbxmlWithXMLData:xmlData];
    if (tbxml)
    {
        TBXMLElement * root = tbxml.rootXMLElement;
        if (root)
        {
            TBXMLElement * response  = [TBXML childElementNamed:@"response" parentElement:root];
            if (response) {
                TBXMLElement * commands = [TBXML childElementNamed:@"commands" parentElement:response];
                if (commands) {
                    TBXMLElement * params = [TBXML childElementNamed:@"commandParams" parentElement:commands];
                    if (params) {
                        TBXMLElement * param = [TBXML childElementNamed:@"commandParam" parentElement:params];
                        if (param) {
                            TBXMLElement * paramValue = [TBXML childElementNamed:@"paramValue" parentElement:param];
                            if (paramValue) {
                                NSString * poiDataStr = [TBXML textForElement:paramValue];
                                if (poiDataStr && poiDataStr.length > 10)
                                {
                                    NSArray * dataSetArray = [poiDataStr componentsSeparatedByString:@"~^~"];
                                    for (NSString * _poiStr in dataSetArray)
                                    {
                                        Poi * _poi = [[Poi alloc]init];
                                        NSArray * poiStrArray = [_poiStr componentsSeparatedByString:@"[~]"];
                                        for(int i=0; i< [poiStrArray count] ; i++)
                                        {
                                            NSString *poiValue = [poiStrArray objectAtIndex:i];
                                            switch (i) {
                                                case 0:
                                                    _poi.poiId = poiValue;
                                                    break;
                                                case 1:
                                                    _poi.name = poiValue;
                                                    break;
                                                case 2:		
                                                    _poi.completeAddress = [poiValue stringByReplacingOccurrencesOfString:@";" withString:@","];
                                                    break;
                                                case 3:
                                                    _poi.phoneNumber = poiValue;
                                                    break;
                                                case 4:
                                                    if([poiValue compare:@"null"]!= NSOrderedSame)
                                                        _poi.imageBytes = poiValue;
                                                    break;
                                                case 5:
                                                    _poi.imageName = poiValue;
                                                    break;
                                                case 6:
                                                    if (![poiValue isEqualToString:@"null"]) {
                                                        _poi.distance = poiValue;
                                                    }
                                                    else
                                                        _poi.distance = @"0.0";
                                                    break;
                                                case 7:
                                                    _poi.poiCategoryId = poiValue;
                                                    break;			
                                                case 8:
                                                    _poi.couponCount = poiValue;
                                                    break;
                                                case 9:
                                                    _poi.isCOTDPoi = poiValue;
                                                    break;
                                                case 10:
                                                    _poi.isSponsored = poiValue;
                                                    break;
                                                case 11:
                                                    _poi.poiSequenceNumber = poiValue;
                                                    break;
                                                case 12:
                                                    _poi.userPoints = poiValue;
                                                    break;
                                                case 13:
                                                    _poi.reviewCount = [poiValue intValue];
                                                    break;	
                                                case 14:
                                                    _poi.feedbackCount = [poiValue intValue];
                                                    break;
                                                case 15:
                                                    _poi.poiType = poiValue;
                                                    break;
                                                case 16:
                                                    _poi.latitude = poiValue;
                                                    break;
                                                case 17:
                                                    _poi.longitude = poiValue;
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }
                                        [resultPoiArray addObject:_poi];
                                        [_poi release];
                                    }
                            }
                        }
                            param = [TBXML nextSiblingNamed:@"commandParam" searchFromElement:param];
                            if (param) {
                                TBXMLElement * paramValueCount =[TBXML childElementNamed:@"paramValue" parentElement:param];
                                if (paramValueCount) {
                                    _totalCount = [TBXML textForElement:paramValueCount];
                                }
                            }
                    }
                }
            }
           }
        }
    }
    
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    [infoDic setObject:_totalCount forKey:@"Count"];
    [infoDic setObject:resultPoiArray forKey:@"Array"];
    
    if ([_requestName isEqualToString:k_Get_Fav_POI] || [_requestName isEqualToString:k_Get_Fav_POI_More])
    {
        [[self delegate] fetchFavouritePOIsArray:infoDic];
    }
//    _responseData = nil;
    
}


-(void) parseXMLForPoiReviewWithXMLData:(NSData *)xmlData
{
     NSMutableArray * comments = [NSMutableArray array];
    TBXML * tbxml = [TBXML tbxmlWithXMLData:xmlData];
    if (tbxml)
    {
        TBXMLElement * root = tbxml.rootXMLElement;
        if (root)
        {
           
           
            TBXMLElement * response  = [TBXML childElementNamed:@"response" parentElement:root];
            TBXMLElement * commands = [TBXML childElementNamed:@"commands" parentElement:response];
            TBXMLElement * params = [TBXML childElementNamed:@"commandParams" parentElement:commands];
            TBXMLElement * param = [TBXML childElementNamed:@"commandParam" parentElement:params];
            while (param) 
            {
                TBXMLElement * paramValue = [TBXML childElementNamed:@"paramValue" parentElement:param];
                TBXMLElement * vector = [TBXML childElementNamed:@"vector" parentElement:paramValue];
                if (vector) {
                    ReviewComment * comment = [[ReviewComment alloc]init];
                    TBXMLElement * text = [TBXML childElementNamed:@"element" parentElement:vector];
                    NSString * _comText = [TBXML textForElement:text];
                    comment.comment = _comText;
                    TBXMLElement * name = [TBXML nextSiblingNamed:@"element" searchFromElement:text];
                    NSString * _name = [TBXML textForElement:name];
                    comment.commenter = _name;
                    [comments addObject:comment];
                    [comment release];
                }
                
                param = [TBXML nextSiblingNamed:@"commandParam" searchFromElement:param];
            }
            
        }
    }
    [[self delegate] fetchedPoiReviewArray:comments];
//    _responseData = nil;
}

-(void) parseXMLForBoolResultWithXMLData:(NSData *) xmlData
{
    TBXML * tbxml = [TBXML tbxmlWithXMLData:xmlData];
    if (tbxml) {
            
        TBXMLElement * root = tbxml.rootXMLElement;
        if (root)
        {
            TBXMLElement * response = [TBXML childElementNamed:@"response" parentElement:root];
            if (response) {
                    TBXMLElement * command = [TBXML childElementNamed:@"commands" parentElement:response];
                    TBXMLElement * params = [TBXML childElementNamed:@"commandParams" parentElement:command];
                    TBXMLElement * param = [TBXML childElementNamed:@"commandParam" parentElement:params];
                    TBXMLElement * value = [TBXML childElementNamed:@"paramValue" parentElement:param];
                    NSString * valueStr = [TBXML textForElement:value];
                
                if ([_requestName isEqualToString:k_AddFavPoiReq])
                {
                    [[self delegate] addPoiFavRequestCompletedWithSatus:valueStr];
                }
                if ([_requestName isEqualToString:k_AddPoiRatingReq])
                {
                    [[self delegate] addPoiRatingRequestCompletedWithSatus:valueStr];
                }
                if ([_requestName isEqualToString:k_AddPoiReviewReq])
                {
                    [[self delegate] addPoiReviewRequestCompletedWithSatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Get_User_Profile])
                {
                    [[self delegate] fetchedUserProfileString:valueStr];
                }
                if ([_requestName isEqualToString:k_Add_Poi_Photo])
                {
                    [[self delegate] poiPhotoUploadedWithStatusCode:valueStr];
                }
                if ([_requestName isEqualToString:k_Get_User_Image])
                {
                    [[self delegate] fetchedUserprofileImageWithImageDataString:valueStr];
                }
                if ([_requestName isEqualToString:k_User_Login])
                {
                    [[self delegate] userSuccessfullyLoggedinWithId:valueStr];
                }
                if ([_requestName isEqualToString:k_Save_Coupon]) {
                    [[self delegate] couponSavedWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_User_Register]) {
                    [[self delegate] userRegisterWithResponseStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Remove_Fav_POI]) {
                    [[self delegate] favouritePOIRemovedWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Remove_Save_Coupon]) {
                    [[self delegate] savedCouponRemovedWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Remove_Share_coupon]) {
                    [[self delegate] sharedCouponRemovedWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Delete_All_Faorites]) {
                    [[self delegate] deletedAllFavoritePOIsWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Delete_All_Saved]) {
                    [[self delegate] deletedAllSavedCouponsWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_Delete_All_Shared]) {
                    [[self delegate] deletedAllSharedCouonsWithStatus:valueStr];
                }
                if ([_requestName isEqualToString:k_User_Update]) {
                    [[self delegate] userProfileUpdatedWithStatus:valueStr];
                    return;
                }
                if ([_requestName isEqualToString:k_Share_Image_Command]) {
                    [[self delegate] imageSharedViaEmail:valueStr];
                }
                if ([_requestName isEqualToString:k_RedeemCoupon_Call]) {
                    [[self delegate] couponRedeemedWithStatus:valueStr];
                }
//                if (valueStr.length < 2)
//                {
//                    if ([valueStr isEqualToString:k_Status_OK])
//                    {
//                        [self showResponseAlert:@"Request successfull."];
//                    }
//                    if ([valueStr isEqualToString:K_Status_Fail])
//                    {
//                        [self showResponseAlert:@"Service not found."];
//                    }
//                    if ([valueStr isEqualToString:k_Status_AlreadyExist])
//                    {
//                        [self showResponseAlert:@"Already marked favorite."];
//                    }
//                }
            }
        }   
    
    }
//    _responseData = nil;
}

-(void) parseXMLForSharedPhotosIdsResultWithXMLData:(NSData *) xmlData
{
    RivePointAppDelegate * appDelegate = (RivePointAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hideActivityViewer];
    NSMutableArray * photosIdArray = [NSMutableArray array];
    TBXML * tbxml = [TBXML tbxmlWithXMLData:xmlData];
    if (tbxml)
    {
        TBXMLElement * root = tbxml.rootXMLElement;
        if (root)
        {
            TBXMLElement * response  = [TBXML childElementNamed:@"response" parentElement:root];
            TBXMLElement * commands = [TBXML childElementNamed:@"commands" parentElement:response];
            TBXMLElement * params = [TBXML childElementNamed:@"commandParams" parentElement:commands];
            TBXMLElement * param = [TBXML childElementNamed:@"commandParam" parentElement:params];
            TBXMLElement * paramValue = [TBXML childElementNamed:@"paramValue" parentElement:param];
            TBXMLElement * vector = [TBXML childElementNamed:@"vector" parentElement:paramValue];
            TBXMLElement * eleID = [TBXML childElementNamed:@"element" parentElement:vector];
            while (eleID) {
                NSString * eleIDT = [TBXML textForElement:eleID];
                [photosIdArray addObject:eleIDT];
                eleID = [TBXML nextSiblingNamed:@"element" searchFromElement:eleID];
            }
           
        }
    }
    if ([_requestName isEqualToString:k_Get_user_Shared_Photo]) {
        [[self delegate] fetchedUserSharedPhotosIdsArray:photosIdArray];
    }
    if ([_requestName isEqualToString:k_Get_POI_Shared_Photo]) {
        [[self delegate] fetchedPOISharedPhotosIdsArray:photosIdArray];
    }
    if ([_requestName isEqualToString:k_Get_user_Shared_Photo_More]) {
        [[self delegate] fetchedUserSharedPhotosIdsArray:photosIdArray];
    }
//    _responseData = nil;
}


#pragma Request Method and Delegates

-(void)sendPostRequestWithRequestName:(NSString *)name andRequestXML:(NSString *)xml
{
    _requestName = [name copy];
    NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *urlFileName = @"url";
	NSString *urlPathString = [thisBundle pathForResource:urlFileName	ofType:@"txt"];
	NSString *prefixURL = [NSString stringWithContentsOfFile:urlPathString encoding:NSUTF8StringEncoding error:nil];
    if (prefixURL && prefixURL.length > 0)
    {
        int rand = arc4random() % 95135;
        NSString * reqId = [NSString stringWithFormat:@"%d",rand];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",prefixURL,RIVEPOINT_MAIN_SERVLET,reqId]];
        NSString *requestParamterForServer = [NSString stringWithFormat:@"%@%@",GPS_FRAMEWORK_PAYLOAD,xml ];
        NSMutableURLRequest * theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:CONNECTION_TIME_OUT];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [xml length]];
        [theRequest addValue: CONTENT_TYPE_VALUE forHTTPHeaderField:CONTENT_TYPE];
        [theRequest addValue: msgLength forHTTPHeaderField:CONTENT_LENGTH];
        [theRequest setHTTPMethod: HTTP_METHOD];
        [theRequest setHTTPBody: [requestParamterForServer dataUsingEncoding:NSUTF8StringEncoding]];
        if(connection)
            [connection release];
        connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        if( connection )
        {
            if (_responseData) {
                [_responseData release];
                _responseData = [[NSMutableData alloc]init];
            }
            else
                _responseData = [[NSMutableData alloc]init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
    }
}

-(void)connection:(NSURLConnection *)connection1 didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    if (code != 200)
    {
        [connection cancel];
        [_responseData setLength:0];
        [self showResponseAlert:@"Service not found."];
        [[self delegate] requestFailWithError:_requestName];

    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    _responseData = [data retain];
    if (_responseData) {
        [_responseData appendData:data];
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (![_requestName isEqualToString:k_Get_Fav_POI]&& ![_requestName isEqualToString:k_Get_Share_Cop] && ![_requestName isEqualToString:k_Get_user_Shared_Photo] && ![_requestName isEqualToString:k_Get_User_Profile]) 
    {
        if (![_requestName isEqualToString:k_Get_Saved_Cop]) {
            [self showResponseAlert:@"Internet connection appears to be offline!"];
            [[self delegate] requestFailWithError:_requestName];
        }
        else
            [[self delegate] internetConnectionNotFoundForUserProfile];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_responseData.length > 0)
    {
        if ([_requestName isEqualToString:k_Get_POI_Reviews])
        {
            [self parseXMLForPoiReviewWithXMLData:_responseData];
        }
        else
            if ([_requestName isEqualToString:k_Get_Fav_POI] || [_requestName isEqualToString:k_Get_Fav_POI_More])
            {
                [self parseXMLForPOIsWithXMLData:_responseData]; 
            }
            else
                if ([_requestName isEqualToString:k_Get_Saved_Cop] || [_requestName isEqualToString:k_Get_Share_Cop] || [_requestName isEqualToString:k_Get_Saved_Cop_More] || [_requestName isEqualToString:k_Get_Share_Cop_More])
                {
                    [self parseXMLForCouponsWithXMLData:_responseData];
                }
                else
                    if ([_requestName isEqualToString:k_Get_user_Shared_Photo] ||[_requestName isEqualToString:k_Get_POI_Shared_Photo]||[_requestName isEqualToString:k_Get_user_Shared_Photo_More]) {
                        [self parseXMLForSharedPhotosIdsResultWithXMLData:_responseData];
                    }
                    else
                        [self parseXMLForBoolResultWithXMLData:_responseData];
    }
    else
    {
        [self showResponseAlert:@"Service not found."];
        [[self delegate] requestFailWithError:_requestName];
    }
    
    [_responseData setLength:0];
    [_responseData release];
    _responseData = nil;
}

-(void) cancelCurrentRequest
{

}

@end
