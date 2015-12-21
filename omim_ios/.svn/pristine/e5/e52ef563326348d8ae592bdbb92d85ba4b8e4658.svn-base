//
//  Communicator_GetMyGroups.m
//  omim
//
//  Created by elvis on 2013/05/09.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetMyGroups.h"

@implementation Communicator_GetMyGroups

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableArray *arrays = [[[NSMutableArray alloc] init] autorelease];
    
    if (errNo == NO_ERROR) {
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_MY_GROUPS];
        if ([[infodict objectForKey:XML_GROUP] isKindOfClass:[NSMutableDictionary class]])
        {
            NSMutableDictionary *groupdict = [infodict objectForKey:XML_GROUP];
            UserGroup* group = [[UserGroup alloc] initWithID:[groupdict objectForKey:XML_GROUP_ID_KEY] withGroupNameOriginal:[groupdict objectForKey:XML_GROUP_NAME_KEY] withGroupNameLocal:[groupdict objectForKey:XML_GROUP_NAME_KEY] withGroupStatus:[groupdict objectForKey:XML_GROUP_STATUS_KEY] withMaxNumber:[groupdict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY] withMemberCount:[groupdict objectForKey:XML_GROUP_MEMBER_COUNT_KEY] withLaitude:[[groupdict objectForKey:XML_GROUP_LATITUDE] doubleValue] withLongitude:[[groupdict objectForKey:XML_GROUP_LONGITUDE] doubleValue]  withPlace:[groupdict objectForKey:XML_GROUP_PLACE] withType:[groupdict objectForKey:XML_GROUP_TYPE] withShortid:[groupdict objectForKey:XML_GROUP_SHORT_ID] withIntroduction:[groupdict objectForKey:XML_GROUP_INTRO]];
            
            
            NSString* timestamp = [groupdict objectForKey:XML_GROUP_TIMESTAMP];
            
            group.thumbnail_timestamp = timestamp;
            
            [UserGroup processGroupBeforeStorage:group];
            
            [arrays addObject:group];
            [group release];
        }
        else if ([[infodict objectForKey:XML_GROUP] isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *arr = [infodict objectForKey:XML_GROUP];
            for (NSMutableDictionary *groupdict in arr)
            {
                UserGroup* group = [[UserGroup alloc] initWithID:[groupdict objectForKey:XML_GROUP_ID_KEY] withGroupNameOriginal:[groupdict objectForKey:XML_GROUP_NAME_KEY] withGroupNameLocal:[groupdict objectForKey:XML_GROUP_NAME_KEY] withGroupStatus:[groupdict objectForKey:XML_GROUP_STATUS_KEY] withMaxNumber:[groupdict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY] withMemberCount:[groupdict objectForKey:XML_GROUP_MEMBER_COUNT_KEY] withLaitude:[[groupdict objectForKey:XML_GROUP_LATITUDE] doubleValue] withLongitude:[[groupdict objectForKey:XML_GROUP_LONGITUDE] doubleValue]  withPlace:[groupdict objectForKey:XML_GROUP_PLACE] withType:[groupdict objectForKey:XML_GROUP_TYPE] withShortid:[groupdict objectForKey:XML_GROUP_SHORT_ID] withIntroduction:[groupdict objectForKey:XML_GROUP_INTRO]];
                
                NSString* timestamp = [groupdict objectForKey:XML_GROUP_TIMESTAMP];
                
                group.thumbnail_timestamp = timestamp;
                
                [UserGroup processGroupBeforeStorage:group];
                
                [arrays addObject:group];
                [group release];
            }
        }
        
    }
    
    if ([arrays count] == 0) {
        arrays = nil;
    }
    else{
        [Database deleteAllFixedGroup];
        
        for(UserGroup* group in arrays)
            [Database storeFixedGroup:group];
    }
    
    [self networkTaskDidFinishWithReturningData:arrays error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
    
    
}
@end
