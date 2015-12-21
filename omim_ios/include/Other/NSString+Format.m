//
//  NSString+Format.m
//  dev01
//
//  Created by Starmoon on 15/7/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isSMSCode{
    NSString *code_Regex = @"^[0-9]{5}$";
    NSPredicate *code_Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", code_Regex];
    return [code_Test evaluateWithObject:self];
}

- (BOOL)isTelephone{
    NSString * MOBILE = @"^1(4[57]|7[0678]|3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    return res1 || res2 || res3 || res4;
}



@end
