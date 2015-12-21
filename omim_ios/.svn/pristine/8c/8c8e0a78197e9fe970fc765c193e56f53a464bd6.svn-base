//
//  Communicator_GetClassList.m
//  dev01
//
//  Created by 杨彬 on 14-12-15.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetClassList.h"
#import "ClassModel.h"
#import "OMClass.h"
#import "OMDateBase_MyClass.h"


@implementation Communicator_GetClassList

-(void)dealloc{
    [_school_id release];
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
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_classroom_user_in"];
        
        id obj = infoDic[@"group"];
        
        NSMutableArray *objArray = nil;
        
        if ([obj isKindOfClass:[NSArray class]]){
            objArray = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            objArray = [[NSMutableArray alloc]init];
            [objArray addObject:obj];
        }
        
        if (self.school_id.length == 0){
            [OMDateBase_MyClass deleteMyClass];
        }else{
            [OMDateBase_MyClass deleteMyClassWithSchool_id:self.school_id];
        }
        
        
        for(NSDictionary *dic in objArray){
            OMClass *classModel = [[OMClass alloc] initWithDict:dic];
            [OMDateBase_MyClass storeClassWithModel:classModel];
            [classModel release];
        }
        
        [objArray release];
        
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
