//
//  Communicator_JoinOrLeaveOrAddGroup.h
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "Communicator.h"

@interface Communicator_JoinOrLeaveOrAddGroup : Communicator
{
    BOOL addGroupToDB;
    BOOL isTemporaryGroup;
}

@property int mode; // 0,1,2;
@property(assign) BOOL addGroupToDB;
@property BOOL isManager;
@property BOOL isCreater;

@property (nonatomic,retain) NSArray* addedMembers;

-(void)fPost:(NSMutableArray*)postKeys withPostValue:(NSMutableArray*)postValues forGroupID:(NSString*)group_id addGroupToDB:(BOOL)flag;

@end
