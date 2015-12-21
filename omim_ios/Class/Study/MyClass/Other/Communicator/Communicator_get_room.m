//
//  Communicator_get_room.m
//  dev01
//
//  Created by 杨彬 on 15/3/6.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_room.h"
#import "ClassRoom.h"

@implementation Communicator_get_room

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    
    NSMutableArray *roomArray = [[NSMutableArray alloc]init];
    if (errNo == NO_ERROR)
    {
        id body = [result objectForKey:XML_BODY_NAME][WT_GET_SCHOOL_LESSON_ROOM][@"room"];
        NSMutableArray *roomDicArray = nil;
        if ([body isKindOfClass:[NSDictionary class]]){
            roomDicArray = [[NSMutableArray alloc]init];
            [roomDicArray addObject:body];
        }else{
            roomDicArray = [[NSMutableArray alloc]initWithArray:body];
        }
        
        
        int arrayCount = roomDicArray.count;
        for (int i=0; i< arrayCount; i++){
            NSDictionary *dic = (NSDictionary *)roomDicArray[i];
            ClassRoom *classRoom = [ClassRoom ClassRoomWithDic:dic];
//            classRoom.isSelected = (i == 0 ? YES : NO);
            [roomArray addObject:classRoom];
        }
        [roomDicArray release];
    }
    
    [self networkTaskDidFinishWithReturningData:[roomArray autorelease] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
