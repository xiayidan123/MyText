//
//  Communicator_GetBuddy.h
//  omimLibrary
//
//  Created by Yi Chen on 6/13/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//
#import "Communicator.h"

@interface Communicator_GetBuddy : Communicator
{

}
-(void)fPost:(NSMutableArray *)postKeys withPostValue:(NSMutableArray *)postValues forBuddyID:(NSString *)buddyID;

@end
