//
//  Communicator_VerifyPhoneNumber.m
//  omim
//
//  Created by Harry on 14-2-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_VerifyPhoneNumber.h"
#import "WTUserDefaults.h"

@implementation Communicator_VerifyPhoneNumber

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
        if (bodydict == nil || [bodydict objectForKey:XML_VERIFY_PHONE_NUMBER] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else
        {
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_VERIFY_PHONE_NUMBER];
            if ([infodict objectForKey:XML_PHONE_NUMBER_KEY] != nil)
            {
                [WTUserDefaults setPhoneNumber:[infodict objectForKey:XML_PHONE_NUMBER_KEY]];
            }
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
