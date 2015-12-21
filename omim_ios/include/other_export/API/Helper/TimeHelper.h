//
//  DateHelper.h
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHelper : NSObject

+ (NSString *)getDayFromTime:(NSString *)originalTime;
+ (NSString *)getHourAndMinuteFromTime:(NSString *)originalTime;
+ (NSString *)getCurrentTime;
+ (NSString *)getTimeFromSeconds:(int)seconds;

+ (NSString *)dateToUTCString:(NSDate *)date;
+ (NSDate *)UTCStringToDate:(NSString *)utcString;
+ (NSString *)UTCStringToLocalString:(NSString *)string;

+(NSString*)timestamp2date:(double)timestamp;


+(NSString*)getHourAndMinuteFromtimestamp:(double)timestamp;
+(NSString*)getYearAndDayFromtimestamp:(double)timestamp;

+(NSString*) getReviewTimeFromtimestamp:(double)timestamp;

@end
