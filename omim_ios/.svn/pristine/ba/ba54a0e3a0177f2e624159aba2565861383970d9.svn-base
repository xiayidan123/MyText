//
//  Communicator_retrieve_password_via_email.m
//  dev01
//
//  Created by Starmoon on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_retrieve_password_via_email.h"

@implementation Communicator_retrieve_password_via_email


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
//    NSString *error_string = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_RSTRIEVE_PASSWORD_VIA_EMAIL][@"error"];
//    NSDictionary *err_dic = [NSDictionary dictionaryWithObject:error_string forKey:@"error_string"];
    if (errNo == NO_ERROR){
        
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
