//
//  XMLUtil.h
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/16/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandParam.h"

@interface XMLUtil : NSObject {
#define STRING_BUFFER @"java.lang.StringBuffer"	
#define COMMAND_PARAMS_ELEMENT @"commandParams"
#define COMMAND_PARAM_ELEMENT @"commandParam"
#define XML_DOCUMENT_VERSION @"1.0"
#define XML_DOCUMENT_ENCODING @"UTF-8"
#define REQUESTS_ELEMENT @"requests"
#define REQUEST_ELEMENT @"request"
#define REQUEST_ID @"id"
#define COMMANDS_ELEMENT @"commands"
#define NAME_ATTRIBUTE @"name"
#define IS_COLLECTION_ELEMENT @"isCollection"
#define FALSE_VALUE @"false"
#define COLLECTION_TYPE_ELEMENT @"collectionType"
#define OBJECT_TYPE_ELEMENT @"objectType"
#define PARAM_VALUE_ELEMENT @"paramValue"
	
#define IPHONE_NATIVE_PLATFORM @"4"
#define RIVEPOINT_CLIENT_VERSION @"3.3"

	
}


+(NSString *) getStringCommandParam:(NSString *)name paramValue: (NSString *)value;

+(NSString *) getFinalXML:(NSString *) name params:(NSString *) params;

+(NSString *) getClientVersionDtoXML:(NSString *)userId version:(NSString *)version 
							 vendor:(NSString *)vendor clientType:(NSString *)clientType;

+(NSString *)getDtoEmailSubscriptionXML:(NSString *)subscriberId email:(NSString *)email;

+(NSString *)getParamDtoFormatString;

+(NSString *)getDtoCommandParam:(NSString *)paramName javaObjectType:(NSString *)objectType 
			   objectDto:(NSString *)objectDto;

+(NSString *)getParamSharedCouponDto:(NSString *)subscriberId;

+(void)setCommonParams:(NSMutableString *)string;

// Added by Arain.

+(NSString *) getFinalXMLOfRequestWithId:(NSString *)rid andReqName:(NSString *)reqName andParams:(NSString *)params;
+(NSString *) getParamXMLWithName:(NSString *)paramName andValue:(NSString *)value;

@end
