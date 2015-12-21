//
//  WTUserDefaults.h
//  omim
//
//  Created by Harry on 14-1-15.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 用户修改了绑定的手机号码 */
#define OM_DIDCHANGE_TELEPHONENUMBER @"OM_didchange_telephonenumber"

/** 用户修改了绑定的邮箱 */
#define OM_DIDCHANGE_EMAIL @"OM_didchange_email"

/** 用户没有绑定邮箱通知 */
#define OM_NO_BINDING_MOBILE_PHONE @"OM_no_bing_mobile_phone"

@interface WTUserDefaults: NSObject

#pragma mark -
#pragma mark user defaults
+ (NSMutableDictionary *)getUserDefaults;
+ (void)removeUserDefaults;
+ (NSString *)getUsertype;
+ (BOOL)setUsertype:(NSString *)usertype;

+ (NSString *)getUid;
+ (BOOL)setUid:(NSString *)uid;
+ (NSString *)getWTID;
+ (BOOL)setWTID:(NSString *)yuanqutongid;
+ (NSString *)getPassword;      // useless
+ (BOOL)setPassword:(NSString *)password;   // useless. equal to hashedpassword.
+ (NSString *)getHashedPassword;
+ (BOOL)setHashedPassword:(NSString *)hashedPassword;
+ (NSString *)getNickname;
+ (BOOL)setTimeOffset:(long long)timeOffset;
+ (NSString *)getTimeOffset;
+ (BOOL)setStatus:(NSString *)status;
+ (NSString *)getStatus;
+ (BOOL)setNickname:(NSString *)nickname;
+ (BOOL)setBirthday:(NSString *)birthday;
+ (NSString *)getBirthday;
+ (BOOL)setGender:(NSString *)gender;
+ (NSInteger)getGender;
+ (BOOL)setArea:(NSString *)area;
+ (BOOL)setServerVersion:(NSString *)serverVersion;
+ (BOOL)setClientVersion:(NSString *)clientVersion;
+ (BOOL)setAutoAddBuddy:(BOOL)autoAddBuddy;
+ (BOOL)setAddable:(BOOL)addable;
+ (BOOL)setAllowStranderCall:(BOOL)allowStrangerCall;
+ (BOOL)setShowPushDetail:(BOOL)setShowPushDetail;
+ (BOOL)setDemoModeCode:(NSString *)demoModeCode;
+ (BOOL)setCountryCode:(NSString *)countryCode;
+ (BOOL)setUsername:(NSString *)username;
+ (BOOL)setDomain:(NSString *)domain;
+ (BOOL)setTokenPushed:(BOOL)tokenPushed;
+ (int)getApplyTime;
+ (BOOL)setApplyTime:(int)applyTime;
+ (NSString *)getUsername;
+ (NSString *)getCountryCode;
+ (NSString *)getDemoModeCode;
+ (NSString *)getDomain;
+ (NSString *)getActiveAppType;
+ (BOOL)setIdChanged:(NSString *)idchanged;
+ (BOOL)getIdChanged;
+ (BOOL)setPwdChanged:(NSString *)pwdchanged;
+ (BOOL)getPwdChanged;
+ (BOOL)setEmail:(NSString *)email;
+ (NSString *)getEmail;
+ (BOOL)setPhoneNumber:(NSString *)phonenumber;
+ (NSString *)getPhoneNumber;
+ (BOOL)getTokenPushed;


+ (NSString*)getDepartment;
+ (BOOL)setDepartment:(NSString*)department;

+ (NSString*)getPosition;
+ (BOOL)setPosition:(NSString*)position;

+(NSString*)getEmployeeID;
+(BOOL)setEmployeeID:(NSString*)employeeID;

+(NSString*)getLandline;
+(BOOL)setLandline:(NSString*)landline;

+(BOOL)setBranchoffice:(NSString*)branchoffice;
+(NSString*)getBranchOffice;

+(BOOL)setPhoneticName:(NSString*)phoneticname;
+(NSString*)getPhoneticName;

+(BOOL)setCompanyEmail:(NSString *)companymail;
+(NSString*)getCompanyEmail;

+(BOOL)setCompanyMobile:(NSString*)companymobile;
+(NSString*)getCompanyMobile;


+(NSString*)getClientVersion;

+(int) getAllowPeopleAddMe;
+(BOOL)setAllowPeopleAddMe:(int)allowPeopleAddMe;

+(BOOL)setListMeInNearbyResult:(BOOL)listme;
+(BOOL)getListMeInNearbyResult;

+(void)completeSetup;

+ (BOOL)setUploadPhotoTime:(NSString *)time;
+ (NSString *)getUploadPhotoTime;


+ (BOOL)isTeacher;

+ (BOOL)isStudent;

@end
