//
//  Communicator_VoteSurveyMoment.m
//  wowtalkbiz
//
//  Created by elvis on 2013/11/14.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_VoteSurveyMoment.h"

@implementation Communicator_VoteSurveyMoment
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
        
        NSMutableDictionary * momentdict = [[dict objectForKey:WT_VOTE_MOMENT_SURVEY] objectForKey:@"moment"];
        
        Moment* moment = [[Moment alloc] initWithDict:momentdict];
        //        self.moment.timestamp = [timestamp intValue];
        [Database storeMoment:moment];
        
        //as option_id may not in sequence,so get the moment from db again
        moment=[Database getMomentWithID:moment.moment_id];
        // TODO: check here. was stopped
        [self networkTaskDidFinishWithReturningData:moment error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        return;
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}
@end
