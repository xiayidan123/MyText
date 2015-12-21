//
//  ActivityModel.h
//  dev01
//
//  Created by 杨彬 on 14-10-24.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject


typedef NS_ENUM(NSInteger, ApplyStateOfEvent) {
    AllEvents,
    ApplyedEvents,
    ReleaseByMyselfEvents
};


typedef NS_ENUM(NSInteger, EventState) {
    UNStartOfEventState,
    DoingOfEventState,
    EndedOfEventState
};

@property (nonatomic,copy)NSString *event_id;
@property (nonatomic,copy)NSString *owner_id;
@property (nonatomic,copy)NSString *owner_name;
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,copy)NSString *category;
@property (nonatomic,copy)NSString *insert_timestamp;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *max_member;
@property (nonatomic,copy)NSString *member_count;
@property (nonatomic,copy)NSString *text_title;
@property (nonatomic,copy)NSString *text_content;
@property (nonatomic,copy)NSString *coin;
@property (nonatomic,copy)NSString *date_type;
@property (nonatomic,copy)NSString *date_info;
@property (nonatomic,copy)NSString *classification;
@property (nonatomic,copy)NSString *is_get_member_info;
@property (nonatomic,copy)NSString *is_open;
@property (nonatomic,copy)NSString *start_timestamp;
@property (nonatomic,copy)NSString *end_timestamp;
@property (nonatomic,copy)NSString *is_joined;

@property (retain, nonatomic) NSMutableArray *mediaArray;


- (instancetype)initWithDic:(NSMutableDictionary *)dic;


@end
