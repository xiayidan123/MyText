//
//  Communicator_GetMomentForBuddy.m
//  yuanqutong
//
//  Created by Harry on 13-2-28.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetMomentForBuddy.h"
#import "Moment.h"
#import "Communicator_GetMomentsForGroup.h"

@interface Communicator_GetMomentForBuddy () {
    NSMutableArray *momentsFromServerArray;
}
@end

@implementation Communicator_GetMomentForBuddy
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    int count = 0;
    if (errNo == NO_ERROR)
    {
        if (nil == momentsFromServerArray) {
            momentsFromServerArray= [[[NSMutableArray alloc] init] autorelease];
        }
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];

            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_MOMENT_FOR_BUDDY_KEY];
           
        if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableArray class]]) {
             NSMutableArray *momentsArray = [infodict objectForKey:XML_MOMENT_KEY];
            for (NSMutableDictionary *momentDict in momentsArray)
            {
                Moment *moment = [[Moment alloc] initWithDict:momentDict];
                [momentsFromServerArray addObject:moment];
                [Database storeMoment:moment];
                [moment release];
                count += 1;
            }
        
        }
        else if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableDictionary class]]){
            NSMutableDictionary *momentDict =  [infodict objectForKey:XML_MOMENT_KEY];
            Moment *moment = [[Moment alloc] initWithDict:momentDict];
            [momentsFromServerArray addObject:moment];
            [Database storeMoment:moment];
            [moment release];
            count += 1;
        }
        
        NSMutableArray *momentsAll=[[[NSMutableArray alloc] init] autorelease];
        [momentsAll addObjectsFromArray: [Database fetchMomentsForBuddy:self.uid withLimit:LONG_MAX andOffset:0]];
        [Communicator_GetMomentsForGroup deleteMomentFromDbWhenLoadedFromServer:momentsFromServerArray compareAllMoments:momentsAll withTimeStamp:self.maxTimestamp withTags:self.momentTags];
    }
    [self networkTaskDidFinishWithReturningData:@(count) error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
