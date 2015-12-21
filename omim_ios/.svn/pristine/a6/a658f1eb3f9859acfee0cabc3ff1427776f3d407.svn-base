//
//  UserGroup.h
//  omim
//
//  Created by coca on 2013/04/24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "GroupChatRoom.h"

@interface UserGroup : GroupChatRoom

@property (nonatomic,retain) NSString* createdPlace;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property  (nonatomic,retain) NSString* groupType;
@property (nonatomic,retain) NSString* introduction;
@property (assign) BOOL needToDownloadThumbnail;
@property (assign) BOOL needToDownloadPhoto;
@property (nonatomic,retain) NSString* thumbnail_timestamp;

@property (nonatomic,retain) NSString* shortid;


// we define the group thumb file path as groupid_thumb.jpg  , original file as group_id_full.jpg

-(id) initWithID:(NSString*)_groupID withGroupNameOriginal:(NSString*)_groupNameOriginal withGroupNameLocal:(NSString*)_groupNameLocal
 withGroupStatus:(NSString*)_groupStatus withMaxNumber:(NSString*)_maxNumber withMemberCount:(NSString*)_memberCount withLaitude:(double)latitude withLongitude:(double)longtitude withPlace:(NSString*)placename withType:(NSString*)grouptype withShortid:(NSString*) shortid withIntroduction:(NSString*)intro;


+(NSString*)groupType: (NSString*) type;


+(void)storeGroupInDatabase:(UserGroup*)group;


+(void)processGroupBeforeStorage:(UserGroup*)group;

@end
