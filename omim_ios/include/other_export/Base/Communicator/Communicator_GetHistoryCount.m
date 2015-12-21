//
//  Communicator_GetHistoryCount.m
//  suzhou
//
//  Created by jianxd on 14-2-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetHistoryCount.h"

@implementation Communicator_GetHistoryCount

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    
    if (errNo == NO_ERROR) {
        NSMutableDictionary *bodyDic = [result objectForKey:XML_BODY_NAME];
        NSMutableDictionary *infoDic = [bodyDic objectForKey:@"get_chat_history_count"];
        NSInteger count = [[infoDic objectForKey:@"chat_record_summary"] integerValue];
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"history_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
