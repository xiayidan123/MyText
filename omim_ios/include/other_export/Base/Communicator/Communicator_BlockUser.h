//
//  Communicator_BlockUser.h
//  omimLibrary
//
//  Created by Yi Chen on 5/7/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_BlockUser : Communicator
{
    BOOL block_flag;
}

@property(assign) BOOL block_flag;

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues forBuddyID:(NSString*)buddy_id;

@end
