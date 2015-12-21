//
//  Communicator_Get_user_setting.m
//  dev01
//
//  Created by Starmoon on 15/7/24.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_Get_user_setting.h"
#import "OMUserSetting.h"
#import "MJExtension.h"

@implementation Communicator_Get_user_setting


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    
    if (errNo == NO_ERROR)
    {
        NSDictionary* dict = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_PUT_USER_SETTING];
        
        if ([dict isKindOfClass:[NSDictionary class]] ){
            OMUserSetting *user_setting = [OMUserSetting objectWithKeyValues:dict];
            [user_setting storeUserSetting];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
