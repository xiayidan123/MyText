//
//  VersionHelper.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "VersionHelper.h"
#import "GlobalSetting.h"

@implementation VersionHelper

+ (int)getCurrentServerSDKVersionFromLocal
{
    return SDK_SERVER_VERSION;
}

+ (int)getCurrentClientSDKVersionFromLocal
{
    return SDK_CLIENT_VERSION;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

@end
