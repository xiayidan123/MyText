//
//  DeviceHelper.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "DeviceHelper.h"
#import "UISize.h"
#import "Database.h"

@implementation DeviceHelper

+ (BOOL)isIphone5
{
    if ([UISize screenHeight] > 480)
        return YES;
    else
        return NO;
}

+ (BOOL)isMyDeviceSupportingVideoCall
{
    return [Database isDeviceNumberSupportedForVideoCall:[NSString stringWithFormat:@"iOS%@", [[UIDevice currentDevice] systemVersion]]];
}

+ (BOOL)isDeviceSupportingVideoCall:(NSString*)deviceNumber
{
    return [Database isDeviceNumberSupportedForVideoCall:deviceNumber];
}


@end
