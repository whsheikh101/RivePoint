//
//  CustomImage.h
//  iQila
//
//  Created by Jasim Qazi on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@protocol imageTouchedDelegate <NSObject>
-(void) onImageClicked;
-(void) imageDownLoadCompleteForIndex:(int) index withImage: (UIImage *) image;
@end

@interface CustomImage : UIImageView  {
    
    
    NSString *url;
    ASIHTTPRequest *request ;
    int index;
    //array to hold all the urls
    id <imageTouchedDelegate> delegate;
    BOOL isSentRequest;
}


@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic , retain)  id <imageTouchedDelegate> delegate;
@property (nonatomic)int index; 
@property (nonatomic) BOOL isSentRequest;

-(void) startDownloadWithUrl:(NSString*)URL;
-(void) stopLoadingImage;

@end
