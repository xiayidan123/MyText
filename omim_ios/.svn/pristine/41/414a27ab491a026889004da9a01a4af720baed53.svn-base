//
//  Communicator_GetGroupMembers.m
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetGroupMembers.h"
#import "Database.h"
#import "GlobalSetting.h"
#import "GroupMember.h"

@interface Communicator_GetGroupMembers ()

@property (nonatomic, copy) NSString *strGroupID;

@end

@implementation Communicator_GetGroupMembers

@synthesize strGroupID = _strGroupID;

- (void)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues
   forGroupID:(NSString *)group_id
{
    self.strGroupID = group_id;
    [super fPost:postKeys withPostValue:postValues];
}

- (void)dealloc
{
    self.strGroupID = nil;
    
    [super dealloc];
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
        // not a fixed group, temperary group members.
        if ([Database getFixedGroupByID:self.strGroupID] == nil) {
            
            
            NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
            if (bodydict == nil || [bodydict objectForKey:XML_GET_GROUP_MEMBERS_KEY] == nil)
                errNo = NECCESSARY_DATA_NOT_RETURNED;
            else{
                NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_GROUP_MEMBERS_KEY];
                NSMutableArray *buddyArray = [[NSMutableArray alloc] init];
                if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *buddydict = [infodict objectForKey:XML_BUDDY];
                    Buddy* buddy = [[Buddy alloc] initWithUID:[buddydict objectForKey:XML_UID_KEY]
                                               andPhoneNumber:nil
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
                                                   andPhoneNumber:nil
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
                        
                        buddy.level = buddydict[@"level"];
                        
                        [buddyArray addObject:buddy];
                        [buddy release];
                    }
                }
                
                if (buddyArray.count > 0)
                {
                    [Database deleteAllBuddysInGroupChatRoomByID:self.strGroupID];
                    [Database addBuddys:buddyArray toGroupChatRoomByID:self.strGroupID];
                }
                
                [buddyArray release];
            }
        }
        // for fixed group.
        else{
            
            NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
            if (bodydict == nil || [bodydict objectForKey:XML_GET_GROUP_MEMBERS_KEY] == nil)
                errNo = NECCESSARY_DATA_NOT_RETURNED;
            else{
                NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_GROUP_MEMBERS_KEY];
                NSMutableArray *buddyArray = [[NSMutableArray alloc] init];
                if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *buddydict = [infodict objectForKey:XML_BUDDY];
                    GroupMember *buddy = [[GroupMember alloc]
                                          initWithUID:[buddydict objectForKey:XML_UID_KEY]
                                          andPhoneNumber:nil
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
                                          andLastLoginTimestamp:[buddydict objectForKey:XML_LAST_LONGITUDE_KEY]
                                          withAddFriendRule:[[buddydict objectForKey:@"people_can_add_me"] intValue]
                                          andAlias:@""];
                    
                    
                    // TODO: have to check on the block flag
                    NSString* level = [buddydict objectForKey:XML_USER_LEVEL];
                    if ([level isEqualToString:@"0"]) {
                        buddy.isCreator = TRUE;
                        buddy.isManager = FALSE;
                    }
                    else if ([level isEqualToString:@"1"]){
                        buddy.isCreator = FALSE;
                        buddy.isManager = TRUE;
                    }
                    else{
                        buddy.isCreator = FALSE;
                        buddy.isManager = FALSE;
                    }
                   
                    
                    [buddyArray addObject:buddy];
                    [buddy release];
                }
                else if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *arr = [infodict objectForKey:XML_BUDDY];
                    for (NSMutableDictionary *buddydict in arr)
                    {
                        GroupMember* buddy = [[GroupMember alloc] initWithUID:[buddydict objectForKey:XML_UID_KEY]
                                                               andPhoneNumber:nil
                                                                  andNickname:[buddydict objectForKey:XML_NICKNAME_KEY]
                                                                    andStatus:[buddydict objectForKey:XML_STATUS_KEY]
                                                              andDeviceNumber:[buddydict objectForKey:XML_DEVICE_NUMBER_KEY]
                                                                    andAppVer:[buddydict objectForKey:XML_APP_VERSION_KEY]
                                                                  andUserType:[buddydict objectForKey:XML_USER_TYPE_KEY]
                                                                 andBuddyFlag:[buddydict objectForKey:XML_BUDDY_FLAG_KEY]
                                                                 andIsBlocked: NO
                                                                       andSex:[buddydict objectForKey:XML_GENDER_KEY]
                                                      andPhotoUploadTimeStamp:[buddydict objectForKey:XML_UPLOAD_PHOTO_KEY]
                                                                 andWowTalkID:[buddydict objectForKey:XML_WOWTALK_ID_KEY]
                                                             andLastLongitude:[buddydict objectForKey:XML_LAST_LONGITUDE_KEY]
                                                              andLastLatitude:[buddydict objectForKey:XML_LAST_LATITUDE_KEY]
                                                        andLastLoginTimestamp:[buddydict objectForKey:XML_LAST_LOGIN_TIMESTAMP_KEY]
                                                            withAddFriendRule:[[buddydict objectForKey:@"people_can_add_me"] intValue]
                                                                     andAlias:@""];
                        
                        
                        // TODO: have to check on the block flag
                        NSString* level = [buddydict objectForKey:XML_USER_LEVEL];
                        if ([level isEqualToString:@"0"]) {
                            buddy.isCreator = TRUE;
                            buddy.isManager = FALSE;
                        }
                        else if ([level isEqualToString:@"1"]){
                            buddy.isCreator = FALSE;
                            buddy.isManager = TRUE;
                        }
                        else{
                            buddy.isCreator = FALSE;
                            buddy.isManager = FALSE;
                        }
                                                
                        [buddyArray addObject:buddy];
                        [buddy release];
                    }
                }
                
                if (buddyArray.count > 0)
                {
                    [Database deleteGroupMembers: self.strGroupID];
                    [Database storeMembers:buddyArray ToUserGroup:self.strGroupID];
                }
                
                [buddyArray release];
            }
        }
    }
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
