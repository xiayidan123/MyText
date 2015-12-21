//
//  Communicator_GetUserByID.m
//  omim
//
//  Created by Harry on 14-2-4.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetUserByID.h"
#import "Buddy.h"
#import "Database.h"

@implementation Communicator_GetUserByID

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil){
            errNo = NECCESSARY_DATA_NOT_RETURNED;
             [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
        else
        {
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_USER_BY_ID_KEY];
            NSMutableDictionary *buddydict = [infodict objectForKey:XML_BUDDY];
            Buddy *buddy = [[Buddy alloc] initWithUID:[buddydict objectForKey:XML_UID_KEY]
                                       andPhoneNumber:[buddydict objectForKey:XML_PHONE_NUMBER_KEY]
                                          andNickname:[buddydict objectForKey:XML_NICKNAME_KEY]
                                            andStatus:[buddydict objectForKey:XML_STATUS_KEY]
                                      andDeviceNumber:[buddydict objectForKey:XML_DEVICE_NUMBER_KEY]
                                            andAppVer:[buddydict objectForKey:XML_APP_VERSION_KEY]
                                          andUserType:[buddydict objectForKey:XML_USER_TYPE_KEY]
                                          andBuddyFlag:[buddydict objectForKey:XML_BUDDY_FLAG_KEY]
                                         andIsBlocked:NO
                                               andSex:[buddydict objectForKey:XML_GENDER_KEY]
                              andPhotoUploadTimeStamp:[buddydict objectForKey:XML_UPLOAD_PHOTO_KEY]
                                         andWowTalkID:[buddydict objectForKey:XML_WOWTALK_ID_KEY]
                                     andLastLongitude:[buddydict objectForKey:XML_LAST_LONGITUDE_KEY]
                                      andLastLatitude:[buddydict objectForKey:XML_LAST_LATITUDE_KEY]
                                 andLastLoginTimestamp:[buddydict objectForKey:XML_LAST_LOGIN_TIMESTAMP_KEY]
                                     withAddFriendRule:[[buddydict objectForKey:@"people_can_add_me"] intValue]
                                             andAlias:@""];

            buddy.addFriendRule =[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME]? [[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME] integerValue] :1;
            
                       
            if (buddy)
                [Database storeBuddys:[NSArray arrayWithObject:buddy]];
                            
            [buddy release];
            
            [self networkTaskDidFinishWithReturningData:buddy error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
    }
    else
        [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
