//
//  Communicator_GetLatestVersion.m
//  dev01
//
//  Created by 杨彬 on 15/3/16.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_GetLatestVersion.h"

@implementation Communicator_GetLatestVersion

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    BOOL hasNewVersion = NO;
    if (errNo == NO_ERROR)
    {
        NSDictionary* dict = [[[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_VERSION] objectForKey:@"ios"];
        
        if (dict == nil) {
            [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
            return;
        }
        
        NSString *newVersion = [dict valueForKey:@"ver_name"];
        
        NSString* version =[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if (![newVersion isEqualToString:version]){
            hasNewVersion = YES;
        }
    }
    
    [self networkTaskDidFinishWithReturningData:@(hasNewVersion) error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
