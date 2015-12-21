//
//  NSDateFormatterGregorianCalendar.m
//  omimLibrary_test
//
//  Created by coca on 14-6-24.
//
//
#import "NSDateFormatterGregorianCalendar.h"


@implementation NSDateFormatter (GregorianCalendar)

- (id)initWithGregorianCalendar {
    self = [self init];
    if (self){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self setLocale:[NSLocale systemLocale]];
        [self setTimeZone:[NSTimeZone systemTimeZone]];
        [self setCalendar:calendar];
    }
    return self;
}

@end