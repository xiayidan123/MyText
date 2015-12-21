//
//  GroupChatRoom.h
//  omimLibrary
//
//  Created by Yi Chen on 5/14/12.
//  Copyright (c) 2014 OneMeter Inc. All rights reserved.
//

//#import "Buddy.h"

@class GroupMember;

@interface GroupChatRoom : NSObject{
    /**
	 *　グループID : 例 "g12345"
	 */
	NSString* groupID ; 
	
	/**
	 *　サーバ側で創設時設定されたグループ名
	 */
	NSString* groupNameOriginal; 
	
	/**
	 * ローカルで設定したグループ名
	 */
	NSString* groupNameLocal; 
	
    
	/**
	 * グループ最新ステータス
	 */
	NSString* groupStatus; 
	
    
	/**
	 * メンバー数の最大限
	 */
	NSInteger maxNumber;  
	
    
	/**
	 * メンバー数
	 */
	NSInteger memberCount;
    
    
	/**
	 * メンバー数
	 */
	BOOL isTemporaryGroup;
	
	/**
	 * メンバーリスト (object is GroupMember class)
	 */
	NSMutableArray* memberList ;
    
    
}


@property (copy) NSString* groupID;
@property (copy) NSString* groupNameOriginal;
@property (copy) NSString* groupNameLocal;
@property (copy) NSString* groupStatus;
@property (assign) NSInteger maxNumber;
@property (assign) NSInteger memberCount;
@property (assign) BOOL isTemporaryGroup;

@property (nonatomic,retain) NSMutableArray* memberList;

-(id) initWithID:(NSString*)_groupID 
withGroupNameOriginal:(NSString*)_groupNameOriginal 
withGroupNameLocal:(NSString*)_groupNameLocal
 withGroupStatus:(NSString*)_groupStatus
   withMaxNumber:(NSString*)_maxNumber
 withMemberCount:(NSString*)_memberCount
isTemporaryGroup:(BOOL)_isTemporaryGroup;

-(void) addMember:(GroupMember*)buddy;

+(void)storeTempGroupInDatebase:(GroupChatRoom*)room;


// add by Elvis. Seems not neccessary...dan sui...
@property (assign) BOOL isInvisibile;



@end