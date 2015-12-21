//
//  Communicator_GetMomentForAll.m
//  yuanqutong
//
//  Created by coca on 13-4-20.
//  Copyright (c) 2013年 wowtech. All rights reserved.
//

#import "Communicator_GetMomentForAll.h"
#import "Moment.h"
@implementation Communicator_GetMomentForAll

-(void)handleMoment:(NSMutableDictionary*)momentDict
{
    Moment *moment = [[Moment alloc] initWithDict:momentDict];
    [Database storeMoment:moment];
    [moment release];
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    int count = 0;
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_MOMENT_FOR_ALL_BUDDYS_KEY];
        if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary* momentDict = [infodict objectForKey:XML_MOMENT_KEY];
            [self handleMoment:momentDict];
            count += 1;
        }
        else if ([[infodict objectForKey:XML_MOMENT_KEY] isKindOfClass:[NSMutableArray class]]){
            NSMutableArray *momentsArray = [infodict objectForKey:XML_MOMENT_KEY];
            
            for (NSMutableDictionary *momentDict in momentsArray){
                [self handleMoment:momentDict];
                count +=  1;
            }
        }
    }
    [self networkTaskDidFinishWithReturningData:@(count) error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end
