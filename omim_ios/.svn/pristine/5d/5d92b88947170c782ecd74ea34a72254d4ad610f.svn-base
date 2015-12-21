//
//  Communicator_GetAllMembersInGroup.m
//  omimbiz
//
//  Created by elvis on 2013/08/21.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetAllMembersInDepartment.h"

@implementation Communicator_GetAllMembersInDepartment


-(void)dealloc
{
    self.departmentid = nil;
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {         
            NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
            if (bodydict != nil && [bodydict objectForKey:WT_GET_MEMBERS_IN_DEPARTMENT] != nil)
            {
                NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_MEMBERS_IN_DEPARTMENT];
                NSMutableArray *buddyArray = [[NSMutableArray alloc] init];
                if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *buddydict = [infodict objectForKey:XML_BUDDY];
                    
                    BizMember* member = [[BizMember alloc] initWithDict:buddydict];
                    [buddyArray addObject:member];
                    [member release];
                }
                else if ([[infodict objectForKey:XML_BUDDY] isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *arr = [infodict objectForKey:XML_BUDDY];
                    for (NSMutableDictionary *buddydict in arr)
                    {
                        BizMember* member = [[BizMember alloc] initWithDict:buddydict];
                        [buddyArray addObject:member];
                        [member release];
                    }
                }
                
                if (buddyArray.count > 0){
                    [Database deleteBizMembersFromDepartment: self.departmentid];
                    [Database storeBizMembers:buddyArray toDepartment:self.departmentid];
                }
                
                [buddyArray release];
            }
    }
    
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}

@end
