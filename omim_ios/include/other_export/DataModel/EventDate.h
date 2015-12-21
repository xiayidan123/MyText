//
//  EventDate.h
//  dev01
//
//  Created by jianxd on 14-11-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDate : NSObject

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;
@property (nonatomic) NSInteger joinedNumber;
@property (nonatomic, getter = hasJoined) BOOL joined;

- (id)initWithDate:(NSString *)date time:(NSString *)time joinedNumber:(NSInteger)joinedNumber joined:(BOOL)joined;

- (id)initwithDictionary:(NSMutableDictionary *)dictionary;

- (NSDate *)getStartDate;

- (NSDate *)getEndDate;

- (NSString *)getMonthName;

- (BOOL)isOutOfDate;

@end
