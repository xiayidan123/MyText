//
//  Communicator_JoinOrLeaveOrAddGroup.m
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_JoinOrLeaveOrAddGroup.h"
#import "Database.h"
#import "GlobalSetting.h"
#import "UserGroup.h"

@interface Communicator_JoinOrLeaveOrAddGroup ()

@property (nonatomic, copy) NSString *strGroupID;

@end

@implementation Communicator_JoinOrLeaveOrAddGroup

@synthesize strGroupID = _strGroupID;
@synthesize addGroupToDB;
@synthesize mode;
@synthesize isCreater = _isCreater;
@synthesize isManager = _isManager;

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues
  forGroupID:(NSString*)group_id
addGroupToDB:(BOOL)flag{
	self.addGroupToDB = flag;
    isTemporaryGroup = NO;
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
        NSString* key = @"";
        if (self.mode == 0) { // add memeber
            key =  @"add_group_member";
        }
        else if (self.mode == 1) {      // leave room.
            key = @"leave_group_chat_room";
        }
        else if (self.mode == 2){
            key = @"get_group_info";
        }
        
        if (addGroupToDB)
        {
            NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
            if (bodydict == nil || [bodydict objectForKey:key] == nil)
                errNo = NECCESSARY_DATA_NOT_RETURNED;
            else{
                NSMutableDictionary *infodict = [bodydict objectForKey:key];
                
                if ([infodict objectForKey:XML_GROUP_NAME_KEY] == nil || [infodict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY] == nil || [infodict objectForKey:XML_GROUP_MEMBER_COUNT_KEY] == nil)
              
                    errNo = NECCESSARY_DATA_NOT_RETURNED;
                
                else{
                    
                    BOOL isTemp = [[infodict objectForKey:XML_GROUP_FLAG_KEY] boolValue];
                    if (isTemp) {
                        GroupChatRoom* room = [[GroupChatRoom alloc] initWithID:self.strGroupID withGroupNameOriginal:[infodict objectForKey:XML_GROUP_NAME_KEY]
                                                             withGroupNameLocal:[infodict objectForKey:XML_GROUP_NAME_KEY]
                                                                withGroupStatus:[infodict objectForKey:XML_GROUP_STATUS_KEY]
                                                                  withMaxNumber:[infodict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY]
                                                                withMemberCount:[infodict objectForKey:XML_GROUP_MEMBER_COUNT_KEY]
                                                               isTemporaryGroup:[(NSString*)[infodict objectForKey:XML_GROUP_FLAG_KEY] boolValue]];
                        
                        [GroupChatRoom storeTempGroupInDatebase:room];
                       
                        [Database addBuddys:self.addedMembers toGroupChatRoomByID:room.groupID];
                        
                        [room release];
                        
                    }
                    else{
                        UserGroup* room = [[UserGroup alloc] initWithID:self.strGroupID withGroupNameOriginal:[infodict objectForKey:XML_GROUP_NAME_KEY] withGroupNameLocal:[infodict objectForKey:XML_GROUP_NAME_KEY] withGroupStatus:[infodict objectForKey:XML_GROUP_STATUS_KEY]                                              withMaxNumber:[infodict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY]                                                            withMemberCount:[infodict objectForKey:XML_GROUP_MEMBER_COUNT_KEY]
                                                            withLaitude:[[infodict objectForKey:XML_GROUP_LATITUDE] doubleValue]  withLongitude:[[infodict objectForKey:XML_GROUP_LONGITUDE] doubleValue]  withPlace:[infodict objectForKey:XML_GROUP_PLACE] withType:[infodict objectForKey:XML_GROUP_TYPE] withShortid:[infodict objectForKey:XML_GROUP_SHORT_ID] withIntroduction:[infodict objectForKey:XML_GROUP_STATUS_KEY]];
                        
                        
                        room.thumbnail_timestamp = [infodict objectForKey:XML_GROUP_TIMESTAMP];
                        
                        [UserGroup storeGroupInDatabase:room];

                        [Database addMembers:self.addedMembers ToUserGroup:self.strGroupID];
                        
                        [room release];
                        
                        //TODO: we may need to get the member info here.
                    }
                }
            }
        }
        else
        {
            [Database deleteGroupChatRoomWithID:self.strGroupID];
            [Database deleteAllBuddysInGroupChatRoomByID:self.strGroupID];
        }
        
    }
    //  else
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
