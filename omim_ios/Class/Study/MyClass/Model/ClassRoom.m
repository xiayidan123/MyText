//
//  ClassRoom.m
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "ClassRoom.h"
#import "ClassRoomCamera.h"

@implementation ClassRoom

- (void)dealloc{
    [_classRoom_id release];
    [_room_name release];
    [_room_num release];
    [_school_id release];
    [_cameraArray release];

    [super dealloc];
}


- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.classRoom_id = dic[@"id"];
        self.camaraCount = dic[@"camaras"];
        self.has_camera = [dic[@"is_camera"] integerValue];
        self.has_multimedia = [dic[@"is_multimedia"] integerValue];
        self.room_name = dic[@"room_name"];
        self.room_num = dic[@"room_num"];
        self.school_id = dic[@"school_id"];
        self.studentCount = dic[@"students"];
        self.cameraArray = [self parseCameraWithObj:dic[@"cameras_detail"]];
        
        self.isSelected = NO;
    }
    return self;
}


- (NSMutableArray *)parseCameraWithObj:(id)body{
    if (body == nil)return nil;
    
    NSMutableArray *cameraArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *dicArray = nil;
    if ([body isKindOfClass:[NSArray class]]){
        dicArray = [[NSMutableArray alloc]initWithArray:body];
    }else{
        dicArray = [[NSMutableArray alloc]init];
        [dicArray addObject:body];
    }
    
    int count = (int)(dicArray.count);
    for (int i=0; i<count; i++){
        ClassRoomCamera *camera = [ClassRoomCamera ClassRoomCameraWithDic:dicArray[i]];
        [cameraArray addObject:camera];
    }
    [dicArray release];
    
    return [cameraArray autorelease];
}


+ (instancetype)ClassRoomWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}

@end
