//
//  Communicator_ask_for_leave.m
//  dev01
//
//  Created by Huan on 15/4/30.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_ask_for_leave.h"

@implementation Communicator_ask_for_leave
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
