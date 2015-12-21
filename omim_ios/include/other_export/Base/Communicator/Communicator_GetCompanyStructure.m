//
//  Communicator_GetCompanyStructure.m
//  omimbiz
//
//  Created by elvis on 2013/08/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetCompanyStructure.h"

@implementation Communicator_GetCompanyStructure
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableArray *arrays = [[[NSMutableArray alloc] init] autorelease];
    
    if (errNo == NO_ERROR) {
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_COMPANY_STRUCTURE];
        if ([[infodict objectForKey:XML_GROUP] isKindOfClass:[NSMutableDictionary class]])
        {
            NSMutableDictionary *groupdict = [infodict objectForKey:XML_GROUP];
            Department* department = [[Department alloc] initWithDict:groupdict];
            
            NSString* timestamp = [groupdict objectForKey:XML_GROUP_TIMESTAMP];
            
            department.thumbnail_timestamp = timestamp;
            
            [Department processDepartmentBeforeStorage:department];
            
            [arrays addObject:department];
            [department release];
        }
        else if ([[infodict objectForKey:XML_GROUP] isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *arr = [infodict objectForKey:XML_GROUP];
            for (NSMutableDictionary *groupdict in arr)
            {
                Department* department = [[Department alloc] initWithDict:groupdict];
                
                NSString* timestamp = [groupdict objectForKey:XML_GROUP_TIMESTAMP];
                
                department.thumbnail_timestamp = timestamp;
                
                [Department processDepartmentBeforeStorage:department];
                
                [arrays addObject:department];
                [department release];
            }
        }
        
    }
    
    if ([arrays count] == 0) {
        arrays = nil;
    }
    else{
        
        [Database deleteAllDepartments]; // Notice: do not delete the department members locally.
        for(Department* department in arrays)
            [Database storeDepartment:department];
    }
    
    [self networkTaskDidFinishWithReturningData:arrays error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}

@end
