//
//  CellCustomButton.m
//  iQila
//
//  Created by Jasim Qazi on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellCustomButton.h"

@implementation CellCustomButton
@synthesize url, request;
@synthesize delegate;
@synthesize index;

-(void) startButtonImageDownloadWithUrl:(NSString*)URL
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        self.url = [URL copy];
        
        if(![url isEqualToString:@""])
        {
            request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
            [request setDelegate:self];
            [request startAsynchronous];
        }
        else
        {
            NSLog(@"failing conditions");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %s, %@",__func__,[exception description]);
    }
    [pool drain];
}


- (void)dealloc
{
    // Cancels an asynchronous request, clearing all delegates and blocks first
    if(request != nil)
        [request clearDelegatesAndCancel];
    [request release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)requeste
{
    @try {
        if(!self)
            return;
        NSString *contentType = [[requeste responseHeaders] objectForKey:@"Content-Type"];
        //DLog(@"Header is %@",contentType);
        if(![contentType isEqualToString:@"text/html"])
        {
            NSData *responseData = [requeste responseData];
            if(responseData && [responseData length]>0)
            {
//                UIImage *tempImage = [[UIImage alloc] initWithData:responseData];
                UIImage *tempImage = [UIImage imageWithData:responseData];
                [[self imageView] setContentMode: UIViewContentModeScaleAspectFill];
                [self setImage:tempImage forState:UIControlStateNormal];
                [[self delegate] imageDownloadCompleteWithImageData:tempImage ofIndex:self.index andSelf:self];
            }
        }
        else
        {
            //to handle the click event
            NSLog(@"%s setting nil to url %@",__func__,self.url);
            self.url = nil;
        }
        self.delegate = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %s, %@",__func__,[exception description]);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)requeste
{
    if(!self)
        return;
    NSError *error = [requeste error];
    NSLog(@"%s setting nil to url %@",__func__,self.url);
    self.url = nil;
    NSLog(@"error in downloading image with description = %@",[error description]);
}


@end
