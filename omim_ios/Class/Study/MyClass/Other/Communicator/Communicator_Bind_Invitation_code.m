//
//  Communicator_Bind_Invitation_code.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_Bind_Invitation_code.h"

#import "OMDateBase_MyClass.h"

#import "Database.h"

#import "OMClass.h"

@implementation Communicator_Bind_Invitation_code

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
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"bind_with_invitation_code"];

        id obj = infoDic[@"class"];
        
        NSMutableArray *objArray = nil;

        if ([obj isKindOfClass:[NSArray class]]){
            objArray = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            objArray = [[NSMutableArray alloc]init];
            [objArray addObject:obj];
        }

        for(NSDictionary *dic in objArray){
            OMClass *classModel = [OMClass OMClassWithDic:dic[@"group_info"]];
            classModel.start_day = dic[@"start_day"];
            classModel.start_time = dic[@"start_time"];
            classModel.end_day = dic[@"end_day"];
            classModel.end_time = dic[@"end_time"];
            [OMDateBase_MyClass storeClassWithModel:classModel];
        }
        [objArray release];
        
        // 绑定要求码以后需要 讲本地数据库 活动列表里面的内容删除
        [Database deleteAllEventDetail];
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
