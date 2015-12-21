//
//  Communicator_GetPrivacySetting.m
//  omimLibrary
//
//  Created by Yi Chen on 5/22/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetPrivacySetting.h"
#import "GlobalSetting.h"
#import "WTUserDefaults.h"

@implementation Communicator_GetPrivacySetting

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
        if (bodydict == nil || [bodydict objectForKey:XML_GET_PRIVACY_SETTING] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else
        {
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_PRIVACY_SETTING];
                        
            [WTUserDefaults setAllowPeopleAddMe:[[infodict objectForKey:XML_ALLOW_ADD_KEY] integerValue]];
            [WTUserDefaults setListMeInNearbyResult:[[infodict objectForKey:@"list_me_in_nearby_result"] boolValue]];
            
            // below is not working yet.
            [WTUserDefaults setAllowStranderCall:[[infodict objectForKey:XML_ALLOW_STRANGER_CALL_KEY] boolValue]];
            [WTUserDefaults setShowPushDetail:[[infodict objectForKey:XML_SHOW_PUSH_DETAIL_KEY] boolValue]];

        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
