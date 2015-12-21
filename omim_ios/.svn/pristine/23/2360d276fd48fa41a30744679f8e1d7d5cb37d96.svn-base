//
//  NSDate+FATOUTPUT.m
//  dev01
//
//  Created by 杨彬 on 15/5/26.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NSDate+FATOUTPUT.h"

@implementation NSDate (FATOUTPUT)

+ (NSString *)standardFormat:(NSTimeInterval)timeInterval{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    [dateFormat release];
    return dateString;
}
+ (NSString *)standardAMPMFormat:(NSTimeInterval)timeInterval{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日 a h:mm"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    [dateFormat release];
    return dateString;
}
@end
