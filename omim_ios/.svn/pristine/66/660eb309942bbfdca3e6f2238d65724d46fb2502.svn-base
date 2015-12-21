//
//  WTHelper.m
//  omim
//
//  Created by coca on 2012/12/18.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "WTHelper.h"
#import "GlobalSetting.h"
#import "MD5Extensions.h"
#import "WTConstant.h"
#import "WTError.h"
#import "WTUserDefaults.h"
#import "WarningView.h"
@interface WTHelper ()

+(NSString*) stripPhoneNumber:(NSString*)phoneNumber;

@end

@implementation WTHelper

+(void)WTLog:(NSString *)str
{
    if(PRINT_LOG) NSLog(@"%@",str);
 //   NSLog(@"%@",str);
}

+(void)WTLogError:(NSError*)error
{
     if(PRINT_LOG) NSLog(@"%@",[NSString stringWithFormat:@"error domain:%@ ;\r error code: %zi ; \r error description: %@", error.domain,error.code,error.description]);
    //Danger here.
    if (error.code == 2 || error.code == -10) {
        return;
    }
    
    if (error.code == NETWORK_IS_NOT_AVAILABLE) {
        // currently we only handle network is not available error.
        
        [[WarningView sharedView] showAlert:error];
  
        /*
       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Network is not available now, please try it later", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
     */
        
    }

    
   
}


#pragma mark -
#pragma mark　encription

+(NSString*) encryptPhoneNumber:(NSString*)strphonenumber
{
    if (strphonenumber==NULL || [strphonenumber isEqualToString:@""]) {
        return  NULL;
    }
    strphonenumber = [WTHelper translatePhoneNumberToGlobalNumber:strphonenumber];
    if (strphonenumber ==NULL) {
        return  NULL;
    }
    
    return [strphonenumber md5AndSalt];
}


//strip and add country code
+(NSString*) translatePhoneNumberToGlobalNumber:(NSString*)phoneNumber{
    if (phoneNumber == nil) {
        return nil;
    }
	NSString* result = [WTHelper stripPhoneNumber:phoneNumber];
	
	if (result==nil) {
		return nil;
	}
	//we are sure the length of result is >1 now since length ==0 is returning as nil in stripPhoneNumber
	if (![[result substringToIndex:1] isEqualToString:@"+"]) {
		if ([[result substringToIndex:1] isEqualToString:@"0"]) {
		    	result = [result substringFromIndex:1];
		}
		//TODO: change to use static value then read it from db everytime
		result = [NSString stringWithFormat:@"+%@%@",[WTUserDefaults getCountryCode],result];
	}
	return result;
}

+(NSString*) stripPhoneNumber:(NSString*)phoneNumber{
	if (phoneNumber==nil) {
		return nil;
	}
	NSString* result = [NSString stringWithString:phoneNumber];
	result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
	result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
	result = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
	result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
	
	if ([result isEqualToString:@""] ) {
		return nil;
	}
	
	return result;
}


+ (BOOL)isDemoPhoneNumber:(NSString *)strPhoneNumber
{
    if ([strPhoneNumber rangeOfString:@"1980121619801216"].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

@end
