//
//  GroupChatRoom.m
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

#import "GroupChatRoom.h"
#import "GroupMember.h"
#import "Database.h"

@implementation GroupChatRoom

@synthesize groupID;
@synthesize groupNameOriginal;
@synthesize groupNameLocal;
@synthesize groupStatus;
@synthesize maxNumber;
@synthesize memberCount;
@synthesize isTemporaryGroup;
@synthesize memberList;




-(id) initWithID:(NSString*)_groupID 
withGroupNameOriginal:(NSString*)_groupNameOriginal 
withGroupNameLocal:(NSString*)_groupNameLocal
 withGroupStatus:(NSString*)_groupStatus
   withMaxNumber:(NSString*)_maxNumber
 withMemberCount:(NSString*)_memberCount
isTemporaryGroup:(BOOL)_isTemporaryGroup{
    self = [super init];
	if (self == nil)
		return nil;
    self.groupID=(_groupID!=nil)?_groupID:@"";
    self.groupNameOriginal=(_groupNameOriginal!=nil)?_groupNameOriginal:@"";
    
	self.groupNameLocal=(_groupNameLocal!=nil)?_groupNameLocal:@"";
	self.groupStatus=(_groupStatus!=nil)?_groupStatus:@"";
    
    self.maxNumber =  (_maxNumber!=nil)? [_maxNumber intValue] :10;
    self.memberCount = (_memberCount!=nil)? [_memberCount intValue]:0;
    self.isTemporaryGroup = _isTemporaryGroup;
    
    self.memberList =nil;
    return self;

}

-(void) addMember:(GroupMember*)member{
    if(member==nil) return;
    if(memberList==nil){
        memberList = [[NSMutableArray alloc]init ];
    }
    [memberList addObject:member];
}

+(void)storeTempGroupInDatebase:(GroupChatRoom*)room
{

    NSArray* msgs = [Database fetchChatMessagesWithUser:room.groupID];
    
    if (msgs == nil || [msgs count] == 0) {
         room.isInvisibile = TRUE;
    }
    else
        room.isInvisibile = FALSE;
   
    
    GroupChatRoom* oldroom = [Database getGroupChatRoomByGroupid:room.groupID];
    
    if (oldroom) room.isInvisibile = oldroom.isInvisibile;
    
    [Database storeGroupChatRoom:room];
        
    
}

-(void)dealloc
{
    self.groupID = nil;
    self.groupNameOriginal = nil;
    self.groupNameLocal = nil;
    self.groupStatus = nil;
    
    self.memberList = nil;
    
    [super dealloc];
}

@end
