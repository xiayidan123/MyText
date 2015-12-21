//
//  NSDate+FromCurrentTime.m
//  dev01
//
//  Created by 杨彬 on 15/4/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NSDate+FromCurrentTime.h"
#import "Database.h"
@implementation NSDate (FromCurrentTime)

+ (NSString *)formatTimeWithTimeInterval:(NSTimeInterval )timeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];
    NSString *date_string = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    [dateFormat release];
    return date_string;
}


+ (NSString *)getTimeFromTheCurrentTime:(NSTimeInterval )gone_Time{
    
    NSTimeInterval now_time = [[NSDate date] timeIntervalSince1970];
    
    int gap = ((int)now_time) - ((int)gone_Time);
    
    int minute_Integer = gap / 60;
    int hour_Integer = gap / (60 * 60);
    int day_Integer = gap / (60 * 60 * 24);
    
    if ( minute_Integer < 1){
        return @"1分钟前";
    }else if (hour_Integer < 1){
        return [NSString stringWithFormat:@"%d分钟前",minute_Integer];
    }else if (day_Integer < 1){
        return [NSString stringWithFormat:@"%d小时前",hour_Integer];
    }else if (day_Integer == 1){
        return @"昨天";
    }else if (day_Integer == 2){
        return @"前天";
    }else if (day_Integer < 7){
        return [NSString stringWithFormat:@"%d天前",day_Integer];
    }else{
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *date_string = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:gone_Time]];
        return date_string;
    }
}


+ (NSString *)TimeFromTodayInMessageListVC:(NSString *)sentDate{
    NSDate* date= [Database chatMessage_UTCStringToDate:sentDate];
    NSDateComponents *components = [self getDateComponentsFromDate:date];
    if ([date compare:[self today]] != NSOrderedAscending) {

        return [NSString stringWithFormat: @"%02ld:%02ld", (long)[components hour],(long)[components minute]];

    }else{
        if ([date compare:[self sevenDaysAgo]] != NSOrderedAscending) {
            return [NSString stringWithFormat:@"Weekday%ld",(long)[components weekday]];

        }else{
            return [NSString stringWithFormat: @"%ld/%ld/%ld", (long)[components year],(long)[components month],(long)[components day]];

        }
    }
}

+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    return [gregorian components:(NSHourCalendarUnit |
                                       NSMinuteCalendarUnit |
                                       NSSecondCalendarUnit |
                                       NSDayCalendarUnit |
                                       NSWeekdayCalendarUnit |
                                       NSMonthCalendarUnit |
                                       NSYearCalendarUnit) fromDate:date];
}

+ (NSDate *)today{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *todayComponents = [self getDateComponentsFromDate:[NSDate date]];
    [todayComponents setHour:0];
    [todayComponents setMinute:0];
    [todayComponents setSecond:0];
    return [gregorian dateFromComponents:todayComponents];
}

+ (NSDate *)sevenDaysAgo{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *minusComponents = [[[NSDateComponents alloc] init] autorelease];
    [minusComponents setDay:-7];
    return [gregorian dateByAddingComponents:minusComponents toDate:[self today] options:0];
}
@end
