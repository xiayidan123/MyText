//
//  Communicator_GetPendingRequests.m
//  omim
//
//  Created by coca on 2013/04/26.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetPendingRequests.h"
#import "PendingRequest.h"

@implementation Communicator_GetPendingRequests


- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableArray * requests = [[NSMutableArray alloc] init];
    
    if (errNo == NO_ERROR) {
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        
        if ([[[bodydict objectForKey:WT_GET_GROUP_PENDING_MEMBERS] objectForKey:@"buddy"] isKindOfClass:[NSMutableArray class]]) {
            NSArray* array = [[bodydict objectForKey:WT_GET_GROUP_PENDING_MEMBERS] objectForKey:@"buddy"];
            
            for (NSDictionary* dic in array) {
                PendingRequest* request = [[PendingRequest alloc] init];
                request.buddyid = [dic objectForKey:XML_UID_KEY];
                request.nickname = [dic objectForKey:XML_NICKNAME_KEY];
                request.msg = [dic objectForKey:XML_REQUEST_MSG];
                
                [requests addObject:request];
                [request release];
            }
            
            
        }
        else if([[[bodydict objectForKey:WT_GET_GROUP_PENDING_MEMBERS] objectForKey:@"buddy"]  isKindOfClass:[NSMutableDictionary class]]) {
              NSDictionary* dic = [[bodydict objectForKey:WT_GET_GROUP_PENDING_MEMBERS] objectForKey:@"buddy"];
                PendingRequest* request = [[PendingRequest alloc] init];
                request.buddyid = [dic objectForKey:XML_UID_KEY];
                request.nickname = [dic objectForKey:XML_NICKNAME_KEY];
                request.msg = [dic objectForKey:XML_REQUEST_MSG];
            
                [requests addObject:request];
                [request release];
        }
    }
    
    
    [self networkTaskDidFinishWithReturningData:requests error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
    [requests release];
}
@end
