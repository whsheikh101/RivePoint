//
//  StringUtil.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/25/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "StringUtil.h"
#import "NSExtendedString.h"

@implementation StringUtil
#define ILLEGAL_EMAIL_CHARS @"!#$^&*()+|}{[]?><~%:;/,=`"

+ (BOOL) validateEmail:(NSString *)email {
	
	NSString *truncatedString = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	char atTheRate = '@';
	char dot = '.';
	
	int strLength = 0;
	if (email == nil || (strLength = [truncatedString length]) == 0) {
		return NO;
	}
	//System.out.println("strLength: " + strLength);
	
	if ([StringUtil checkDeuplicates:truncatedString delimiter:atTheRate]) {
		return NO;
	}
	/*
	if ([StringUtil checkDeuplicates:truncatedString delimiter:dot]) {
		validationStatus =  NO;
	}
	*/
	NSExtendedString *extendedString = [[[NSExtendedString alloc] initWithString:truncatedString] autorelease];
	[truncatedString release];
	
	int indexOfAtTheRate = [extendedString indexOf:atTheRate];
	//System.out.println("indexOfAtTheRate: " + indexOfAtTheRate);
	if (indexOfAtTheRate == NSNotFound || indexOfAtTheRate == 0 || indexOfAtTheRate == strLength-1) {
		//[truncatedString release];
		//[extendedString release];
		return NO;
	}
	
	int indexOfDot = [extendedString indexOf:dot];
	//System.out.println("indexOfDot: " + indexOfDot);
	if (indexOfDot == NSNotFound || indexOfDot == 0 || indexOfDot == strLength -2){
		//[truncatedString release];
		//[extendedString release];
		return NO;
	}
	
	
	//System.out.println("Last:" + email.trim().substring(strLength-1));
	
	if ([[truncatedString substringWithRange:NSMakeRange(indexOfAtTheRate-1,1)] isEqualToString:@"."] ||
		[[truncatedString substringWithRange:NSMakeRange(indexOfAtTheRate+1,1)] isEqualToString:@"."]){
		
		//[truncatedString release];
		//[extendedString release];
		return NO;
	}
	

	if ([extendedString indexOf:' '] != NSNotFound) {
		//[truncatedString release];
		//[extendedString release];
		return NO;
	}
	
	if ([StringUtil checkForIllegalCharacter:truncatedString]) {
		//[truncatedString release];
		//[extendedString release];
		return NO;
	}
	NSLog(@"truncatedString Retain Count [%d],extendedString[%d]",[truncatedString retainCount],[extendedString retainCount]);
	//[truncatedString release];
	//[extendedString release];
	return YES;
}


+ (BOOL) checkDeuplicates:(NSString *) email delimiter:(char) delimiter {
	int charCount = 0;
	for (int i = 0; i < [email length]; i++) {
		char c = [email characterAtIndex:i];
		if (c == delimiter) {
			charCount = charCount + 1;
		}
		if (charCount == 2) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL) checkForIllegalCharacter:(NSString *) email {
	char lchar = '\0';
	NSExtendedString *illegalChars = [[NSExtendedString alloc] initWithString:ILLEGAL_EMAIL_CHARS];
	for (int i=0; i < [email length]; i++) {
		char c = [email characterAtIndex:i];
		if(i > 0) {
			lchar= [email characterAtIndex:(i-1)];
		}
		if ([illegalChars indexOf:c] != NSNotFound || (lchar=='.' && c =='.')) {
			[illegalChars release];
			return YES;
		}
	}
	[illegalChars release];
	return NO;
}
@end
