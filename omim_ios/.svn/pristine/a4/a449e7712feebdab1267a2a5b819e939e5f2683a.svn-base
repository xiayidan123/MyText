//
//  NSDate+ClassScheduleDate.m
//  dev01
//
//  Created by 杨彬 on 15/1/18.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NSDate+ClassScheduleDate.h"

@implementation NSDate (ClassScheduleDate)


// input: NSTimeInterval  output:00:00 NSTimeInterval
+ (NSTimeInterval)ZeropointWihtTimeInterval:(NSTimeInterval )inputTimeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval outputTimeInterval = [[dateFormat dateFromString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:inputTimeInterval]]] timeIntervalSince1970];
    [dateFormat release];
    return outputTimeInterval;
}

// input: NSDate  output:00:00 NSTimeInterval
+ (NSTimeInterval)ZeropointWihtDate:(NSDate *)inputDate{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval outputTimeInterval = [[dateFormat dateFromString:[dateFormat stringFromDate:inputDate]] timeIntervalSince1970];
    [dateFormat release];
    return outputTimeInterval;
}


// input: DateStr  output:00:00 NSTimeInterval
+ (NSTimeInterval)ZeropointWihtDateString:(NSString *)inputDateStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval outputTimeInterval = [[dateFormat dateFromString:inputDateStr] timeIntervalSince1970];
    [dateFormat release];
    return outputTimeInterval;
}

// input: TimeIntervalStr  output:00:00 NSTimeInterval
+ (NSTimeInterval)ZeropointWihtTimeIntervalString:(NSString *)inputTimeIntervalStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval outputTimeInterval = [[dateFormat dateFromString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[inputTimeIntervalStr integerValue]]]] timeIntervalSince1970];
    [dateFormat release];
    return outputTimeInterval;
}


+ (NSTimeInterval)getTimeIntervalWithString:(NSString *)inputStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSDate *inputDate = [dateFormat dateFromString:inputStr];
    NSDate *zeroDate = [dateFormat dateFromString:@"00:00"];
    NSTimeInterval distanceTimeInterval = [inputDate timeIntervalSinceDate:zeroDate];
    [dateFormat release];
    return distanceTimeInterval;
}

+ (NSString *)getDateStringWithTimeInterval:(NSTimeInterval )dateTimeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateTimeInterval]];
    [dateFormat release];
    return dateString;
}

+ (NSString *)getTimeStringWithTimeInterval:(NSTimeInterval)timeTimeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeTimeInterval]];
    [dateFormat release];
    return timeString;
}

+ (NSString *)getClockStringWithTimeInterval:(NSTimeInterval)timeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSString *timeString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    [dateFormat release];
    
    return timeString;
}

@end
