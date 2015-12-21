//
//  Communicator_NoDataFeedback.m
//  omim
//
//  Created by coca on 2012/12/17.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "Communicator_NoDataFeedback.h"

@implementation Communicator_NoDataFeedback

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
