//
//  Communicator_GetJoinableEventList.m
//  omim
//
//  Created by Harry on 14-2-2.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetJoinableEventList.h"
#import "AvatarHelper.h"
#import "Activity.h"
#import "WowTalkWebServerIF.h"
@implementation Communicator_GetJoinableEventList

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
    // TODO: get event details here. Old codes are as follows
    /*
     Activity *activity = [Database getActivityWithID:eventid];
     if (activity.multimedias == nil || activity.multimedias.count == 0){
     [WTNetworkFunction getEventDetail:eventid withCallback:nil withObserver:nil];
     }
     */
    
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:XML_GET_JOINABLE_EVENTS_KEY] == nil)
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        else
        {
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_JOINABLE_EVENTS_KEY];
            
            if ([[infodict objectForKey:XML_EVENT_KEY] isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *eventsArray = [infodict objectForKey:XML_EVENT_KEY];
                
                for (NSMutableDictionary *eventDict in eventsArray)
                    [self handleEvent:eventDict];
            }
            else if([[infodict objectForKey:XML_EVENT_KEY] isKindOfClass:[NSMutableDictionary class]]){
                NSMutableDictionary* eventDict =  [infodict objectForKey:XML_EVENT_KEY];
                [self handleEvent:eventDict];
                
            }
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}

@end
