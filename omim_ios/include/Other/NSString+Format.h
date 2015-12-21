//
//  NSString+Format.h
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)

/** 判断邮箱是否合法 */
- (BOOL)isEmail;

/** 判断短信验证码是否合法 */
- (BOOL)isSMSCode;

/** 判断电话号码是否合法 */
- (BOOL)isTelephone;


@end
