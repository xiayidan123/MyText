//
//  Communicator_ResetPassword.m
//  omim
//
//  Created by Harry on 14-2-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_ResetPassword.h"

@implementation Communicator_ResetPassword

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
