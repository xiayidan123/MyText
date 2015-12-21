//
//  Communicator_SendMsgToOfficialUser.m
//  omim
//
//  Created by coca on 14-3-31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_SendMsgToOfficialUser.h"
#import "Database.h"
#import "GlobalSetting.h"

@implementation Communicator_SendMsgToOfficialUser

@synthesize chatMessage;

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if(errNo == NO_ERROR)
    {
        if (chatMessage)
            [Database setChatMessageSent:chatMessage];
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
