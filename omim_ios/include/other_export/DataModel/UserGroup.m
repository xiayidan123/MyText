//
//  UserGroup.m
//  omim
//
//  Created by coca on 2013/04/24.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "UserGroup.h"
#import "Database.h"
#import "WTHelper.h"

@implementation UserGroup

//@synthesize createdPlace = _createdPlace;
//@synthesize latitude = _latitude;
//@synthesize longitude = _longitude;
//@synthesize groupType = _groupType;
//@synthesize needToDownloadThumbnail = _needToDownloadThumbnail;
//@synthesize needToDownloadPhoto = _needToDownloadPhoto;
//@synthesize thumbnail_timestamp = _thumbnail_timestamp;
//@synthesize introduction = _introduction;

@synthesize shortid = _shortid;

-(id)initWithID:(NSString *)_groupID withGroupNameOriginal:(NSString *)_groupNameOriginal withGroupNameLocal:(NSString *)_groupNameLocal withGroupStatus:(NSString *)_groupStatus withMaxNumber:(NSString *)_maxNumber withMemberCount:(NSString *)_memberCount withLaitude:( double)latitude withLongitude:(double)longtitude withPlace:(NSString *)placename withType:(NSString *)grouptype withShortid:(NSString *)shortid withIntroduction:(NSString *)intro
{
    self = [super initWithID:_groupID withGroupNameOriginal:_groupNameOriginal withGroupNameLocal:_groupNameLocal withGroupStatus:_groupStatus withMaxNumber:_maxNumber withMemberCount:_memberCount isTemporaryGroup:NO];
    
    if (self) {
        self.createdPlace = placename;
        self.latitude = latitude;
        self.longitude = longtitude;
        self.groupType = grouptype;
        self.shortid = shortid;
        self.introduction = intro;
    }
    return self;
}

+(NSString*)groupType: (NSString*) type
{
    if(type==nil){
        type=@"class";
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GroupType" ofType:@"plist"];
  //  NSArray *userInfo = [NSArray arrayWithContentsOfFile:filePath];
    NSDictionary *usertypeDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return  [usertypeDict objectForKey:type];
       
}


+(void)processGroupBeforeStorage:(UserGroup*)group
{
    if ([group.thumbnail_timestamp isEqualToString:@"-1"]) {
        group.needToDownloadPhoto = FALSE;
        group.needToDownloadThumbnail = FALSE;
    }
    else{
        group.needToDownloadPhoto = TRUE;
        group.needToDownloadThumbnail = TRUE;
    }
    
    NSArray* msgs = [Database fetchChatMessagesWithUser:group.groupID];
    if (msgs == nil || [msgs count] == 0){
        group.isInvisibile = TRUE;
    }
    else{
        group.isInvisibile = FALSE;
    }
    
    UserGroup* oldgroup = [Database getFixedGroupByID:group.groupID];
    
    if (oldgroup) {
        
        group.isInvisibile = oldgroup.isInvisibile;
        
        if ([NSString isEmptyString:oldgroup.thumbnail_timestamp]){
            oldgroup.thumbnail_timestamp = @"-1";
        }
        
        if ([group.thumbnail_timestamp integerValue] <= [oldgroup.thumbnail_timestamp integerValue])
        {
            if (![oldgroup.thumbnail_timestamp isEqualToString:@"-1"]) {  
                NSData* data = [AvatarHelper getThumbnailForGroup:oldgroup.groupID];
                if (data) {
                    group.needToDownloadThumbnail = FALSE;
                    if (![AvatarHelper getAvatarForGroup:oldgroup.groupID])
                        group.needToDownloadPhoto = TRUE;
                    else
                        group.needToDownloadPhoto = FALSE;
                }
                else{
                    group.needToDownloadThumbnail = TRUE;
                    if (![AvatarHelper getAvatarForGroup:oldgroup.groupID])
                        group.needToDownloadPhoto = TRUE;
                    
                    else
                        group.needToDownloadPhoto = FALSE;
                }
            }
        }
    }
}

+(void)storeGroupInDatabase:(UserGroup*)group
{
    [UserGroup processGroupBeforeStorage:group];
    [Database storeFixedGroup:group];
}

-(void)dealloc
{
    self.introduction = nil;
    self.shortid = nil;
    self.createdPlace = nil;
    self.thumbnail_timestamp = nil;
    self.groupType = nil;
    [super dealloc];
}

@end
