//
//  GroupList.h
//  wowtalkbiz
//
//  Created by elvis on 2013/08/19.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GroupListCellDelegate;
@protocol FavoriteGroupCellDelegate;
@class GroupList;

@protocol GroupListDelegate <NSObject>
@optional

-(void)favirateTheGroup:(NSString*) departmentid;
-(void)messageTheGroup:(NSString*) departmentid;
-(void)selectTheGroup:(NSString*) departmentid;
-(void)changeGroupOrder:(GroupList*)request;

@end


@interface GroupList : UIView 

/*
 dictionary format: dic = { "128288" -> "128288", "123455" -> {"1123->1123","12321->1123"}}
 */

@property (nonatomic,retain) NSMutableArray* selectedDepartments;

@property BOOL selectionMode;

@property BOOL isWithStarAndChat;

@property (nonatomic,assign) id <GroupListDelegate>delegate;

@property (nonatomic,retain) NSMutableDictionary* groups;    // we have a dictionary records all the showing groups

@property (nonatomic,retain) NSMutableArray* sortedKeys;     // the group id have to shown on the list in order.

-(void)tile;

@end
