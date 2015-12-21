//
//  Communicator_Unlink.m
//  wowcity
//
//  Created by elvis on 2013/06/04.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_Unlink.h"

@implementation Communicator_Unlink
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
       
        if (self.unlinkEmail) {
            [WTUserDefaults setEmail:@""];
        }
        else{
            [WTUserDefaults setPhoneNumber:@""];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
