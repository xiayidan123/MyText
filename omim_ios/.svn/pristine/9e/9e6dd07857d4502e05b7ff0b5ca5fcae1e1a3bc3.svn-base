//
//  Communicator_ApplyEvent.m
//  dev01
//
//  Created by 杨彬 on 14-11-4.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_ApplyEvent.h"

@implementation Communicator_ApplyEvent

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    
    if (errNo == NO_ERROR)
    {
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
