//
//  WTHelper.h
//  omim
//
//  Created by coca on 2012/12/18.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeviceHelper.h"
#import "VersionHelper.h"
#import "AvatarHelper.h"
#import "MessageHelper.h"
#import "TimeHelper.h"

#import "SDKConstant.h"

#import "UISize.h"
#import "MediaProcessing.h"

#import "WTCategory.h"
#import "JSON.h"

@interface WTHelper : NSObject



#pragma mark -
#pragma mark  Log helper
+(void)WTLog:(NSString*)strlog;
+(void)WTLogError:(NSError*)error;

#pragma mark -
#pragma mark phone number helper
+(NSString*) encryptPhoneNumber:(NSString*)strphonenumber;
+(NSString*) translatePhoneNumberToGlobalNumber:(NSString*)phoneNumber;

+ (BOOL)isDemoPhoneNumber:(NSString *)strPhoneNumber;

@end
