//
//  Communicator_release_room.m
//  dev01
//
//  Created by 杨彬 on 15/3/10.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_release_room.h"
#import "ReleaseClassRoomModel.h"
@implementation Communicator_release_room

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];

    NSMutableArray *releaseClassRoomArray = [[NSMutableArray alloc]init];
    if (errNo == NO_ERROR)
    {
        id body = [result objectForKey:XML_BODY_NAME][WT_RELEASE_SCHOOL_LESSON_ROOM];
        NSMutableArray *releaseClassRoomDicArray = nil;
        if ([body isKindOfClass:[NSDictionary class]]){
            releaseClassRoomDicArray = [[NSMutableArray alloc]init];
            [releaseClassRoomDicArray addObject:body];
        }else{
            releaseClassRoomDicArray = [[NSMutableArray alloc]initWithArray:body];
        }
        
        
        int arrayCount = releaseClassRoomDicArray.count;
        for (int i=0; i< arrayCount; i++){
            NSDictionary *dic = (NSDictionary *)releaseClassRoomDicArray[i];
            ReleaseClassRoomModel *releaseClassRoomModel = [ReleaseClassRoomModel ReleaseClassRoomModelWithDic:dic];
            [releaseClassRoomArray addObject:releaseClassRoomModel];
        }
        [releaseClassRoomDicArray release];
        
    }
    
    [self networkTaskDidFinishWithReturningData:[releaseClassRoomArray autorelease] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
