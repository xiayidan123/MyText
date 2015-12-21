//
//  Communicator_AddSurveyMoment.m
//  wowtalkbiz
//
//  Created by elvis on 2013/11/13.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_AddSurveyMoment.h"

@implementation Communicator_AddSurveyMoment

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
        
        NSMutableDictionary * momentdict = [[dict objectForKey:WT_ADD_MOMENT_SURVEY] objectForKey:@"moment"];
      
        self.moment = [[Moment alloc] initWithDict:momentdict];
        [Database storeMoment:self.moment];
        
        if(PRINT_LOG){
            NSLog(@"moment id is  %@.", self.moment.moment_id);
            NSLog(@"moment timestamp is  %zi.", self.moment.timestamp);
        }
        
        [self networkTaskDidFinishWithReturningData:self.moment error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        return;
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
}

@end
