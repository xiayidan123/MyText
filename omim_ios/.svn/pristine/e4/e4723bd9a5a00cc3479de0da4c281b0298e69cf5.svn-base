//
//  Department.m
//  dev01
//
//  Created by elvis on 2013/08/22.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Department.h"
#import "WowtalkXMLParser.h"

@implementation Department


-(id) initWithDict:(NSMutableDictionary*)dict
{
    if (dict == nil) {
        return nil;
    }
    
    return  [self initWithID:[dict objectForKey:XML_GROUP_ID_KEY] withGroupNameOriginal:[dict objectForKey:XML_GROUP_NAME_KEY] withGroupNameLocal:[dict objectForKey:XML_GROUP_NAME_KEY] withGroupStatus:[dict objectForKey:XML_GROUP_STATUS_KEY] withMaxNumber:[dict objectForKey:XML_GROUP_MAXMEMBER_COUNT_KEY] withMemberCount:[dict objectForKey:XML_GROUP_MEMBER_COUNT_KEY] withLaitude:[[dict objectForKey:XML_GROUP_LATITUDE] doubleValue] withLongitude:[[dict objectForKey:XML_GROUP_LONGITUDE] doubleValue] withPlace:[dict objectForKey:XML_GROUP_PLACE] withType:[dict objectForKey:XML_GROUP_TYPE] withShortid:[dict objectForKey:XML_GROUP_SHORT_ID] withIntroduction:[dict objectForKey:XML_GROUP_INTRO] withParentID:[dict objectForKey:XML_GROUP_PARENT_ID_KEY] withisHeadNode:[dict objectForKey:XML_GROUP_EDITABLE] withGroupnameChanged:[dict objectForKey:XML_GROUP_NAME_CHANGED_KEY] withLevel:[dict objectForKey:XML_GROUP_LEVEL_KEY] withWeight:[[dict objectForKey:XML_GROUP_WEIGHT] doubleValue]];
    
}

-(id) initWithID:(NSString*)_groupID withGroupNameOriginal:(NSString*)_groupNameOriginal withGroupNameLocal:(NSString*)_groupNameLocal withGroupStatus:(NSString*)_groupStatus withMaxNumber:(NSString*)_maxNumber withMemberCount:(NSString*)_memberCount withLaitude:(double)latitude withLongitude:(double)longtitude withPlace:(NSString*)placename withType:(NSString*)grouptype withShortid:(NSString*) shortid withIntroduction:(NSString*)intro withParentID:(NSString*)parent_id withisHeadNode:(NSString*)iseditable withGroupnameChanged:(NSString*)isGroupnameChanged withLevel:(NSString*)level withWeight:(double)weight;
{
    self = [super initWithID:_groupID withGroupNameOriginal:_groupNameOriginal withGroupNameLocal:_groupNameLocal withGroupStatus:groupStatus withMaxNumber:_maxNumber withMemberCount:_memberCount withLaitude:latitude withLongitude:longtitude withPlace:placename withType:grouptype withShortid:shortid withIntroduction:intro];
    if (self) {
        self.parent_id = parent_id;
        self.isHeadNode = [iseditable isEqualToString:@"1"]? TRUE:FALSE;
        self.isGroupnameChanged = [isGroupnameChanged isEqualToString:@"1"]? TRUE: FALSE;
        self.level = [level intValue];
        self.weight = weight;
        
    }
    
    return self;
    
    
}


+(void)processDepartmentBeforeStorage:(Department*)department
{
    [super processGroupBeforeStorage:department];
}


-(void)dealloc
{
    self.parent_id = nil;
    [super dealloc];
}


@end
