//
//  Communicator_ReviewMoment.m
//  yuanqutong
//
//  Created by Harry on 13-2-28.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_ReviewMoment.h"

@implementation Communicator_ReviewMoment

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary* dic = [[[result objectForKey:XML_BODY_NAME] objectForKey:@"review_moment"] objectForKey:@"review"];
        Review* review = [[Review alloc] initWithDict:dic];

        [Database storeMomentReview:review forMomentID:self.momentid];
        [review release];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
