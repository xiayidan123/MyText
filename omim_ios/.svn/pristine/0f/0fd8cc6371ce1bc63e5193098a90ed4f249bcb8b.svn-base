//
//  Communicator_GetNearbyBuddys.m
//  omim
//
//  Created by elvis on 2013/05/27.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetNearbyBuddys.h"

@implementation Communicator_GetNearbyBuddys

-(void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    if (errNo == NO_ERROR) {
        NSDictionary* info = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_NEARBY_BUDDYS];
        
        if ([[info objectForKey:WT_BUDDY] isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary* dict = [info objectForKey:WT_BUDDY];
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
           
        
            
            Buddy* oldbuddy = [Database buddyWithUserID:buddy.userID];
            if (oldbuddy) {
                buddy.buddy_flag = oldbuddy.buddy_flag;
                buddy.isFriend = oldbuddy.isFriend;
            }
            
            else{
                buddy.buddy_flag = @"0";
                buddy.isFriend = FALSE;
            }
            
            [Database deleteAllNearbyBuddys];
            if (![buddy.userID isEqualToString:[WTUserDefaults getUid]]) {
                [Database storeNearbyBuddy:buddy];
            }
            
            [buddy release];
        
        }
        else if ([[info objectForKey:WT_BUDDY] isKindOfClass:[NSMutableArray class]]){
            NSMutableArray* buddys = [[NSMutableArray alloc] init];
            for (NSDictionary* dict  in [info objectForKey:WT_BUDDY]) {
                
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
                
                Buddy* oldbuddy = [Database buddyWithUserID:buddy.userID];
                if (oldbuddy) {
                    // the below situation is possible, since the above function "buddyWithUserID" will check the ID exsitence in buddy table. however, the previous nearby buddy don't store in the buddy table. if we store a nearby buddy we have stored before, have to be careful of this flag.
                    // so the
                    if (oldbuddy.buddy_flag == NULL) {
                        oldbuddy.buddy_flag = @"0";
                    }
                    buddy.buddy_flag = oldbuddy.buddy_flag;
                    buddy.isFriend = oldbuddy.isFriend;
                }
                
                else{
                    buddy.buddy_flag = @"0";
                    buddy.isFriend = FALSE;
                }
                if (![buddy.userID isEqualToString:[WTUserDefaults getUid]]){
                    [buddys addObject:buddy]; 
                }
                
                [buddy release];
            }
            
            [Database deleteAllNearbyBuddys];
            if ([buddys count] > 0) {
                [Database storeNearbyBuddys:buddys];
            }
            [buddys release];
        }
        
    }
    
  [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}


@end
