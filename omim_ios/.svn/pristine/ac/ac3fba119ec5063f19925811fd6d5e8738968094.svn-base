//
//  Communicator_UpdateUID.m
//  omimLibrary
//
//  Created by Yi Chen on 9/17/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_UpdateUID.h"
@implementation Communicator_UpdateUID

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
        if (dict == nil || [dict objectForKey:@"update_uid"] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        
        else
        {
            NSMutableDictionary *infoDict = [dict objectForKey:@"update_uid"];
            
            [WTUserDefaults setUid:[infoDict objectForKey:UUID]];
            [WTUserDefaults setHashedPassword:[infoDict objectForKey:HASHED_PASSWORD]];
                      
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[infoDict objectForKey:UUID] forKey:@"uid_preference"];
            [defaults setObject:[infoDict objectForKey:SIP_PASSWORD] forKey:@"password_preference"];
            [defaults synchronize];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];}

@end


