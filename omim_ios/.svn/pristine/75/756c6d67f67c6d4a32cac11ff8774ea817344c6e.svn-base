//
//  Communicator_FavoriteGroups.m
//  dev01
//
//  Created by elvis on 2013/08/28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_FavoriteGroups.h"

@implementation Communicator_FavoriteGroups
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
