//
//  Communicator_GetLatestContactList.m
//  dev01
//
//  Created by coca on 14-5-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetLatestContactList.h"
#import "LatestContact.h"
#import "Database.h"

@implementation Communicator_GetLatestContactList

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        NSMutableDictionary *bodydict = [result objectForKey:XML_BODY_NAME];
        if (bodydict == nil || [bodydict objectForKey:XML_GET_LATEST_CONTACT_KEY] == nil){
            //shouldnot do anything here
        }
        else{
            NSMutableDictionary *infodict = [bodydict objectForKey:XML_GET_LATEST_CONTACT_KEY];
            NSMutableArray *contactArray = [[NSMutableArray alloc] init];
            if ([[infodict objectForKey:@"chat_record"] isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *buddydict = [infodict objectForKey:@"chat_record"];
                
                NSString* from_id = [buddydict objectForKey:@"from_uid"];
                NSString* to_id = [buddydict objectForKey:@"to_uid"];
                NSString* target_id=nil;
                if (from_id!=nil&&[from_id isEqualToString:[WTUserDefaults getUid]]) {
                    target_id = to_id;
                }
                else if (to_id!=nil&&[to_id isEqualToString:[WTUserDefaults getUid]]) {
                    target_id = from_id;
                }
                
                if(target_id==nil){
                    errNo = NECCESSARY_DATA_NOT_RETURNED;
                    [self endMyselfWithErr:errNo];
                }
                
                LatestContact* contact = [[LatestContact alloc] initWithTargetID:target_id
                                                            andGroupChatSenderID: [buddydict objectForKey:@"groupchat_sender"]
                                                                     andSentdate:[buddydict objectForKey:@"sentdate"]
                                                                andLastMessageID:nil];
                
             
                
                [contactArray addObject:contact];
                [contact release];
            }
            else if ([[infodict objectForKey:@"chat_record"] isKindOfClass:[NSMutableArray class]])
            {
                NSMutableArray *arr = [infodict objectForKey:@"chat_record"];
                for (NSMutableDictionary *buddydict in arr)
                {
                    NSString* from_id = [buddydict objectForKey:@"from_uid"];
                    NSString* to_id = [buddydict objectForKey:@"to_uid"];
                    NSString* target_id=nil;
                    if (from_id!=nil&&[from_id isEqualToString:[WTUserDefaults getUid]]) {
                        target_id = to_id;
                    }
                    else if (to_id!=nil&&[to_id isEqualToString:[WTUserDefaults getUid]]) {
                        target_id = from_id;
                    }
                    
                    if(target_id==nil){
                        errNo = NECCESSARY_DATA_NOT_RETURNED;
                        [self endMyselfWithErr:errNo];
                    }

                    LatestContact* contact = [[LatestContact alloc] initWithTargetID:target_id
                                                                          andGroupChatSenderID: [buddydict objectForKey:@"groupchat_sender"]
                                                                         andSentdate:[buddydict objectForKey:@"sentdate"]
                                                                    andLastMessageID:nil];
                    
                    
                    
                    [contactArray addObject:contact];
                    [contact release];
                }
            }
            
            if (contactArray.count > 0)
            {
                [Database storeLatestContacts:contactArray];
            }
            
            [contactArray release];
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

-(void)endMyselfWithErr:(int)errNo{
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];

}

@end
