//
//  Communicator_GetMomentByMomentID.m
//  dev01
//
//  Created by 杨彬 on 15-1-1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "Communicator_GetMomentByMomentID.h"
#import "Moment.h"

@implementation Communicator_GetMomentByMomentID

-(void)handleMoment:(NSMutableDictionary*)momentDict
{
    Moment *moment = [[Moment alloc] initWithDict:momentDict];
    [Database storeMoment:moment];
    [moment release];
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
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:@"get_moment_by_id"];
        if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary* momentDict = [infodict objectForKey:XML_MOMENT_KEY];
            [self handleMoment:momentDict];
        }
        else if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableArray class]]){
            NSMutableArray *momentsArray = [infodict objectForKey:XML_MOMENT_KEY];
            
            for (NSMutableDictionary *momentDict in momentsArray){
                [self handleMoment:momentDict];
            }
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

@end
