//
//  CellCustomButton.h
//  iQila
//
//  Created by Jasim Qazi on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@class CellCustomButton;

@protocol CellCustomButtonImageDownLoadDelegate

-(void) imageDownloadCompleteWithImageData:(UIImage *)image ofIndex:(int) index andSelf:(CellCustomButton *)selfObj;

@end

@interface CellCustomButton : UIButton
{
    NSString *url;
    ASIHTTPRequest *request ;
    int index;
    id <CellCustomButtonImageDownLoadDelegate> delegate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic , retain)id <CellCustomButtonImageDownLoadDelegate> delegate;
@property (nonatomic) int index;
-(void) startButtonImageDownloadWithUrl:(NSString*)URL;
@end
