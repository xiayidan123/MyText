//
//  Communicator_get_class_member.m
//  dev01
//
//  Created by 杨彬 on 15/4/2.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_class_member.h"

#import "OMDateBase_MyClass.h"
#import "OMNetWork_MyClass_Constant.h"

#import "SchoolMember.h"

@implementation Communicator_get_class_member


-(void)dealloc{
    self.class_id = nil;
    [super dealloc];
}


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    NSMutableDictionary *infoDic = nil;
    if (errNo == NO_ERROR)
    {
        NSString *acton_string = nil;
        id obj = nil;
        if (self.member_type == 1){//@"get_class_students"
            acton_string = MY_CLASS_GET_CLASS_STUDENT_LIST;
            infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:acton_string];
            obj = infoDic[@"student"];
            
        }else if (self.member_type == 2){//@"get_class_teachers";
            acton_string = MY_CLASS_GET_CLASS_TEACHER_LIST;
            infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:acton_string];
            obj = infoDic[@"teacher"];
        }else if (self.member_type == 0){
            acton_string = MY_CLASS_GET_CLASS_MEMBERS;
            infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:acton_string];
            obj = infoDic[@"member"];
        }
        
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:acton_string];
        
        [OMDateBase_MyClass deleteCLassMembersWithClass_id:self.class_id withMember_type:self.member_type];
        
        
        NSMutableArray *objArray = nil;
        
        if ([obj isKindOfClass:[NSArray class]]){
            objArray = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            objArray = [[NSMutableArray alloc]init];
            [objArray addObject:obj];
        }
        
        
        [OMDateBase_MyClass deleteCLassMembersWithClass_id:self.class_id withMember_type:self.member_type];
        
        for(NSDictionary *dic in objArray){
            SchoolMember *member = [[SchoolMember alloc]init];
            member.userID = dic[@"uid"];
            member.alias = dic[@"alias"];
            member.wowtalkID = dic[@"wowtalk_id"];
            member.nickName = dic[@"nickname"];
            member.photoUploadedTimeStamp = [dic[@"upload_photo_timestamp"] integerValue];
            member.userType = [dic[@"user_type"] integerValue];
            member.class_id = self.class_id;
//            member.userType = self.member_type;
            [OMDateBase_MyClass storeClassMember:member];
            [member release];
        }
        [objArray release];
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
