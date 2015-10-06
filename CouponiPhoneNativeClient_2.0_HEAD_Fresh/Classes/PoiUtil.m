//
//  PoiUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/2/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "PoiUtil.h"
#import "ReloadCell.h"
#import "MoreViewCell.h"
#import "VendorViewCell.h"
#import "SponsoredViewCell.h"
#import "PoiFinderNew.h"


@implementation PoiUtil

+(UITableViewCell *) getAppropriateCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
							  poiFinder:(PoiFinderNew *)poiFinder poiArray:(NSArray*)poiArray 
								command:(NSString *)command	actualPOISInList:(int)actualPOISInList{
	
	/********************* Get Latest Records Cell... Started  **************************/
	if(indexPath.row == 0){
		static NSString *reload = @"Reload";
		ReloadCell *cell = (ReloadCell *)[tableView dequeueReusableCellWithIdentifier:reload];
		
		if(nil == cell) {
			UIViewController *c = [[UIViewController alloc] initWithNibName:reload bundle:nil];
			cell = (ReloadCell *) c.view;
			[c release];
		}		
        else{
            NSLog(@"reload Cell Created");
        }
		
		[cell setBackgroundImages];
		return cell;
	}
	/*************************** Get Latest Records Cell... Ended  ********************/
	
	/*************************** More Cell... Started ***********************************/
	
	if(indexPath.row > actualPOISInList){
		static NSString *moreCell = @"MoreCell";
		MoreViewCell *cell = (MoreViewCell *)[tableView dequeueReusableCellWithIdentifier:moreCell];
		
		if(nil == cell) {
            
            
			UIViewController *c = [[UIViewController alloc] initWithNibName:moreCell bundle:nil];
			cell = (MoreViewCell *) c.view;
			[c release];
		}
		else{
            NSLog(@"More Cell Created");
        }
		[cell setBackgroundImages];
		return cell;
	}	
	/*************************** More Cell... Ended ***********************************/
	
	if(poiFinder.isLoaded){
		
		VendorViewCell *cell;
		SponsoredViewCell *sponsoredCell;
		
//        NSLog(@"PoiArrayCount :  %d   IndexPath.row :   %d   And IndexPath.row-1   %d",poiArray.count, indexPath.row , indexPath.row  -1);
//        
//        if(indexPath.row == 22)
//        {
//            Poi *poi = [poiArray objectAtIndex:indexPath.row-1];
//            NSString *ss = poi.isSponsored;
//            NSLog(@"%@",ss);
//        }
		Poi *poi = (Poi *) [poiArray objectAtIndex:indexPath.row-1];
		if([poi.isSponsored isEqualToString:@"true"]){
			static NSString *poiCell = @"VendorCellSponsored";
			sponsoredCell = (SponsoredViewCell *)[tableView dequeueReusableCellWithIdentifier:poiCell];
			if(nil == sponsoredCell) {
				UIViewController *c = [[UIViewController alloc] initWithNibName:poiCell bundle:nil];
				sponsoredCell = (SponsoredViewCell *)c.view;
				[c release];
			}
			
			[sponsoredCell setBanner:poi];
			return sponsoredCell;
		}
		else{
			static NSString *poiCell = @"VendorViewCell";
			cell = (VendorViewCell *)[tableView dequeueReusableCellWithIdentifier:poiCell];
			if(nil == cell) {
				UIViewController *c = [[UIViewController alloc] initWithNibName:poiCell bundle:nil];
				cell = (VendorViewCell *) c.view;
				[cell setBackGroundWithPod];
				//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				[c release];
			}
//            else{
//                NSLog(@"VenderCreated");
//            }
		}
		
		cell.command = command;
		[cell setPoiContent:poi];
		[cell showDistanceLabel:poi];
		
		return cell;
	}
	return nil;
}

+(void)dialPhoneNumber:(Poi *)poi{
	
	if([poi.phoneNumber length] > 0 && ![poi.phoneNumber isEqualToString:@"null"]){
		NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",poi.phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		BOOL isSuccess = [[UIApplication sharedApplication] openURL:url];
		if(!isSuccess){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_APPLICATION_NAME,EMPTY_STRING) message:NSLocalizedString(KEY_CANT_CALL,EMPTY_STRING) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];	
			[alert release];
		}
	}


}


@end
