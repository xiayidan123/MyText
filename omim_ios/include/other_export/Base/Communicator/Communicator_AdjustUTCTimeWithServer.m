//
//  Communicator_AdjustUTCTimeWithServer.m
//  omimLibrary
//
//  Created by Yi Chen on 9/6/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_AdjustUTCTimeWithServer.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_AdjustUTCTimeWithServer

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
        if (dict == nil || [dict objectForKey:XML_GET_SERVER_UTCTIME_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else{
            NSMutableDictionary *utctimedict = [dict objectForKey:XML_GET_SERVER_UTCTIME_KEY];
            NSString *serverUTCTimeInSec = [utctimedict objectForKey:XML_SERVER_UTCTIME_KEY];
            
            if(PRINT_LOG)
                NSLog(@"server time interval is %@.", serverUTCTimeInSec);
            int localtime = (int)[[NSDate date] timeIntervalSince1970];
            if(PRINT_LOG)
                NSLog(@"local time interval is %d!", localtime);
            
            if(serverUTCTimeInSec != nil)
            {
                long long timeOffset = [serverUTCTimeInSec intValue] - localtime;
                if(PRINT_LOG)
                    NSLog(@"timeOffset is %lld!", timeOffset);
                
                [WTUserDefaults setTimeOffset:timeOffset];
                
                if(PRINT_LOG)
                    NSLog(@"timeOffset is set:%@!", [WTUserDefaults getTimeOffset]);
            }
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end