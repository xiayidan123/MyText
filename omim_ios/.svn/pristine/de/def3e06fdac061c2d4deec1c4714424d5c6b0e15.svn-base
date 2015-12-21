//
//  Communicator_BindPhoneNumber.m
//  omim
//
//  Created by Harry on 14-2-23.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_BindPhoneNumber.h"

@implementation Communicator_BindPhoneNumber

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    if (errNo == NO_ERROR) {
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];
        if (dict == nil || [dict objectForKey:WT_ADD_MOMENT] == nil){
            errNo = NECCESSARY_DATA_NOT_RETURNED;
         [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }
        else{
     
            NSDictionary* momentdic = [dict objectForKey:WT_ADD_MOMENT];
            NSString* momentid  = [momentdic objectForKey:MOMENT_ID];
            if (PRINT_LOG) {
                NSLog(@"the created moment id is %@",momentid);
            }
            [self networkTaskDidFinishWithReturningData:momentid error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        }

    }
}

@end
