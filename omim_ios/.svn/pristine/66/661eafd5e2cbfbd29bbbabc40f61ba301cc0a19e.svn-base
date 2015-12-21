//
//  Communicator_RequireAccessCode.m
//  omimLibrary
//
//  Created by Yi Chen on 4/22/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_RequireAccessCode.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_RequireAccessCode

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
        if (bodydict == nil || [bodydict objectForKey:XML_GET_ACCESSCODE_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else{
           NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_ACCESSCODE_KEY];
            if ([infodict objectForKey:XML_ISDEMO_KEY] != nil && [[infodict objectForKey:XML_ISDEMO_KEY] boolValue] == YES)
            {
                [WTUserDefaults setDemoModeCode:[infodict objectForKey:XML_ACCESS_CODE_KEY]];
            }
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
