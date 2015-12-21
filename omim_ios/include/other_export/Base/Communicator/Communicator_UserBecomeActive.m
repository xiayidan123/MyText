//
//  Communicator_UserBecomeActive.m
//  omim
//
//  Created by coca on 14-3-31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_UserBecomeActive.h"

@implementation Communicator_UserBecomeActive

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
