//
//  Communicator_uploadEventMultimedia.m
//  dev01
//
//  Created by 杨彬 on 14-12-3.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_uploadEventMultimedia.h"

@implementation Communicator_uploadEventMultimedia

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
