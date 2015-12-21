//
//  Communicator_BlockUser.m
//  omimLibrary
//
//  Created by Yi Chen on 5/7/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator_BlockUser.h"
#import "Database.h"
#import "GlobalSetting.h"

@interface Communicator_BlockUser()

@property (nonatomic, copy) NSString *strBuddyID;

@end

@implementation Communicator_BlockUser

@synthesize block_flag;
@synthesize strBuddyID = _strBuddyID;

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues forBuddyID:(NSString*)buddy_id{
    self.strBuddyID = buddy_id;
    [super fPost:postKeys withPostValue:postValues];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo != NO_ERROR)
    {
        if (errNo == USER_NOT_EXIST)
            if (self.strBuddyID != nil)
                [Database deleteBuddyByID:self.strBuddyID];
        
    }
    else
    {
        if(block_flag)
            [Database blockBuddy:self.strBuddyID];
        else
            [Database unblockBuddy:self.strBuddyID];

    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
