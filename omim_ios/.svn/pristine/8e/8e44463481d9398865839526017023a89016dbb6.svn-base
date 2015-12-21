//
//  Communicator_RequireAccessCodeAfterIVR.m
//  omimLibrary
//
//  Created by Yi Chen on 8/29/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_RequireAccessCodeAfterIVR.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_RequireAccessCodeAfterIVR

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:XML_GET_IVR_ACCESSCODE_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else{
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_IVR_ACCESSCODE_KEY];
            NSString *authCode = [infodict objectForKey:XML_ACCESS_CODE_KEY];
            if (authCode && authCode.length > 0)
            {
                [WTUserDefaults setDemoModeCode:authCode];
            }
        }
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end