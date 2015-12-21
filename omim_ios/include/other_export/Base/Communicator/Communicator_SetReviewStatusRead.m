//
//  Communicator_SetReviewStatusRead.m
//  omim
//
//  Created by coca on 2013/04/03.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_SetReviewStatusRead.h"


@implementation Communicator_SetReviewStatusRead

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        [Database setReviewReadByIDArray:self.reviews];
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
