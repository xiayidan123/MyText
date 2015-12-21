//
//  Department.h
//  dev01
//
//  Created by elvis on 2013/08/22.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UserGroup.h"

@interface Department : UserGroup

@property int level;
@property (nonatomic,retain) NSString* parent_id;
@property BOOL isHeadNode;
@property BOOL isGroupnameChanged;

@property BOOL isFavorite;

@property double weight;


// we define the group thumb file path as groupid_thumb.jpg  , original file as group_id_full.jpg

-(id) initWithDict:(NSMutableDictionary*)dict;

-(id) initWithID:(NSString*)_groupID withGroupNameOriginal:(NSString*)_groupNameOriginal withGroupNameLocal:(NSString*)_groupNameLocal withGroupStatus:(NSString*)_groupStatus withMaxNumber:(NSString*)_maxNumber withMemberCount:(NSString*)_memberCount withLaitude:(double)latitude withLongitude:(double)longtitude withPlace:(NSString*)placename withType:(NSString*)grouptype withShortid:(NSString*) shortid withIntroduction:(NSString*)intro withParentID:(NSString*)parent_id withisHeadNode:(NSString*)iseditable withGroupnameChanged:(NSString*)isGroupnameChanged withLevel:(NSString*)level withWeight:(double)weight;


+(void)processDepartmentBeforeStorage:(Department*)department;

@end
