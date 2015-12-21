//
//  Communicator_ScanPhoneNumberForBuddy.m
//  omimLibrary
//
//  Created by Yi Chen on 9/6/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_ScanPhoneNumberForBuddy.h"
#import "Buddy.h"
#import "Database.h"
#import "GlobalSetting.h"

@implementation Communicator_ScanPhoneNumberForBuddy

@synthesize chatMessage;

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodyDict = [result objectForKey:XML_BODY_NAME];
        if (bodyDict == nil || [bodyDict objectForKey:XML_SCAN_PHONES_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else{
            NSMutableDictionary *infodict = [bodyDict objectForKey:XML_SCAN_PHONES_KEY];
            NSMutableArray *buddyArray = [[NSMutableArray alloc] init];
            if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *dict = [infodict objectForKey:XML_BUDDY];
                Buddy *buddy = [[Buddy alloc] initWithUID:[dict objectForKey:XML_UID_KEY]
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
                                 withAddFriendRule:[[dict objectForKey:@"people_can_add_me"] intValue]
                                                 andAlias:@""];
                
               
                
                [buddyArray addObject:buddy];
                [buddy release];
            }
            else if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableArray class]])
            {
                NSMutableArray *arr = [infodict objectForKey:XML_BUDDY];
                for (int i = 0; i < arr.count; i++)
                {
                    NSMutableDictionary *dict = [arr objectAtIndex:i];
                    
                    Buddy *buddy = [[Buddy alloc] initWithUID:[dict objectForKey:XML_UID_KEY]
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
                                            withAddFriendRule:[[dict objectForKey:@"people_can_add_me"] intValue]
                                                     andAlias:@""];
                    
                                      
                    [buddyArray addObject:buddy];
                    [buddy release];
                }
            }
            
            if (buddyArray.count > 0)
                [Database storeBuddys:buddyArray];
            
            [buddyArray release];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
