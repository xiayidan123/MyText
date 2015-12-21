//
//  Communicator_GetLatestReviewsForMe.m
//  yuanqutong
//
//  Created by シュ シャンビン on 2013/04/02.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetLatestReviewsForMe.h"

@implementation Communicator_GetLatestReviewsForMe

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary* infodic = [[result valueForKey:XML_BODY_NAME] valueForKey:WT_GET_LATEST_REVIEWS_FOR_ME];
        if (infodic) {
            
            if ([[infodic valueForKey:@"review"] isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary* dic = [infodic valueForKey:@"review"];
                Review* review = [[Review alloc] initWithDict:dic];
                [Database storeMomentReview:review forMomentID:[dic valueForKey:@"moment_id"]];
                [review release];
            
            }
            else if ([[infodic valueForKey:@"review"] isKindOfClass:[NSMutableArray class]]){
                
                for (NSMutableDictionary* dic  in [infodic valueForKey:@"review"]) {
                    Review* review = [[Review alloc] initWithDict:dic];
                    [Database storeMomentReview:review forMomentID:[dic valueForKey:@"moment_id"]];
                    [review release];
                }
            }
            
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
