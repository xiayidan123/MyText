//
//  Activity.m
//  omim
//
//  Created by coca on 14-4-19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//


#import "Activity.h"
#import "WTFile.h"
#import "Review.h"
#import "EventDate.h"
@implementation Activity
@synthesize eventId = _eventId;
@synthesize insertTimestamp = _insertTimestamp;
@synthesize maxMemberNumber = _maxMemberNumber;
@synthesize ownerId = _ownerId;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize area = _area;
@synthesize title = _title;
@synthesize content = _content;
@synthesize coin = _coin;
@synthesize dateType = _dateType;
@synthesize dateInfo = _dateInfo;
@synthesize classification = _classification;
@synthesize telephone = _telephone;
@synthesize getMemberInfo = _getMemberInfo;
@synthesize memberInfoList = _memberInfoList;
@synthesize nickname = _nickname;
@synthesize thumbnailId =_thumbnailId;
@synthesize thumbnailPath = _thumbnailPath;
@synthesize memberJoinable = _memberJoinable;
@synthesize memberInfo = _memberInfo;

@synthesize startTime = _startTime;
@synthesize insertTime = _insertTime;

@synthesize mediaArray = _mediaArray;
@synthesize dateArray = _dateArray;
@synthesize currencyUnit = _currencyUnit;

//    "get_all_events" =         {
//        event =             (
//                             {
//                                 area = " \U4e0a\U6d77  \U9ec4\U6d66\U533a  Fortune Cookie ";
//                                 classification = 1;
//                                 coin = 0;
//                                 "date_info" = "{\"date\":\"2014-11-01\",\"start_time\":\"20:30\",\"end_time\":\"23:30\"}";
//                                 "date_type" = 0;
//                                 "end_timestamp" = 1414884600;
//                                 "event_id" = 2;
//                                 "insert_timestamp" = 1414419690;
//                                 "is_get_member_info" = 0;
//                                 "is_open" = 1;
//                                 latitude = "-1";
//                                 longitude = "-1";
//                                 "max_member" = 0;
//                                 "member_count" = 2;
//                                 "owner_id" = "8a0dc925-b22a-4d6b-8b9f-ecc7159dda14";
//                                 "owner_name" = wdd;
//                                 "start_timestamp" = 1414873800;
//                                 tag = 0;
//                                 "text_content" = "2014\U4 ";
//                             }

- (id)initWithDict:(NSMutableDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    self = [self initwithID:[dict objectForKey:@"event_id"]
                 insertTime:[(NSString *)[dict objectForKey:@"insert_timestamp"] longLongValue]
                  maxMember:[[dict objectForKey:@"max_member"] intValue]
                    ownerId:[dict objectForKey:@"owner_id"]
                   latitude:[[dict objectForKey:@"latitude"] doubleValue]
                  longitude:[[dict objectForKey:@"longitude"] doubleValue]
                       area:[dict objectForKey:@"area"]
                      title:[dict objectForKey:@"text_title"]
                    content:[dict objectForKey:@"text_content"]
                       coin:[[dict objectForKey:@"coin"] intValue]
                   dateType:[[dict objectForKey:@"date_type"] integerValue]
                   dateInfo:[dict objectForKey:@"date_info"]
             classification:[dict objectForKey:@"classification"]
                  telephone:[dict objectForKey:@"telephone"]
              getMemberInfo:[(NSString *)[dict objectForKey:@"is_get_member_info"] isEqualToString:@"0"] ? NO : YES
             memberInfoList:[dict objectForKey:@"member_info_list"]
                   nickname:[dict objectForKey:@"nickname"]
                thumbnailId:[dict objectForKey:@"thumbnail"]
              thumbnailPath:@""
             memberJoinable:[(NSString *)[dict objectForKey:@"is_member_join"] isEqualToString:@"0"] ? NO : YES
                 memberInfo:[dict objectForKey:@"member_info"]
                  startTime:[dict objectForKey:@"start_time"]
                 insertTime:[dict objectForKey:@"insert_time"]
               currencyUnit:[dict objectForKey:@"currency_unit"]];
    
    if ([dict objectForKey:@"multimedia_set"]) {
        if ([[[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *mediaDict in [[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"]) {
                WTFile* wtfile = [[[WTFile alloc] initWithDict:mediaDict] autorelease];
                [self.mediaArray addObject:wtfile];
            }
        } else if ([[dict objectForKey:@"multimedia_set"] isKindOfClass:[NSMutableDictionary class]]) {
            WTFile* wtfile = [[[WTFile alloc] initWithDict:[[dict objectForKey:@"multimedia_set"] objectForKey:@"multimedia"]] autorelease];
            [self.mediaArray addObject:wtfile];
        }
    }
    
    if ([dict objectForKey:@"date_list"]) {
        if ([[[dict objectForKey:@"date_list"] objectForKey:@"info"] isKindOfClass:[NSMutableArray class]]) {
            for (NSMutableDictionary *infoDict in [[dict objectForKey:@"date_list"] objectForKey:@"info"]) {
                EventDate *date = [[EventDate alloc] initwithDictionary:infoDict];
                [self.dateArray addObject:date];
                [date release];
            }
        } else if ([[dict objectForKey:@"date_list"] isKindOfClass:[NSMutableDictionary class]]) {
            EventDate *date = [[EventDate alloc] initwithDictionary:[[dict objectForKey:@"date_list"] objectForKey:@"info"]];
            [self.dateArray addObject:date];
            [date release];
        }
    }
    
    return self;
}

- (id)initwithID:(NSString *)eventId insertTime:(long)insertTimestamp maxMember:(NSInteger)maxMember ownerId:(NSString *)ownerId latitude:(double)latitude longitude:(double)longitude area:(NSString *)area title:(NSString *)title content:(NSString *)content coin:(NSInteger)coin dateType:(NSInteger)dateType dateInfo:(NSString *)dateInfo classification:(NSString *)classificaton telephone:(NSString *)telephone getMemberInfo:(BOOL)getMemberInfo memberInfoList:(NSString *)memberInfoList nickname:(NSString *)nickname thumbnailId:(NSString *)thumbnailId thumbnailPath:(NSString *)thumbnailPath memberJoinable:(BOOL)memberJoinable memberInfo:(NSString *)memberInfo startTime:(NSString *)startTime insertTime:(NSString *)insertTime currencyUnit:(NSString *)unit
{
    self.mediaArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    if (self = [super init]) {
        self.eventId = eventId;
        self.insertTimestamp = insertTimestamp;
        self.maxMemberNumber = maxMember;
        self.ownerId = ownerId;
        self.latitude = latitude;
        self.longitude = longitude;
        self.area = area;
        self.title = title;
        self.content = content;
        self.coin = coin;
        self.dateType = dateType;
        self.dateInfo = dateInfo;
        self.classification = classificaton;
        self.telephone = telephone;
        self.getMemberInfo = getMemberInfo;
        self.memberInfoList = memberInfoList;
        self.nickname = nickname;
        self.thumbnailId = thumbnailId;
        self.thumbnailPath = thumbnailPath;
        self.memberJoinable = memberJoinable;
        self.memberInfo = memberInfo;
        self.startTime = startTime;
        self.insertTime = insertTime;
        self.currencyUnit = unit;
    }
    return self;
}

- (EventDate *)getNextEventTime
{
    NSDate *nowDate = [NSDate date];
    for (EventDate *date in self.dateArray) {
        
        NSDate *eventDate = [date getStartDate];
        if ([eventDate compare:nowDate] == NSOrderedDescending) {
            return date;
        }
    }
    return [self.dateArray objectAtIndex:0];
}

- (NSUInteger)getNextEventTimeIndex
{
    // consider the date to be ordered.
    NSDate *nowDate = [NSDate date];
    for (int i = 0; i < [self.dateArray count]; i++) {
        NSDate *eventDate = [[self.dateArray objectAtIndex:i] getStartDate];
        if ([eventDate compare:nowDate] == NSOrderedDescending) {
            return i;
        }
    }
    return 0;
}


-(void)dealloc
{
    [_eventId release];
    [_ownerId release];
    [_area release];
    [_title release];
    [_content release];
    [_dateInfo release];
    [_classification release];
    [_telephone release];
    [_memberInfoList release];
    [_nickname release];
    [_thumbnailId release];
    [_thumbnailPath release];
    [_memberInfo release];
    [_startTime release];
    [_insertTime release];
    [_mediaArray release];
    [_dateArray release];
    [super dealloc];
    
}



@end
