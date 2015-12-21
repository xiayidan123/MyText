//
//  Communicator_GetEventMembers.m
//  dev01
//
//  Created by 杨彬 on 15-1-3.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_GetEventMembers.h"
#import "EventApplyMemberModel.h"

@implementation Communicator_GetEventMembers


-(void)dealloc{
    [_event_id release];
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
    if (errNo == NO_ERROR)
    {
        
        NSMutableArray *eventApplyMemberDicArray = nil;
        id members = [[result objectForKey:XML_BODY_NAME] objectForKey:@"get_event_members"][@"member"];
        if (members){
            if ([members isKindOfClass:[NSArray class]]){
                eventApplyMemberDicArray = [[NSMutableArray alloc]initWithArray:(NSArray *)members];
            }else{
                eventApplyMemberDicArray = [[NSMutableArray alloc]init];
                [eventApplyMemberDicArray addObject:members];
            }
            for (int i=0; i<eventApplyMemberDicArray.count; i++){
                EventApplyMemberModel *eventApplyMembermodel = [[EventApplyMemberModel alloc]init];
                eventApplyMembermodel.event_id = [eventApplyMemberDicArray[i] objectForKey:@"event_id"];
                eventApplyMembermodel.member_id = [eventApplyMemberDicArray[i] objectForKey:@"member_id"];
                eventApplyMembermodel.nickname = [eventApplyMemberDicArray[i] objectForKey:@"nickname"];
                eventApplyMembermodel.status = [eventApplyMemberDicArray[i] objectForKey:@"status"];
                eventApplyMembermodel.upload_photo_timestamp = [eventApplyMemberDicArray[i] objectForKey:@"upload_photo_timestamp"];
                
                NSDictionary *info = [eventApplyMemberDicArray[i] objectForKey:@"info"];
                eventApplyMembermodel.real_name = info[@"real_name"];
                eventApplyMembermodel.telephone_number = info[@"telephone_number"];
                [Database storeEventApplyMembersWithModel:eventApplyMembermodel];
                [eventApplyMembermodel release];
            }
            [eventApplyMemberDicArray release];
        }else{
            [Database deleteEventApplyMembersWithEventID:_event_id];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
