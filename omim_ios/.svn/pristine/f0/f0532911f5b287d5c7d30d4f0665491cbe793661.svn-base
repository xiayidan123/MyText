//
//  Communicator_JoinEvent.m
//  omim
//
//  Created by Harry on 14-2-18.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_JoinEvent.h"

@implementation Communicator_JoinEvent

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        //TODO: set this event membership to 2
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}

@end
