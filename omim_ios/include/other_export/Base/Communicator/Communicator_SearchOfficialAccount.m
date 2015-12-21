//
//  Communicator_SearchOfficialAccount.m
//  dev01
//
//  Created by jianxd on 14-5-26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_SearchOfficialAccount.h"

@implementation Communicator_SearchOfficialAccount
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableArray *fuzzyResults = nil;
        if (_fuzzySearch) {
            fuzzyResults = [[[NSMutableArray alloc] init] autorelease];
        }
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:@"search_official_account"];
        if (infodict == nil) {
            errNo = NO_SEARCH_RESULT;
            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
            return;
        }
        
        if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableArray class]]) {
            //TODO: error now. we use the first result as the returning result
            if (_fuzzySearch) {
                for (NSDictionary *buddydict in [infodict objectForKey:XML_BUDDY]) {
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
                                                     andAlias:nil];
                    
                    buddy.addFriendRule =[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME]? [[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME] integerValue] :1;
                    
                    
                    [fuzzyResults addObject:buddy];
                    [buddy release];
                }
                [self networkTaskDidFinishWithReturningData:fuzzyResults error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

            } else {
                NSMutableArray* array = [infodict objectForKey:XML_BUDDY];
                NSDictionary* buddydict = [array objectAtIndex:0];
                
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
                                                 andAlias:nil];
                
                buddy.addFriendRule =[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME]? [[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME] integerValue] :1;
                
               
                
                if (buddy) {
                    [Database storeBuddys:[NSArray arrayWithObject:buddy]];
                }
                
                [self networkTaskDidFinishWithReturningData:buddy error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
                [buddy release];
            }
            
        }
        // dictionary
        else
        {
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
                                             andAlias:[buddydict objectForKey:@"alias"]];
            
            buddy.addFriendRule =[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME]? [[buddydict objectForKey:XML_PEOPLE_CAN_ADD_ME] integerValue] :1;
            
           
            
            if (buddy) {
                if (_fuzzySearch) {
                    [fuzzyResults addObject:buddy];
                } else {
                    [Database storeBuddys:[NSArray arrayWithObject:buddy]];
                }
            }
            
            [buddy release];
            
            
            
            [self networkTaskDidFinishWithReturningData:buddy error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
        if (_fuzzySearch) {
            if ([_searchDelegate respondsToSelector:@selector(didFinishSearchWithResult:)]) {
                [_searchDelegate performSelector:@selector(didFinishSearchWithResult:) withObject:fuzzyResults];
            }
        }
    }
    else {
        [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    }
}

@end
