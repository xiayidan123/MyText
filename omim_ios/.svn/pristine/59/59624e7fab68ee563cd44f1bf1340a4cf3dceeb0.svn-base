//
//  Communicator_GetMyProfile.m
//  omimLibrary
//
//  Created by Yi Chen on 4/24/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetMyProfile.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_GetMyProfile

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
    NSMutableDictionary *profiledict = [bodydict objectForKey:XML_GET_PROFILE_KEY];
    if (profiledict == nil)
        errNo = NECCESSARY_DATA_NOT_RETURNED;
    
    else{
        

        
        if ([profiledict objectForKey:XML_STATUS_KEY])
            [WTUserDefaults setStatus:[profiledict objectForKey:XML_STATUS_KEY]];
                
        if ([profiledict objectForKey:XML_NICKNAME_KEY])
            [WTUserDefaults setNickname:[profiledict objectForKey:XML_NICKNAME_KEY]];
        
        if ([profiledict objectForKey:XML_BIRTHDAY_KEY])
            [WTUserDefaults setBirthday:[profiledict objectForKey:XML_BIRTHDAY_KEY]];
        
        if ([profiledict objectForKey:XML_GENDER_KEY])
            [WTUserDefaults setGender:[profiledict objectForKey:XML_GENDER_KEY]];
        
        if ([profiledict objectForKey:XML_AREA_KEY])
            [WTUserDefaults setArea:[profiledict objectForKey:XML_AREA_KEY]];
        
        if ([profiledict objectForKey:XML_USER_TYPE_KEY])
            [WTUserDefaults setUsertype:[profiledict objectForKey:XML_USER_TYPE_KEY]];

        
        
    
        Buddy* me = [[Buddy alloc] initWithUID:[WTUserDefaults getUid] andPhoneNumber:[WTUserDefaults getPhoneNumber] andNickname:[profiledict objectForKey:XML_NICKNAME_KEY] andStatus:[profiledict objectForKey:XML_STATUS_KEY] andDeviceNumber:nil andAppVer:nil andUserType:[profiledict objectForKey:XML_USER_TYPE_KEY] andBuddyFlag:nil andIsBlocked:FALSE andSex:[profiledict objectForKey:XML_GENDER_KEY] andPhotoUploadTimeStamp:[profiledict objectForKey:XML_UPLOAD_PHOTO_KEY] andWowTalkID:nil andLastLongitude:nil andLastLatitude:nil andLastLoginTimestamp:nil  withAddFriendRule:0 andAlias:@""];
        [Database storeNewBuddyDetailWithUpdate:me];
        
        [me release];
        
    
    }
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
