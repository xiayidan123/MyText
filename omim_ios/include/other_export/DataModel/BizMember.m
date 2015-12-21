//
//  BizMember.m
//  dev01
//
//  Created by elvis on 2013/08/27.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "BizMember.h"
#import "WowtalkXMLParser.h"

@implementation BizMember


-(id)initWithDict:(NSMutableDictionary*)dict{
    if (dict==nil) {
        return nil;
    }

    self = [super init];
    if (self) {
        self = [self initWithUID:[dict objectForKey:XML_UID_KEY]
                  andPhoneNumber:[dict objectForKey:XML_PHONE_NUMBER_KEY]
                     andNickname:[dict objectForKey:XML_NICKNAME_KEY]
                       andStatus:[dict objectForKey:XML_STATUS_KEY]
                 andDeviceNumber:[dict objectForKey:XML_DEVICE_NUMBER_KEY]
                       andAppVer:[dict objectForKey:XML_APP_VERSION_KEY]
                     andUserType:[dict objectForKey:XML_USER_TYPE_KEY]
                    andBuddyFlag:[dict objectForKey:XML_BUDDY_FLAG_KEY]
                    andIsBlocked:NO
                          andSex:[dict objectForKey:XML_GENDER_KEY]
         andPhotoUploadTimeStamp:[dict objectForKey:XML_UPLOAD_PHOTO_KEY]
                    andWowTalkID:[dict objectForKey:XML_WOWTALK_ID_KEY]
                andLastLongitude:[dict objectForKey:XML_LAST_LONGITUDE_KEY]
                 andLastLatitude:[dict objectForKey:XML_LAST_LATITUDE_KEY]
           andLastLoginTimestamp:[dict objectForKey:XML_LAST_LOGIN_TIMESTAMP_KEY]
               withAddFriendRule:[dict objectForKey:@"people_can_add_me"]?[[dict objectForKey:@"people_can_add_me"] intValue]:1
                  withDepartment:[dict objectForKey:XML_DEPARTMENT]
                    withPosition:[dict objectForKey:XML_POSITION]
                    withDistrict:[dict objectForKey:XML_DISTRICT]
                  withEmployeeID:[dict objectForKey:XML_EMPLOYEEID]
                    withLandline:[dict objectForKey:XML_LANDLINE]
                      withMobile:[dict objectForKey:XML_PHONE_NUMBER_KEY]
                       withEmail:[dict objectForKey:XML_EMAIL]
           withPhoneticFirstName:[dict objectForKey:XML_PHONETIC_FIRST_NAME]
          withPhoneticMiddleName:[dict objectForKey:XML_PHONETIC_MIDDLE_NAME]
           withPhonecticLastName:[dict objectForKey:XML_PHONETIC_LAST_NAME]
                withPhoneticName:[dict objectForKey:XML_PHONETIC_NAME]];
        
        
    }
    return self;
}

-(id)initWithUID:(NSString*)strUID andPhoneNumber:(NSString*)strPhoneNumber andNickname:(NSString*)strNick
         andStatus:(NSString*)strStatus andDeviceNumber:(NSString*)strDeviceNum andAppVer:(NSString*)strAppVer andUserType:(NSString*)strUserType
      andBuddyFlag:(NSString*)budyflag andIsBlocked:(BOOL)blockFlag andSex:(NSString*)strSex andPhotoUploadTimeStamp:(NSString*)strTimestamp
    andWowTalkID:(NSString*)strWowTalkID andLastLongitude:(NSString*)strLastLongitude andLastLatitude:(NSString*)strLastLatitude andLastLoginTimestamp:(NSString*)strLastLoginTimestamp withAddFriendRule:(int)rule withDepartment:(NSString*)department withPosition:(NSString*)position withDistrict:(NSString*)district withEmployeeID:(NSString*)employeeid withLandline:(NSString*)landline withMobile:(NSString*)mobile withEmail:(NSString*)email withPhoneticFirstName:(NSString*)p_firstname withPhoneticMiddleName:(NSString*)p_middlename withPhonecticLastName:(NSString*)p_lastname withPhoneticName:(NSString *)p_name{
    
    
    self = [super init];
	if (self == nil)
		return nil;
    
    self.userID=(strUID!=nil)?strUID:@"";
    self.phoneNumber=(strPhoneNumber!=nil)?strPhoneNumber:@"";
    
	self.nickName=(strNick!=nil)?strNick:@"";
	self.status=(strStatus!=nil)?strStatus:@"";
	self.deviceNumber=(strDeviceNum!=nil)?strDeviceNum:@"";
	self.appVer=(strAppVer!=nil)?strAppVer:@"";
    self.userType = (strUserType!=nil)?[strUserType intValue]:1;
    
    self.buddy_flag = budyflag !=nil? budyflag:@"";
    
    self.addFriendRule = rule;
    
    if ([budyflag isEqualToString:@"1"]) {
        self.isFriend = TRUE;
    }
    else
        self.isFriend = FALSE;
    
    self.isBlocked = blockFlag;
    self.sexFlag = (strSex!=nil)?[strSex intValue]:-1;
    
    self.photoUploadedTimeStamp = (strTimestamp!=nil)?[strTimestamp intValue]:-1;
    
    self.insertTimeStamp=-1;  // to be set after reading db
	self.pathOfPhoto =@"";  // to be set after reading db
    self.pathOfThumbNail=@""; // to be set after reading db
    self.needToDownloadPhoto = (self.photoUploadedTimeStamp!=-1);  // to be set after comparing photoUploadedTimeStamp
    self.needToDownloadThumbnail = (self.photoUploadedTimeStamp!=-1);// to be set after comparing photoUploadedTimeStamp
    self.mayNotExist = FALSE;
    
    
    self.wowtalkID = strWowTalkID;
    self.lastLongitude = (strLastLongitude!=nil)?[strLastLongitude floatValue]:-1;
    self.lastLatitude = (strLastLatitude!=nil)?[strLastLatitude floatValue]:-1;
    self.lastLoginTimestamp = (strLastLoginTimestamp!=nil)?[strLastLoginTimestamp intValue]:-1;
    
    
    self.department = department;
    self.position = position;
    self.district = district;
    self.employeeID = employeeid;
    self.landline = landline;
    self.mobile = mobile;
    self.email = email;
    self.phonetic_firstname = p_firstname;
    self.phonetic_middle = p_middlename;
    self.phonetic_lastname  = p_lastname;
    
    self.phonetic_name = p_name;
    
    return self;
}


-(void)dealloc
{
    self.department = nil;
    self.position = nil;
    self.district = nil;
    self.employeeID = nil;
    self.landline = nil;
    self.mobile = nil;
    self.email = nil;
    
    self.phonetic_firstname = nil;
    self.phonetic_lastname = nil;
    self.phonetic_middle = nil;
    
    self.phonetic_name = nil;
    
    [super dealloc];
}

@end
