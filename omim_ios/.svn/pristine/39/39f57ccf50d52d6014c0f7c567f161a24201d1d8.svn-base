//
//  Communicator_CreateGroupChatRoom.m
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_CreateGroupChatRoom.h"
#import "GlobalSetting.h"

@implementation Communicator_CreateGroupChatRoom

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    NSString* groupid = nil;
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];

        if (dict == nil || ([dict objectForKey:XML_CREATE_TEMP_CHATROOM_KEY] == nil))
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else if ([dict objectForKey:XML_CREATE_TEMP_CHATROOM_KEY])
            groupid = [[dict objectForKey:XML_CREATE_TEMP_CHATROOM_KEY] objectForKey:XML_GROUP_ID_KEY];
    }
    
    
    [self networkTaskDidFinishWithReturningData:groupid error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}

@end
