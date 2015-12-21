//
//  LatestContact.h
//  dev01
//
//  Created by coca on 14-5-20.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"


@interface LatestContact : NSObject
@property (nonatomic,retain) NSString* target_id;
@property (assign) BOOL is_group;
@property (nonatomic,retain) NSString* groupchat_sender_id;
@property (nonatomic,retain) NSString* sentdate;
@property (nonatomic,retain) NSString* last_message_id;
@property (nonatomic,retain) ChatMessage* last_message;
@property (assign)NSInteger unread_count;

- (id) initWithTargetID:(NSString*)target_id andGroupChatSenderID:(NSString*)groupchat_sender_id andSentdate:(NSString*)sentdate andLastMessageID:(NSString*)last_message_id;

- (id) initWithChatMessage:(ChatMessage*)msg;
@end
