//
//  Communicator_add_class_bulletin.m
//  dev01
//
//  Created by 杨彬 on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_add_class_bulletin.h"
#import "OMNetWork_MyClass_Constant.h"
#import "Anonymous_Moment.h"

@implementation Communicator_add_class_bulletin

-(void)dealloc{
    self.class_array = nil;
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
    
//    NSMutableArray *bulletin_array = nil;
    if (errNo == NO_ERROR)
    {
//        id body = [result objectForKey:XML_BODY_NAME][MY_CLASS_ADD_CLASS_BULLETIN][@"bulletin"];
//
//        
//        if ([body isKindOfClass:[NSArray class]]){
//            bulletin_array = [NSMutableArray arrayWithArray:body];
//        }else if ([body isKindOfClass:[NSDictionary class]]){
//            bulletin_array = [NSMutableArray array];
//            [bulletin_array addObject:body];
//        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


@end
