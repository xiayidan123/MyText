//
//  WTUserDefaults.m
//  omim
//
//  Created by Harry on 14-1-15.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "WTUserDefaults.h"
#import "WTConstant.h"
#import "Database.h"
#import "FMDatabase.h"
#import "GlobalSetting.h"

@implementation WTUserDefaults

+ (NSMutableDictionary *)getUserDefaults
{
    return nil;
}

+ (void)removeUserDefaults
{
    
    
}

+ (BOOL)isTeacher{
    NSString *user_type = [self getUsertype];
    
    if ([user_type isEqualToString:@"2"]){
        return YES;
    }
    return NO;
}


+ (BOOL)isStudent{
    NSString *user_type = [self getUsertype];
    
    if ([user_type isEqualToString:@"1"]){
        return YES;
    }
    return NO;
}



+ (NSString *)getUsertype
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `user_type` FROM `user_infos`"];
    
    NSString* type;
    BOOL isFound = FALSE;
    if (res && [res next])
    {
        
        type = [res stringForColumnIndex:0];
        isFound = TRUE;
        
    }
    
    [res close];
    
    if (!isFound) {
        type = @"1";
    }
    
    return type;
}

+ (BOOL)setUsertype:(NSString *)usertype
{
    
    return [Database runUpdate:@"UPDATE `user_infos` SET `user_type`=?", usertype];
}



+ (NSString *)getUid
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `uid` FROM `user_infos`"];
    
    NSString* uid;
    BOOL isFound = FALSE;
    if (res && [res next])
    {
       
        uid = [res stringForColumnIndex:0];
        isFound = TRUE;

    }
    
    [res close];
    
    if (!isFound) {
        uid = nil;
    }
    
    return uid;
}

+ (BOOL)setUid:(NSString *)uid
{
    
    return [Database runUpdate:@"UPDATE `user_infos` SET `uid`=?", uid];
}

+ (NSString *)getWTID
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `wowtalk_id` FROM `user_infos`"];
    
    NSString *yqd = nil;
    if (res && [res next])
    {
        yqd = [res stringForColumnIndex:0];
    }
    [res close];
    
    return yqd;
}

+ (BOOL)setWTID:(NSString *)yuanqutongid
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `wowtalk_id`=?", yuanqutongid];
}



+ (BOOL)setPassword:(NSString *)password
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `pwd`=?", password];
}

+ (NSString *)getHashedPassword
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `hashed_pwd` FROM `user_infos`"];
    
    NSString *pwd = nil;
    if (res && [res next])
    {
        pwd = [res stringForColumnIndex:0];
    }
    [res close];
    
    return pwd;
}

+ (BOOL)setHashedPassword:(NSString *)hashedPassword
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `hashed_pwd`=?", hashedPassword];
}

+ (NSString *)getNickname
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `nickname` FROM `user_infos`"];
    NSString *nick = nil;
    if (res && [res next])
        nick = [res stringForColumnIndex:0];
    [res close];
    
    return nick;
}

+ (NSString *)getTimeOffset
{
    return [NSString stringWithFormat:@"%lld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"time_offset"] longLongValue]];
}
+ (BOOL)setTimeOffset:(long long)timeOffset;
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:timeOffset] forKey:@"time_offset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //  NSLog(@"not implement ed time offset");
    return true;
}


+ (BOOL)setStatus:(NSString *)status
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `status`=?", status];
}

+ (NSString *)getStatus
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `status` FROM `user_infos`"];
    NSString *status = nil;
    if (res && [res next])
        status = [res stringForColumnIndex:0];
    [res close];
    
    return status;
}

+ (BOOL)setNickname:(NSString *)nickname
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `nickname`=?", nickname];
}

+ (BOOL)setBirthday:(NSString *)birthday
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `birthday`=?", birthday];
}

+ (NSString *)getBirthday
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `birthday` FROM `user_infos`"];
    NSString *bday = nil;
    if (res && [res next])
        bday = [res stringForColumnIndex:0];
    [res close];
    
    return bday;
}

+ (BOOL)setGender:(NSString *)gender
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `gender`=?", gender];
}

+ (NSInteger)getGender
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `gender` FROM `user_infos`"];
    int gender = 2;
    if (res && [res next])
        gender = [res intForColumnIndex:0];
    [res close];
    
    return gender;
}

+ (BOOL)setArea:(NSString *)area
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `area`=?", area];
}

+ (BOOL)setServerVersion:(NSString *)serverVersion
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `server_version`=?", serverVersion];
}

+ (BOOL)setClientVersion:(NSString *)clientVersion
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `client_version`=?", clientVersion];
}

+(NSString*)getClientVersion
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `client_version` FROM `user_infos`"];
    NSString* clientVer = nil;
    if (res && [res next])
        clientVer = [res stringForColumnIndex:0];
    [res close];
    
    if (clientVer == nil || [clientVer isEqualToString:@""]) {
        clientVer = @"-1";
    }
    
    return clientVer;
}


//TODO: below has to be done in the future.
+ (BOOL)setAutoAddBuddy:(BOOL)autoAddBuddy
{
    return FALSE;
}

+ (BOOL)setAddable:(BOOL)addable
{
    return FALSE;
}

+ (BOOL)setAllowStranderCall:(BOOL)allowStrangerCall
{
    return FALSE;
}

+ (BOOL)setShowPushDetail:(BOOL)setShowPushDetail
{
    return FALSE;
}

+ (BOOL)setDemoModeCode:(NSString *)demoModeCode
{
    return FALSE;
}

+ (BOOL)setCountryCode:(NSString *)countryCode
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `country_code`=?", countryCode];
}

+ (BOOL)setUsername:(NSString *)username
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `username`=?", username];
}

+ (BOOL)setDomain:(NSString *)domain
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `domain`=?", domain];
}

+ (int)getApplyTime
{
    return 0;
}

+ (BOOL)setApplyTime:(int)applyTime
{
    return FALSE;
}

+ (NSString *)getUsername
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `username` FROM `user_infos`"];
    NSString *username = nil;
    if (res && [res next])
        username = [res stringForColumnIndex:0];
    [res close];
    
    return username;
}

+ (NSString *)getCountryCode
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `country_code` FROM `user_infos`"];
    NSString *ccode = nil;
    if (res && [res next])
        ccode = [res stringForColumnIndex:0];
    [res close];
    
    return ccode;
}

+ (NSString *)getDemoModeCode
{
    return nil;
}

+ (NSString *)getDomain
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `domain` FROM `user_infos`"];
    NSString *domain = nil;
    if (res && [res next])
        domain = [res stringForColumnIndex:0];
    [res close];
    
    return domain;
}

+ (NSString *)getActiveAppType
{
    return nil;
}

+ (BOOL)setIdChanged:(NSString *)idchanged
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `id_changed`=?", idchanged];
}

+ (BOOL)getIdChanged
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `id_changed` FROM `user_infos`"];
    BOOL idchanged = YES;
    if (res && [res next])
        idchanged = [res boolForColumnIndex:0];
    [res close];
    
    return idchanged;
}

+ (BOOL)setPwdChanged:(NSString *)pwdchanged
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `pwd_changed`=?", pwdchanged];
}

+ (BOOL)getPwdChanged
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `pwd_changed` FROM `user_infos`"];
    BOOL changed = YES;
    if (res && [res next])
        changed = [res boolForColumnIndex:0];
    [res close];
    
    return changed;
}

+ (BOOL)setTokenPushed:(BOOL)tokenPushed
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `token_pushed`=?", tokenPushed? @"0" : @"1"];
}

+ (BOOL)getTokenPushed
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `token_pushed` FROM `user_infos`"];
    BOOL pushed = YES;
    if (res && [res next])
        pushed = [res boolForColumnIndex:0];
    [res close];
    
    return pushed;
}


+ (NSString*)getDepartment
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `department` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}
+ (BOOL)setDepartment:(NSString*)department
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `department`=?", department];
}

+ (NSString*)getPosition{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `position` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}
+ (BOOL)setPosition:(NSString*)position{
    return [Database runUpdate:@"UPDATE `user_infos` SET `position`=?", position];
}

+(NSString*)getEmployeeID{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `employeeid` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}
+(BOOL)setEmployeeID:(NSString*)employeeID{
    return [Database runUpdate:@"UPDATE `user_infos` SET `employeeid`=?", employeeID];
}

+(NSString*)getLandline{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `landline` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}
+(BOOL)setLandline:(NSString*)landline{
    return [Database runUpdate:@"UPDATE `user_infos` SET `landline`=?", landline];
}

+(BOOL)setBranchoffice:(NSString*)branchoffice{
      return [Database runUpdate:@"UPDATE `user_infos` SET `branchoffice`=?", branchoffice];
}

+(NSString*)getBranchOffice{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `branchoffice` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}

+(BOOL)setPhoneticName:(NSString*)phoneticname{
     return [Database runUpdate:@"UPDATE `user_infos` SET `phonetic_name`=?", phoneticname];
}
+(NSString*)getPhoneticName{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `phonetic_name` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}

+(BOOL)setCompanyEmail:(NSString *)companymail{
      return [Database runUpdate:@"UPDATE `user_infos` SET `company_email`=?", companymail];
}
+(NSString*)getCompanyEmail{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `company_email` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}

+(BOOL)setCompanyMobile:(NSString*)companymobile{
     return [Database runUpdate:@"UPDATE `user_infos` SET `company_mobile`=?", companymobile];
}

+(NSString*)getCompanyMobile{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `company_mobile` FROM `user_infos`"];
    if (res && [res next])
        return [res stringForColumnIndex:0];
    [res close];
    
    return @"";
}


+ (BOOL)setEmail:(NSString *)email
{
    [OMNotificationCenter postNotificationName:OM_DIDCHANGE_EMAIL object:nil userInfo:nil];
    return [Database runUpdate:@"UPDATE `user_infos` SET `email`=?", email];
}

+ (NSString *)getEmail
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `email` FROM `user_infos`"];
    NSString *email = nil;
    if (res && [res next])
        email = [res stringForColumnIndex:0];
    [res close];
    
    return email;
}

+ (BOOL)setPhoneNumber:(NSString *)phonenumber
{
    
    BOOL success = [Database runUpdate:@"UPDATE `user_infos` SET `phone_number`=?", phonenumber];
    [OMNotificationCenter postNotificationName:OM_DIDCHANGE_TELEPHONENUMBER object:nil userInfo:nil];// 发出
    return success;
}

+ (NSString *)getPhoneNumber
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `phone_number` FROM `user_infos`"];
    NSString *phone = nil;
    if (res && [res next])
        phone = [res stringForColumnIndex:0];
    [res close];
    
    return phone;
}

+(int) getAllowPeopleAddMe
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `allow_people_add_me` FROM `user_infos`"];
    int setting = -1;
    
    if (res && [res next])
        setting = [[res stringForColumnIndex:0] intValue];
    [res close];
    
    return setting;
    
}

+(BOOL)setAllowPeopleAddMe:(int)allowPeopleAddMe
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `allow_people_add_me`=?", [NSString stringWithFormat:@"%d",allowPeopleAddMe]];

}

+(BOOL)setListMeInNearbyResult:(BOOL)listme
{
    return [Database runUpdate:@"UPDATE `user_infos` SET `list_me_nearby`=?", [NSString stringWithFormat:@"%d",listme]];
    
}
+(BOOL)getListMeInNearbyResult
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `list_me_nearby` FROM `user_infos`"];
    BOOL list = TRUE;
    
    if (res && [res next])
        list = [[res stringForColumnIndex:0] boolValue];
    [res close];
    
    return list;
    
}

+ (BOOL)setUploadPhotoTime:(NSString *)time
{
    return [Database runUpdate:@"UPDATE `buddydetail` SET `photo_upload_timestamp`=?", time];
}

+ (NSString *)getUploadPhotoTime
{
    FMResultSet *res = [Database runQueryForResult:@"SELECT `photo_upload_timestamp` FROM `buddydetail` WHERE `uid`=?", [self getUid]];
    NSString *result = @"";
    
    if (res && [res next]) {
        result = [res stringForColumnIndex:0];
    }
    [res close];
    return result;
}

@end
