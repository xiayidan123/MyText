//
//  NSString+Compare.m
//  wowcard
//
//  Created by coca on 12/06/06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)

+(BOOL)isEmptyString:(NSString *)string
// Returns YES if the string is nil or equal to @""
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
//    NSLog(@"%@",string);
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;  
}

@end
