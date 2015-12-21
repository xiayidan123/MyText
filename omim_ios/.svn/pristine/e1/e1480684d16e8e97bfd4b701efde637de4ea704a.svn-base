//
//  NSString+TextSize.m
//  dev01
//
//  Created by 杨彬 on 15/6/16.
//  Copyright © 2015年 wowtech. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

/**
 *  给字符串添加后缀 （判断后缀是否存在）
 *
 *  @param suffixString 后缀字符串
 *
 *  @return 返回拼接后的字符串
 */
- (NSString *)addSuffix:(NSString *)suffixString{
    if([self hasSuffix:suffixString]){
        return self;
    }else{
        return [NSString stringWithFormat:@"%@%@",self,suffixString];
    }
    
}


@end
