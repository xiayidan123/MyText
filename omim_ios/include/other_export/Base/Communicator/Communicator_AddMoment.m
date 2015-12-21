//
//  Communicator_AddMoment.m
//  yuanqutong
//
//  Created by Harry on 13-2-28.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_AddMoment.h"
#import "Anonymous_Moment.h"

@implementation Communicator_AddMoment

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

            NSMutableDictionary * momentdict = [dict objectForKey:WT_ADD_MOMENT];
            NSString *momentid = [momentdict objectForKey:MOMENT_ID];
            NSString* timestamp = [momentdict objectForKey:MOMENT_TIMESTAMP];
            self.moment.moment_id = momentid;
            self.moment.timestamp = [timestamp intValue];
        
        
        if (!_isAnonymous){
            [Database storeMoment:self.moment];
        }else{
            self.moment.owner.userID = @"(anonymous)";
        }
            if(PRINT_LOG){
                NSLog(@"moment id is  %@.", momentid);
                NSLog(@"moment timestamp is  %@.", timestamp);
            }
        
        [self networkTaskDidFinishWithReturningData:self.moment error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
        return;
    }

   [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}


@end
