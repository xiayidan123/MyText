//
//  Communicator_GetSchoolList.m
//  dev01
//
//  Created by 杨彬 on 14-12-15.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetSchoolList.h"
#import "SchoolModel.h"

@implementation Communicator_GetSchoolList


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
        [Database deleteMySchool];
        [Database deleteMyClass];
        
        infoDic = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_school_user_in"];
        
        NSMutableArray *dicArray = nil;
        if ([[infoDic objectForKey:@"school"] isKindOfClass:[NSMutableArray class]]) {
            dicArray = [[NSMutableArray alloc]initWithArray:[infoDic objectForKey:@"school"]];
        } else if ([[infoDic objectForKey:@"school"] isKindOfClass:[NSMutableDictionary class]]) {
            dicArray = [[NSMutableArray alloc]init];
            [dicArray addObject:[infoDic objectForKey:@"school"]];
        }
        
        [Database deleteMySchool];
        
        for (NSDictionary *schoolDic in dicArray){
            SchoolModel *school = [[SchoolModel alloc]initWithDic:schoolDic];
            [Database storeSchoolWithModel:school];
            [school release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
