//
//  NSString+PinYin.m
//  dev01
//
//  Created by Starmoon on 15/7/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NSString+PinYin.h"

@implementation NSString (PinYin)

- (NSString *)firstCharactor
{
    return [[self AllCharactor]substringToIndex:1];
}

/** 返回全部拼音 */
- (NSString *)AllCharactor{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    return [str capitalizedString];
}

@end
