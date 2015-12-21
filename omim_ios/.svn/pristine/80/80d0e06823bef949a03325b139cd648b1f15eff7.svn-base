//
//  DateHelper.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "TimeHelper.h"
#import "WTUserDefaults.h"
#import "NSDateFormatterGregorianCalendar.h"

static NSDateFormatter *msgDateFormatter = nil;

@implementation TimeHelper

#pragma mark -
#pragma mark time methods
+ (NSString *)getDayFromTime:(NSString *)originalTime
{
    if (msgDateFormatter == nil) {
//        msgDateFormatter = [[NSDateFormatter alloc] init];
        msgDateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
        [msgDateFormatter setLocale:[NSLocale currentLocale]];
        [msgDateFormatter setDateStyle:kCFDateFormatterFullStyle];
        [msgDateFormatter setTimeStyle:kCFDateFormatterNoStyle];
        
    }
    
    NSDate *date = [TimeHelper UTCStringToDate:originalTime];
    
    NSString *dateString = [msgDateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getHourAndMinuteFromTime:(NSString *)originalTime
{
    NSDate *date = [TimeHelper UTCStringToDate:originalTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit  fromDate:date];
    
    return [NSString stringWithFormat:@"%02zi:%02zi", [components hour], [components minute]];
}

+(NSString *)getCurrentTime
{
    NSString *strTimeOffset = [WTUserDefaults getTimeOffset];
    if(strTimeOffset != nil)
    {
        int timeOffset = [strTimeOffset intValue];
        int localTime = (int)[[NSDate date] timeIntervalSince1970];
        
        return [TimeHelper dateToUTCString:[NSDate dateWithTimeIntervalSince1970:(localTime + timeOffset)]];
    }
    else
        return [TimeHelper dateToUTCString:[NSDate date]]; //redefine the sentdate
}

+ (NSString *)dateToUTCString:(NSDate *)date
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}

+ (NSString *)getTimeFromSeconds:(int)seconds
{
    int minute = seconds/60;
    int second = seconds - minute *60;
    
    return [NSString stringWithFormat:@"%02d : %02d", minute, second];
}

+ (NSDate *)UTCStringToDate:(NSString *)utcString
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
	NSDate *date = [dateFormatter dateFromString:utcString];
    [dateFormatter release];
	return date;
}

+ (NSString *)UTCStringToLocalString:(NSString *)string
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] initWithGregorianCalendar];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
	NSDate *date = [dateFormatter dateFromString:string];
	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}



+(NSString*)timestamp2date:(double)timestamp{
  //  NSString * timeStampString =timestamp;
  //  NSTimeInterval _interval= [timeStampString doubleValue];
  //  NSTimeInterval _interval= timestamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *_formatter=[[[NSDateFormatter alloc] init] autorelease];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [_formatter stringFromDate:date];
}

+(NSString*)getHourAndMinuteFromtimestamp:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *_formatter=[[[NSDateFormatter alloc]init] autorelease];
    [_formatter setDateFormat:@"HH:mm"];
    return [_formatter stringFromDate:date];    
}

+(NSString*)getYearAndDayFromtimestamp:(double)timestamp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *_formatter=[[[NSDateFormatter alloc]init] autorelease];
    [_formatter setDateFormat:@"yyyy.MM.dd"];
    return [_formatter stringFromDate:date];
    
}


+(NSString*) getReviewTimeFromtimestamp:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *_formatter=[[[NSDateFormatter alloc]init] autorelease];
    [_formatter setDateFormat:@"MM-dd HH:mm"];
    return [_formatter stringFromDate:date];
}


@end
