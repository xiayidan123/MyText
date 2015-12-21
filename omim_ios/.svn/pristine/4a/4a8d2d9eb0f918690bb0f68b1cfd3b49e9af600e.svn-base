//
//  Communicator_UpdateMyProfile.m
//  omimLibrary
//
//  Created by Yi Chen on 5/3/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_UpdateMyProfile.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_UpdateMyProfile

@synthesize strStatus;
@synthesize strNickname;
@synthesize strBirthday;
@synthesize strSex;
@synthesize strArea;

@synthesize mobile;
@synthesize email;
@synthesize pronunciation;
@synthesize interphone;

-(void) fSetNickName:(NSString*)_strNickname 
           withStatus:(NSString*)_strStatus
         withBirthday:(NSString*)_strBirthday
              withSex:(NSString*)_sexFlag
             withArea:(NSString*)_strArea{
    self.strStatus = _strStatus;
    self.strNickname = _strNickname;
    self.strBirthday = _strBirthday;
    self.strArea = _strArea;
    self.strSex = _sexFlag;
}


-(void) fSetNickName:(NSString*)_strNickname
          withStatus:(NSString*)_strStatus
        withBirthday:(NSString*)_strBirthday
             withSex:(NSString*)_sexFlag
            withArea:(NSString*)_strArea
          withMobile:(NSString*)strmobile
           withEmail:(NSString*)stremail
   withPronunciation:(NSString*)strpronunciation
      withInterphone:(NSString*)strinterphone{
    
    self.strStatus = _strStatus;
    self.strNickname = _strNickname;
    self.strBirthday = _strBirthday;
    self.strArea = _strArea;
    self.strSex = _sexFlag;
    self.mobile = strmobile;
    self.email = stremail;
    self.pronunciation = strpronunciation;
    self.interphone = strinterphone;
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];

    if (errNo == NO_ERROR)
    {
        if (strStatus)
            [WTUserDefaults setStatus:strStatus];
        if (strNickname)
            [WTUserDefaults setNickname:strNickname];
        if (strBirthday)
            [WTUserDefaults setBirthday:strBirthday];
        if (strSex)
            [WTUserDefaults setGender:strSex];
        
        if (strArea)
            [WTUserDefaults setBranchoffice:strArea];
        
        if (self.mobile) {
            [WTUserDefaults setCompanyMobile:self.mobile];
        }
        
        if (self.email) {
            [WTUserDefaults setCompanyEmail:self.email];
        }
        
        if (self.pronunciation) {
            [WTUserDefaults setPhoneticName:self.pronunciation];
        }
        
        if (self.interphone) {
            [WTUserDefaults setLandline:self.interphone];
        }
        
        //Notice: may have problem here. do we have to update other info of mine in buddy table.
        
        Buddy* me = [[Buddy alloc] initWithUID:[WTUserDefaults getUid] andPhoneNumber:[WTUserDefaults getPhoneNumber] andNickname:self.strNickname andStatus:self.strStatus  andDeviceNumber:nil andAppVer:nil andUserType:nil andBuddyFlag:nil andIsBlocked:FALSE andSex:self.strSex andPhotoUploadTimeStamp:nil andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil withAddFriendRule:0 andAlias:@""];
        
        [Database storeNewBuddyDetailWithUpdate:me];
        
        [me release];
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

- (void)dealloc
{
    self.strStatus = nil;
    self.strNickname = nil;
    self.strBirthday = nil;
    self.strSex = nil;
    self.strArea = nil;
    
    [super dealloc];
}

@end