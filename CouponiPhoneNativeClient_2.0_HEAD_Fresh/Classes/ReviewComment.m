//
//  ReviewComment.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/11/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "ReviewComment.h"

@implementation ReviewComment
@synthesize comment=_comment,commenter=_commenter;

-(void) dealloc
{
    [_comment release];
    [_commenter release];
    _commenter = nil;
    _comment = nil;
    [super dealloc];
}

@end
