//
//  EventDate.m
//  dev01
//
//  Created by jianxd on 14-11-28.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "EventDate.h"

@implementation EventDate

@synthesize date = _date;
@synthesize time = _time;
@synthesize joinedNumber = _joinedNumber;
@synthesize joined = _joined;

- (id)initWithDate:(NSString *)date time:(NSString *)time joinedNumber:(NSInteger)joinedNumber joined:(BOOL)joined
{
    if (self = [super init]) {
        self.date = date;
        self.time = time;
        self.joinedNumber = joinedNumber;
        self.joined = joined;
    }
    return self;
}

- (id)initwithDictionary:(NSMutableDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    
    return [self initWithDate:[dictionary objectForKey:@"date"]
                         time:[dictionary objectForKey:@"time"]
                 joinedNumber:[[dictionary objectForKey:@"joined_number"] integerValue]
                       joined:[[dictionary objectForKey:@"is_join"] boolValue]];
}

- (NSDate *)getStartDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm"];
    NSString *startTime = [self.date stringByAppendingString:[self.time substringWithRange:NSMakeRange(0, 5)]];
    NSDate *date = [formatter dateFromString:startTime];
    [formatter release];
    return date;
}

- (NSDate *)getEndDate
{
    if ([self.time length] > 5) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-ddHH:mm"];
        NSString *endTime = [self.date stringByAppendingString:[self.time substringWithRange:NSMakeRange(6, 5)]];
        return [formatter dateFromString:endTime];
    } else {
        return [self getStartDate];
    }
}

- (NSString *)getMonthName
{
    NSInteger month = [[_date substringWithRange:NSMakeRange(5, 2)] integerValue];
    switch (month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return @"";
            break;
    }
}

- (BOOL)isOutOfDate
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm"];
    NSDate *aDate = [formatter dateFromString:[self.date stringByAppendingString:[self.time substringWithRange:NSMakeRange(0, 5)]]];
    NSComparisonResult result = [aDate compare:nowDate];
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc
{
    [_date release];
    [_time release];
    [super dealloc];
}

@end
