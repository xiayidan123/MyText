//
//  Communicator_GetSingleMoment.m
//  dev01
//
//  Created by coca on 11/2/14.
//  Copyright (c) 2014 wowtech. All rights reserved.
//

#import "Communicator_GetSingleMoment.h"
#import "WTUserDefaults.h"
#import "GlobalSetting.h"

@implementation Communicator_GetSingleMoment

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];
        if (dict == nil || ![dict objectForKey:WT_GET_SINGLE_MOMENT]) {
            errNo = NECCESSARY_DATA_NOT_RETURNED;
            [Database deleteMomentWithMomentID:self.momentId];
            [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_DELETE_MOMENT object:self.momentId];
        } else {
            NSMutableDictionary *infoDict = [dict objectForKey:WT_GET_SINGLE_MOMENT];
            
            NSMutableDictionary *momentDict =  [infoDict objectForKey:XML_MOMENT_KEY];
            Moment *moment = [[Moment alloc] initWithDict:momentDict];
            [Database storeMoment:moment];            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MOMENT_ACTION_REFRESH_MOMENT object:moment.moment_id];
            
            [moment release];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
