//
//  Communicator_UploadContactBook.m
//  omim
//
//  Created by coca on 2013/04/22.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_UploadContactBook.h"


@implementation Communicator_UploadContactBook

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
        if (bodydict == nil || [bodydict objectForKey:XML_GET_MATCHED_BUDDY_LIST_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else{
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_MATCHED_BUDDY_LIST_KEY];
            NSMutableArray *buddyArray = [[NSMutableArray alloc] init];
            if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *buddydict = [infodict objectForKey:XML_BUDDY];
                Buddy* buddy = [[Buddy alloc] initWithUID:[buddydict objectForKey:XML_UID_KEY]
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
                
               
                
                [buddyArray addObject:buddy];
                [buddy release];
                
            }
            else if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableArray class]])
            {
                NSMutableArray *arr = [infodict objectForKey:XML_BUDDY];
                for (NSMutableDictionary *buddydict in arr)
                {
                    Buddy* buddy = [[Buddy alloc] initWithUID:[buddydict objectForKey:XML_UID_KEY]
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
                    
                                     
                    [buddyArray addObject:buddy];
                    [buddy release];
                }
            }
            
            if (buddyArray.count > 0)
            {
                [Database storeBuddys:buddyArray];
            }
            
            [buddyArray release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
