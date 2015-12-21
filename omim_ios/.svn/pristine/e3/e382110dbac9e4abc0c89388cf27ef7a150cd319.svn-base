//
//  Communicator_SengGroupMessage.m
//  omimLibrary
//
//  Created by Yi Chen on 5/28/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_SendGroupMessage.h"
#import "Database.h"
#import "GlobalSetting.h"

@implementation Communicator_SendGroupMessage

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
