//
//  Communicator_VerifyCode.m
//  dev01
//
//  Created by Huan on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_VerifyCode.h"

@implementation Communicator_VerifyCode
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
