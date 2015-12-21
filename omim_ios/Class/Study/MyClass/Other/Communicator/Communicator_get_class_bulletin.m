//
//  Communicator_get_class_bulletin.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_class_bulletin.h"

#import "Anonymous_Moment.h"

#import "OMDateBase_MyClass.h"

@implementation Communicator_get_class_bulletin


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    
    NSUInteger bulletion_count = 0;
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_class_bulletin"];
        
        id obj = infoDic[@"bulletin"];
        
        NSMutableArray *objArray = nil;
        
        if ([obj isKindOfClass:[NSArray class]]){
            objArray = [[NSMutableArray alloc]initWithArray:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            objArray = [[NSMutableArray alloc]init];
            [objArray addObject:obj];
        }
        
        for(NSDictionary *dic in objArray){
            Anonymous_Moment *moment = [[Anonymous_Moment alloc] initWithDict:dic];
            moment.anonymousType = 2;
            [OMDateBase_MyClass storeAnonymousMoment_bulletin:moment];
            [moment release];
        }
        [objArray release];
        
        
        id obj_moment = infoDic[@"moment"];
        
        NSMutableArray *obj_moment_array = nil;
        if ([obj_moment isKindOfClass:[NSArray class]]){
            obj_moment_array = [[NSMutableArray alloc]initWithArray:obj_moment];
        }else if ([obj_moment isKindOfClass:[NSDictionary class]]){
            obj_moment_array = [[NSMutableArray alloc]init];
            [obj_moment_array addObject:obj_moment];
        }
        
        for(NSDictionary *dic in obj_moment_array){
            Anonymous_Moment *moment = [[Anonymous_Moment alloc] initWithMomentDic:dic];
            moment.anonymousType = 2;
            [OMDateBase_MyClass storeAnonymousMoment:moment];
            [moment release];
        }
        
        bulletion_count = obj_moment_array.count;
        
        [obj_moment_array release];
        
        
    }
    
    [self networkTaskDidFinishWithReturningData:@(bulletion_count) error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
