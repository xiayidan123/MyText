//
//  OMClass.m
//  dev01
//
//  Created by 杨彬 on 15/3/20.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "OMClass.h"

@implementation OMClass


-(void)dealloc{
    [_start_day release];
    [_end_day release];
    [_start_time release];
    [_end_time release];
    [_short_class_id release];
    [_intro release];
    
    [_latitude release];
    [_longitude release];
    [_parent_id release];
    [_temp_group_flag release];
    [_thumbnail release];
    [_photo release];
    [_school_id release];
    
    [super dealloc];
}




- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.editable = [dic[@"editable"] boolValue];
        self.short_class_id = dic[@"short_group_id"];
        self.intro = dic[@"intro"];
        self.is_group_name_changed = [dic[@"is_group_name_changed"] boolValue];
        self.is_member = [dic[@"is_member"] boolValue];
        self.latitude = dic[@"latitude"];
        self.longitude = dic[@"longitude"];
        self.parent_id = dic[@"parent_id"];
        self.temp_group_flag = dic[@"temp_group_flag"];
        self.school_id = dic[@"school_id"];
        self.groupID = dic[@"group_id"];
        self.groupNameOriginal = dic[@"group_name"];
        
        NSDictionary *infoDic = dic[@"class_info"];
        self.start_day = infoDic[@"start_day"];
        self.start_time = infoDic[@"start_time"];
        self.end_day = infoDic[@"end_day"];
        self.end_time = infoDic[@"end_time"];
    }
    return self;
}


+ (instancetype)OMClassWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}







@end
