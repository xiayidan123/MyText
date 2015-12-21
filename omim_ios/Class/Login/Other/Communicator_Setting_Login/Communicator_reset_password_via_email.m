//
//  Communicator_reset_password_via_email.m
//  dev01
//
//  Created by Starmoon on 15/7/27.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_reset_password_via_email.h"

@implementation Communicator_reset_password_via_email

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSString *uid = @"";
    NSString *user_name = @"";
    
    if (errNo == NO_ERROR)
    {
        uid = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_RESET_PASSWORD_VIA_EMAIL][@"uid"];
        user_name = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_RESET_PASSWORD_VIA_EMAIL][@"user_name"];
    }
    if(uid == nil) uid = @"";
    if (user_name == nil)user_name = @"";
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[uid,user_name] forKeys:@[@"uid",@"user_neme"]];
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:dic]];
}

@end
