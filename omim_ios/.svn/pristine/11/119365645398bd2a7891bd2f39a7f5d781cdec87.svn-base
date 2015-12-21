//
//  Communicator_RemoveBuddy.m
//  omim
//
//  Created by elvis on 2013/05/10.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_RemoveBuddy.h"
#import "WTConstant.h"
@implementation Communicator_RemoveBuddy

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    if (errNo == NO_ERROR) {
        [Database deleteBuddyByID:self.buddy_id];
        [Database deleteChatMessagesWithBuddyID:self.buddy_id];
        NSMutableArray* allBuddyMoment=[Database fetchMomentsForBuddy:self.buddy_id withLimit:1000 andOffset:0];
        if (nil != allBuddyMoment) {
            for (Moment *aMOment in allBuddyMoment) {
                [Database deleteMomentWithMomentID:aMOment.moment_id];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WT_NOTIFICATION_MOMENT_LIST_CHANGED object:nil];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
