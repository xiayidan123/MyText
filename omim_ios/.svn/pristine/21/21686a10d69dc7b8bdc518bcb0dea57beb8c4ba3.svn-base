//
//  Communicator_ChangePassword.m
//  omim
//
//  Created by Harry on 14-2-3.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_ChangePassword.h"
#import "WTUserDefaults.h"

@implementation Communicator_ChangePassword

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
        if (dict == nil || ![dict objectForKey:WT_CHANGE_PASSWORD])
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else
        {
            NSMutableDictionary *infoDict = [dict objectForKey:WT_CHANGE_PASSWORD];
            
            if ([infoDict
                 objectForKey:HASHED_PASSWORD]&& ![[infoDict objectForKey:HASHED_PASSWORD] isEqual:@""] ) [WTUserDefaults setHashedPassword:[infoDict objectForKey:HASHED_PASSWORD]];
            
            if ([infoDict objectForKey:PASSWORD_CHANGED])[WTUserDefaults setPwdChanged:[infoDict objectForKey:PASSWORD_CHANGED]];
            if ([infoDict objectForKey:SIP_PASSWORD])[[NSUserDefaults standardUserDefaults] setObject:[infoDict objectForKey:SIP_PASSWORD] forKey:@"password_preference"];
            [WowTalkVoipIF fRegister];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
