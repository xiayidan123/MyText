//
//  Communicator_GetGroupMembers.h
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//


#import "Communicator.h"

@interface Communicator_GetGroupMembers : Communicator
{
    
}

- (void)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues
  forGroupID:(NSString*)group_id;

@end
