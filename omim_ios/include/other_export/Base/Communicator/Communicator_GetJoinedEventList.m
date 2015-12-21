//
//  Communicator_GetJoinedEventList.m
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetJoinedEventList.h"
#import "Activity.h"
#import "WowTalkWebServerIF.h"
@implementation Communicator_GetJoinedEventList

-(void)handleEvent:(NSMutableDictionary*)eventDict
{
    Activity *activity = [[Activity alloc] initWithDict:eventDict];
    [Database storeEvent:activity];
    
    NSString *thumbpath = [eventDict objectForKey:@"thumbnail_filepath"];
    if (thumbpath != nil)
    {
        NSData *data = [AvatarHelper getThumbnailForFile:thumbpath];
        if (data == nil){
            [WowTalkWebServerIF getFileFromServer:thumbpath withCallback:nil withObserver:nil];
        }
    }
    [activity release];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }

    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *infoDict = [[result objectForKey:XML_BODY_NAME] objectForKey:WT_GET_JOINED_EVENTS];
        if ([[infoDict objectForKey:@"item"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *eventDictioary in [infoDict objectForKey:@"item"]) {
                Activity *activity = [[Activity alloc] initWithDict:eventDictioary];
                [activity release];
            }
        } else if ([[infoDict objectForKey:@"item"] isKindOfClass:[NSMutableDictionary class]]) {
            Activity *activity = [[Activity alloc] initWithDict:[infoDict objectForKey:@"item"]];
            [activity release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}

@end
