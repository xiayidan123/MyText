//
//  Communicator_get_camera.m
//  dev01
//
//  Created by 杨彬 on 15/3/8.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_get_camera.h"
#import "ClassRoomCamera.h"

@implementation Communicator_get_camera


-(void)dealloc{
    
    [_portName release];
    [super dealloc];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableArray *cameraArray = [[NSMutableArray alloc]init];
    if (errNo == NO_ERROR)
    {
        id body = [result objectForKey:XML_BODY_NAME][_portName][@"camera"];
        NSMutableArray *cameraDicArray = nil;
        if ([body isKindOfClass:[NSDictionary class]]){
            cameraDicArray = [[NSMutableArray alloc]init];
            [cameraDicArray addObject:body];
        }else{
            cameraDicArray = [[NSMutableArray alloc]initWithArray:body];
        }
        
        int arrayCount = cameraDicArray.count;
        for (int i=0; i< arrayCount; i++){
            NSDictionary *dic = (NSDictionary *)cameraDicArray[i];
            ClassRoomCamera *classRoomCamera = [ClassRoomCamera ClassRoomCameraWithDic:dic];
            //            classRoom.isSelected = (i == 0 ? YES : NO);
            [cameraArray addObject:classRoomCamera];
        }
        [cameraDicArray release];
    }
    
    [self networkTaskDidFinishWithReturningData:[cameraArray autorelease] error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
