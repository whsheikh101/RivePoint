//
//  StringUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 3/25/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringUtil : NSObject {

}
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL)validationEmailTextField:(NSString *)inputText;
+ (BOOL) checkDeuplicates:(NSString *) email delimiter:(char) delimiter;
+ (BOOL) checkForIllegalCharacter:(NSString *) email;
@end
