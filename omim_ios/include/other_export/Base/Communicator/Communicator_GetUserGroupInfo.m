//
//  Communicator_GetUserGroupInfo.m
//  omim
//
//  Created by coca on 2013/04/28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetUserGroupInfo.h"
#import "Database.h"
#import "UserGroup.h"

@implementation Communicator_GetUserGroupInfo
@synthesize groupid;
@synthesize isCreator;

- (void)dealloc
{
    self.groupid = nil;
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
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:WT_GET_GROUP_INFO] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else{
            NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_GROUP_INFO];
            
            UserGroup* room = [[UserGroup alloc] initWithID:self.groupid withGroupNameOriginal:[infodict objectForKey:XML_GROUP_NAME_KEY] withGroupNameLocal:[infodict objectForKey:XML_GROUP_NAME_KEY] withGroupStatus:[infodict objectForKey:XML_GROUP_STATUS_KEY]                                              withMaxNumber:[infodict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY]                                                            withMemberCount:[infodict objectForKey:XML_GROUP_MEMBER_COUNT_KEY]
                                                withLaitude:[[infodict objectForKey:XML_GROUP_LATITUDE] doubleValue]  withLongitude:[[infodict objectForKey:XML_GROUP_LONGITUDE] doubleValue]  withPlace:[infodict objectForKey:XML_GROUP_PLACE] withType:[infodict objectForKey:XML_GROUP_TYPE] withShortid:[infodict objectForKey:XML_GROUP_SHORT_ID] withIntroduction:[infodict objectForKey:XML_GROUP_STATUS_KEY]];
            
            room.thumbnail_timestamp = [infodict objectForKey:XML_GROUP_TIMESTAMP];
            
            [UserGroup storeGroupInDatabase:room];
            
            [room release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
