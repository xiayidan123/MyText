//
//  Communicator_use_room.m
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_use_room.h"
#import "ClassRoom.h"

@implementation Communicator_use_room


-(void)dealloc{
    [_classRoom release];
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    id body = nil;
    if (errNo == NO_ERROR)
    {
        body = [result objectForKey:XML_BODY_NAME][WT_USE_SCHOOL_LESSON_ROOM];
    }
    
    [self networkTaskDidFinishWithReturningData:body error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}



@end
