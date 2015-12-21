//
//  Communicator_ChangeWowtalkID.m
//  omim
//
//  Created by Harry on 14-2-3.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_ChangeWowtalkID.h"
#import "WTUserDefaults.h"

@implementation Communicator_ChangeWowtalkID

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];
        if (dict == nil || ![dict objectForKey:WT_CHANGE_WOWTALK_ID])
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else
        {
            NSMutableDictionary *infoDict = [dict objectForKey:WT_CHANGE_WOWTALK_ID];

            [WTUserDefaults setWTID:[infoDict objectForKey:WT_ID]];
            [WTUserDefaults setIdChanged:[infoDict objectForKey:WOWTALK_ID_CHANGED]];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
