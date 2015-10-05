//
//  CustomImage.m
//  iQila
//
//  Created by Jasim Qazi on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomImage.h"

@implementation CustomImage

@synthesize url,request;
@synthesize delegate;
@synthesize index;
@synthesize isSentRequest;

-(void) startDownloadWithUrl:(NSString*)URL{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        self.url = [URL copy];
        
        if(![url isEqualToString:@""])
        {
            request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            [request startAsynchronous];
        }
//        else
//        {
//            NSLog(@"failing conditions");
//        }
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
    {
        [request clearDelegatesAndCancel];
        [request release];
    }
    [url release];
    url = nil;
    [super dealloc];
}

-(void) stopLoadingImage
{
    if (request && [request isExecuting]) {
//    if (request) {
        [request clearDelegatesAndCancel];
        [request release];
    }
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
                UIImage *  tempImage = [UIImage imageWithData:responseData];
                self.image = tempImage;   
                [[self delegate] imageDownLoadCompleteForIndex:self.index withImage:self.image];
            }
        }
        else
        {
            //to handle the click event
            self.url = nil;
        }
        
        requeste.delegate = nil;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %s, %@",__func__,[exception description]);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)requeste
{
    if(!self)
        return;
    self.url = nil;
}


#pragma mark - TOUCH EVENTS
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [[self delegate] onImageClicked];
    NSLog(@"touchesEnded");
}


@end
