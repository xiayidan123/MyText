//
//  Activity.h
//  omim
//
//  Created by coca on 14-4-19.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@class EventDate;

@interface Activity : NSObject
{
    
}

@property (copy, nonatomic) NSString *eventId;
@property (nonatomic) long insertTimestamp;
@property (nonatomic) NSInteger maxMemberNumber;
@property (copy, nonatomic) NSString *ownerId;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (nonatomic) NSInteger coin;
@property (nonatomic) NSInteger dateType;
@property (copy, nonatomic) NSString *dateInfo;
@property (copy, nonatomic) NSString *classification;
@property (copy, nonatomic) NSString *telephone;
@property (nonatomic) BOOL getMemberInfo;
@property (copy, nonatomic) NSString *memberInfoList;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *thumbnailId;
@property (copy, nonatomic) NSString *thumbnailPath;
@property (nonatomic) BOOL memberJoinable;
@property (copy, nonatomic) NSString *memberInfo;

@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *insertTime;

@property (retain, nonatomic) NSMutableArray *mediaArray;
@property (retain, nonatomic) NSMutableArray *dateArray;

@property (copy, nonatomic) NSString *currencyUnit;

- (id)initWithDict:(NSMutableDictionary *)dict;

- (id)initwithID:(NSString *)eventId insertTime:(long)insertTimestamp maxMember:(NSInteger)maxMember ownerId:(NSString *)ownerId latitude:(double)latitude longitude:(double)longitude area:(NSString *)area title:(NSString *)title content:(NSString *)content coin:(NSInteger)coin dateType:(NSInteger)dateType dateInfo:(NSString *)dateInfo classification:(NSString *)classificaton telephone:(NSString *)telephone getMemberInfo:(BOOL)getMemberInfo memberInfoList:(NSString *)memberInfoList nickname:(NSString *)nickname thumbnailId:(NSString *)thumbnailId thumbnailPath:(NSString *)thumbnailPath memberJoinable:(BOOL)memberJoinable memberInfo:(NSString *)memberInfo startTime:(NSString *)startTime insertTime:(NSString *)insertTime currencyUnit:(NSString *)unit;

- (EventDate *)getNextEventTime;
- (NSUInteger)getNextEventTimeIndex;

@end
