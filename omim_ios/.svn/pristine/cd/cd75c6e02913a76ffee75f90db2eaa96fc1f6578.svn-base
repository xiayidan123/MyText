//
//  Communicator_VerifyEmail.m
//  omim
//
//  Created by Harry on 14-2-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_VerifyEmail.h"
#import "WTUserDefaults.h"

@implementation Communicator_VerifyEmail

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
        if (bodydict == nil || [bodydict objectForKey:XML_VERIFY_EMAIL_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else
        {
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_VERIFY_EMAIL_KEY];
            if ([infodict objectForKey:XML_EMAIL_ADDRESS_KEY] != nil)
            {
                [WTUserDefaults setEmail:[infodict objectForKey:XML_EMAIL_ADDRESS_KEY]];
            }
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
