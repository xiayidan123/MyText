//
//  Communicator_UploadMomentMultimedia.m
//  yuanqutong
//
//  Created by Harry on 13-2-28.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_UploadMomentMultimedia.h"

@implementation Communicator_UploadMomentMultimedia

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
