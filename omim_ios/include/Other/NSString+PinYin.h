//
//  NSString+PinYin.h
//  dev01
//
//  Created by Starmoon on 15/7/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYin)

/** 返回第一个字首字母 */
- (NSString *)firstCharactor;

/** 返回全部拼音 */
- (NSString *)AllCharactor;


@end
