//
//  Communicator_RejectFriendRequest.m
//  omim
//
//  Created by elvis on 2013/05/09.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_RejectFriendRequest.h"

@implementation Communicator_RejectFriendRequest

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
