//
//  Communicator_AddEvent.m
//  dev01
//
//  Created by 杨彬 on 14-11-4.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_AddEvent.h"

@implementation Communicator_AddEvent

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
    NSString *event_id = [[[result objectForKey:XML_BODY_NAME] objectForKey:@"add_event"] objectForKey:@"event_id"];
    [self networkTaskDidFinishWithReturningData:event_id error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
