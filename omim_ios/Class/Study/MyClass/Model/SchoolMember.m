//
//  SchoolMember.m
//  dev01
//
//  Created by 杨彬 on 15/3/25.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SchoolMember.h"
#import "PersonModel.h"

@implementation SchoolMember

-(void)dealloc{
    [_class_id release];
    [super dealloc];
}



- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.class_id = dic[@"class_id"];
        self.userID = dic[@"uid"];
        self.nickName = dic[@"nickName"];
        self.status = dic[@"last_status"];
        self.sexFlag = [dic[@"sex"] integerValue];
        self.deviceNumber = dic[@"device_number"];
        self.appVer = dic[@"app_ver"];
        self.alias = dic[@"alias"];
        self.photoUploadedTimeStamp = [dic[@"upload_photo_timestamp"] integerValue];
        self.pathOfPhoto = dic[@"photo_filepath"];
        self.pathOfThumbNail = dic[@"group_id"];
        self.userType = dic[@"user_type"];
        self.state = dic[@"state"];
        self.homework_state = [dic[@"state"] integerValue];
        self.schoolName = dic[@"name"];
        self.homework_result_id = dic[@"homework_result_id"];
    }
    return self;
}


+ (instancetype)SchoolMemberWithDic:(NSDictionary *)dic{
    return [[[[self class] alloc] initWithDict:dic] autorelease];
}



@end
