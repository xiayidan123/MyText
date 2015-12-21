//
//  Communicator_AddBuddy.h
//  omimLibrary
//
//  Created by Yi Chen on 6/1/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_AddBuddy : Communicator
{

}

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues forBuddyID:(NSString*)buddy_id;

@end
