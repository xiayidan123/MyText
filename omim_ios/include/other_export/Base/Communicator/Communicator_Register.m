//
//  Communicator_Register.m
//  omim
//
//  Created by Harry on 14-1-15.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_Register.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_Register

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
       
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
