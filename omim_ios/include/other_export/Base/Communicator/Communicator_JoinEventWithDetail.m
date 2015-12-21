//
//  Communicator_JoinEventWithDetail.m
//  dev01
//
//  Created by elvis on 2013/07/09.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_JoinEventWithDetail.h"

@implementation Communicator_JoinEventWithDetail

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
