//
//  DeviceHelper.h
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

+ (BOOL)isIphone5;
+ (BOOL)isMyDeviceSupportingVideoCall;
+ (BOOL)isDeviceSupportingVideoCall:(NSString*)deviceNumber;


@end
