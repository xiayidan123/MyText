//
//  Communicator_GetAllPendingRequests.m
//  omim
//
//  Created by coca on 2013/05/09.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "Communicator_GetAllPendingRequests.h"
#import "PendingRequest.h"
#import "Constants.h"

@implementation Communicator_GetAllPendingRequests

-(NSMutableArray*)handleRequest:(NSMutableDictionary*)dic isGroupRequest:(BOOL)isGroupRequest
{
    NSMutableArray* arrays = [[[NSMutableArray alloc] init] autorelease];
    
    if ([[dic objectForKey:XML_REQUEST] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray* requestarray = [dic objectForKey:XML_REQUEST];
        
        for (NSMutableDictionary* requestdic  in requestarray) {
            
            if (isGroupRequest) {
                PendingRequest* request = [[PendingRequest alloc] init];
                request.groupid = [requestdic objectForKey:WT_GROUP_ID];
                request.groupname = [requestdic objectForKey:XML_GROUP_NAME_KEY];
                request.buddyid = [requestdic objectForKey:XML_UID_KEY];
                request.nickname = [requestdic objectForKey:XML_NICKNAME_KEY];
                request.msg = [requestdic objectForKey:XML_REQUEST_MSG];
                [arrays addObject:request];
                [request release];
            }
            
            else{
                PendingRequest* request = [[PendingRequest alloc] init];
                request.buddyid = [requestdic objectForKey:XML_UID_KEY];
                request.nickname = [requestdic objectForKey:XML_NICKNAME_KEY];
                request.msg = [requestdic objectForKey:XML_REQUEST_MSG];
                [arrays addObject:request];
                [request release];
            }
            
        }
        
        
    }
    
    else if ([[dic objectForKey:XML_REQUEST] isKindOfClass:[NSMutableDictionary class]]){
        
        NSMutableDictionary* requestdic = [dic objectForKey:XML_REQUEST];
        if (isGroupRequest) {
            PendingRequest* request = [[PendingRequest alloc] init];
            request.groupid = [requestdic objectForKey:WT_GROUP_ID];
            request.groupname = [requestdic objectForKey:XML_GROUP_NAME_KEY];
            request.buddyid = [requestdic objectForKey:XML_UID_KEY];
            request.nickname = [requestdic objectForKey:XML_NICKNAME_KEY];
            request.msg = [requestdic objectForKey:XML_REQUEST_MSG];
            [arrays addObject:request];
            [request release];
        }
        
        else{
            PendingRequest* request = [[PendingRequest alloc] init];
            request.buddyid = [requestdic objectForKey:XML_UID_KEY];
            request.nickname = [requestdic objectForKey:XML_NICKNAME_KEY];
            request.msg = [requestdic objectForKey:XML_REQUEST_MSG];
            [arrays addObject:request];
            [request release];
        }
    }
    return arrays;
}

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    NSMutableDictionary *resultdic = [[NSMutableDictionary alloc] init];
    
    if (errNo == NO_ERROR) {
        
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];

            
            NSMutableDictionary *infodict = [bodydict objectForKey:WT_GET_ALL_PENDING_REQUEST];
            
            NSMutableDictionary* groupindict = [infodict objectForKey:XML_REQUEST_GROUP_IN];
            
            if (groupindict != nil) {
                
                self.arr_group_in = [self handleRequest:groupindict isGroupRequest:TRUE];
            }
            
            NSMutableDictionary* groupadmindict = [infodict objectForKey:XML_REQUEST_GROUP_ADMIN];
            
            if (groupadmindict != nil) {
                
                self.arr_group_admin = [self handleRequest:groupadmindict isGroupRequest:TRUE];
            }
            
            NSMutableDictionary* buddyindict = [infodict objectForKey:XML_REQUEST_BUDDY_IN];
            
            if (buddyindict != nil) {
                
                self.arr_buddy_in = [self handleRequest:buddyindict isGroupRequest:FALSE];
            }
        
        
        int countOfRequest = 0;
        
            if (self.arr_buddy_in != nil && [self.arr_buddy_in count] > 0) {
                [resultdic setObject:self.arr_buddy_in forKey:@"buddyrequest"];
                countOfRequest += [self.arr_buddy_in count] ;
            }
            
            if (self.arr_group_admin != nil && [self.arr_group_admin count] >0) {
                [resultdic setObject:self.arr_group_admin forKey:@"joingrouprequest"];
                countOfRequest += [self.arr_group_admin count] ;

            }
        
            if (self.arr_group_in != nil && [self.arr_group_in count] > 0) {
                [resultdic setObject:self.arr_group_in forKey:@"inviterequest"];
                countOfRequest += [self.arr_group_in count] ;

            }
        
       
        [[NSUserDefaults standardUserDefaults] setInteger:countOfRequest forKey:NEW_REQUEST_NUM];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (countOfRequest>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"new_request" object:nil];

        }
        
    }
    
    
    [self networkTaskDidFinishWithReturningData:resultdic error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
    
    [resultdic release];
}

@end
