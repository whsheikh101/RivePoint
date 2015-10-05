//
//  XMLUtil.m
//  HelloWorld
//
//  Created by Muhammad Hammad Ayaz on 2/16/09.
//  Copyright 2009 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "XMLUtil.h"


@implementation XMLUtil

+(NSString *) getStringCommandParam:(NSString *)name paramValue: (NSString *)value{
	
	NSString *string =[NSString stringWithFormat:@"<commandParam name=\"%@\">"
					   "<isCollection>false</isCollection>"
					   "<collectionType></collectionType>"
					   "<objectType>java.lang.StringBuffer</objectType>"
					   "<paramValue>"
					   "<![CDATA[%@]]>"
					   "</paramValue>"
					   "</commandParam>",name,value];
	
	return string;
}

+(NSString *) getFinalXML:(NSString *) name params:(NSString *) params{
	NSString *string =[NSString stringWithFormat:@"<requests>"
	"<request id=\"9\">"
	"<commands name=\"%@\">"
	"<commandParams>%@</commandParams></commands></request></requests>",name,params];
	
	return string;

}

+(NSString *)getClientVersionDtoXML:(NSString *)userId version:(NSString *)version 
							 vendor:(NSString *)vendor clientType:(NSString *)clientType{
	NSString *string =[NSString stringWithFormat:@"<commandParam name=\"clientVer\">"
	 "<isCollection>false</isCollection>"
	 "<collectionType></collectionType>"
	 "<objectType>com.netpace.gpsframework.poc.commons.dto.ClientVersionDto</objectType>"
	 "<paramValue><clientVer>"
	"<vendor>%@</vendor>"
	"<version>%@</version>"
	"<clientType>%@</clientType>"
	"<uid>%@</uid></clientVer>"
	"</paramValue></commandParam></commandParams>",vendor,version,clientType,userId];
	return string;
	
}
+(NSString *)getDtoEmailSubscriptionXML:(NSString *)subscriberId email:(NSString *)email {
	
	NSString *string =[NSString stringWithFormat:@	"<commandParam name=\"user\">"
					   "<isCollection>false</isCollection>"
					   "<collectionType></collectionType>"
					   "<objectType>com.netpace.gpsframework.poc.commons.dto.SubscriberDto</objectType>"
					   "<paramValue><user>"
					   "<sid>%@</sid>"
					   "<email>%@</email>"
					   "</user></paramValue></commandParam>",subscriberId,email];
	

	
	return string;
	
}
+(NSString *)getDtoCommandParam:(NSString *)paramName javaObjectType:(NSString *)objectType 
			   objectDto:(NSString *)objectDto{
	
	return [NSString stringWithFormat:[self getParamDtoFormatString],paramName,objectType,objectDto];
	
}
+(NSString *)getParamDtoFormatString{
	NSString *string =[NSString stringWithString:@"<commandParam name=\"%@\">"
					   "<isCollection>false</isCollection>"
					   "<collectionType></collectionType>"
					   "<objectType>com.netpace.gpsframework.poc.commons.dto.%@</objectType>"
					   "<paramValue>%@"
					   "</paramValue></commandParam>"];
	
	return string;
	
}
+(NSString *)getParamSharedCouponDto:(NSString *)subscriberId{
	NSString *string =[NSString stringWithFormat:@"<sharedCoupon>"
					   "<rcvrId>%@</rcvrId>"
					   "</sharedCoupon>",subscriberId];
	
	return string;
	
}
+(void)setCommonParams:(NSMutableString *)string{
	[string appendString:[XMLUtil getStringCommandParam:@"platformType" paramValue:IPHONE_NATIVE_PLATFORM ]];
//    [string appendString:[XMLUtil getStringCommandParam:@"clientType" paramValue:IPHONE_NATIVE_PLATFORM ]];
	[string appendString:[XMLUtil getStringCommandParam:@"version" paramValue:RIVEPOINT_CLIENT_VERSION ]];
}

+(NSString *) getFinalXMLOfRequestWithId:(NSString *)rid andReqName:(NSString *)reqName andParams:(NSString *)params
{
    NSString * xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                            "<requests xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"xsi:noNamespaceSchemaLocation=\"E:\\PROJEC~1\\GPSFRA~1\\docs\\PROTOC~1\\protocol-request-spec-1.0.xsd\">"
                            "<request id=\"%@\">"
                            "<commands name=\"%@\">"
                            "<commandParams>%@</commandParams>"
                            "</commands></request></requests>",rid,reqName,params];
    return xmlString;
}
+(NSString *) getParamXMLWithName:(NSString *)paramName andValue:(NSString *)value
{
    NSString * xmlString = [NSString stringWithFormat:@"<commandParam name=\"%@\">"
                            "<isCollection>false</isCollection>"
                            "<collectionType></collectionType>"
                            "<objectType>java.lang.StringBuffer</objectType>"
                            "<paramValue><![CDATA[%@]]></paramValue>"
                            "</commandParam>",paramName,value];
    return xmlString;
}

@end
