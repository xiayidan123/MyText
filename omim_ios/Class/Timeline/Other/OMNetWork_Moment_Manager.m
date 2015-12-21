//
//  OMNetWork_Moment_Manager.m
//  dev01
//
//  Created by 杨彬 on 15/5/21.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMNetWork_Moment_Manager.h"

#import "OMDatabase_moment.h"


@implementation OMNetWork_Moment_Manager

OMSingletonM(OMNetWork_Moment_Manager)

+ (BOOL)uploadMoment:(Moment *)moment {
    
    BOOL success = NO;
    
    success = [OMDatabase_moment store_NewMoment_bySelfUpload:moment withImage_array:nil];
    
    
    
    
    return success;
    
}




@end
