//
//  LatestContact.m
//  dev01
//
//  Created by coca on 14-5-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "LatestContact.h"

@implementation LatestContact

- (id) initWithTargetID:(NSString*)target_id andGroupChatSenderID:(NSString*)groupchat_sender_id andSentdate:(NSString*)sentdate andLastMessageID:(NSString*)last_message_id{
    self = [super init];
	if (self == nil)
		return nil;

    self.target_id=target_id;
    self.groupchat_sender_id=groupchat_sender_id;
    
    if(self.groupchat_sender_id!=nil && [self.groupchat_sender_id isEqualToString:@""]){
        self.groupchat_sender_id=nil;
    }
    
    self.is_group=(self.groupchat_sender_id!=nil);
    self.sentdate=sentdate;
    self.last_message_id=last_message_id;
    
 
    
    return self;
}

- (id) initWithChatMessage:(ChatMessage*)msg{
    self = [super init];
	if (self == nil)
		return nil;
    
    self.target_id=msg.chatUserName;
    self.groupchat_sender_id=msg.groupChatSenderID;
    
    
    if(self.groupchat_sender_id!=nil && [self.groupchat_sender_id isEqualToString:@""]){
        self.groupchat_sender_id=nil;
    }
    
    
    self.is_group=msg.isGroupChatMessage;
    self.sentdate=msg.sentDate;
    
    
    
    return self;
}
@end
