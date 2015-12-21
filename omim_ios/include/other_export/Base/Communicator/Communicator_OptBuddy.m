//
//  Communicator_OptBuddy.m
//  dev01
//
//  Created by jianxd on 14-4-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_OptBuddy.h"

@implementation Communicator_OptBuddy

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    NSInteger errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] integerValue];
    }

    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
