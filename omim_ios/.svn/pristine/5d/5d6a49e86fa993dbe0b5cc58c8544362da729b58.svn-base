//
//  OMMessageHelper.m
//  dev01
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 wowtech. All rights reserved.
//

#import "OMMessageHelper.h"

#import "ChatMessage.h"
#import "Buddy.h"
#import "GroupChatRoom.h"

#import "TimeHelper.h"
#import "WTUserDefaults.h"
#import "Database.h"
#import "WowTalkWebServerIF.h"

@implementation OMMessageHelper

+ (void)sendTextMessage:(NSString *)message withToBuddy:(Buddy *)buddy{
    
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = buddy.userID;
    
    msg.displayName = buddy.nickName;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = message;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    [WowTalkWebServerIF sendBuddyMessage:msg];
    
}


+ (void)sendTextMessage:(NSString *)message withToGroup:(GroupChatRoom *)group{
    ChatMessage* msg= [[[ChatMessage alloc]init] autorelease];
    msg.chatUserName = group.groupID;
    
    msg.displayName = group.groupNameOriginal;
    
    msg.msgType = [ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    
    msg.messageContent = message;
    
    msg.sentDate = [TimeHelper getCurrentTime];
    
    msg.isGroupChatMessage = TRUE;
    msg.groupChatSenderID = [WTUserDefaults getUid];
    msg.ioType = [ChatMessage IOTYPE_OUTPUT];
    msg.primaryKey = [Database storeNewChatMessage:msg];
    [WowTalkWebServerIF groupChat_SendMessage:msg toGroup:group.groupID withCallback:nil withObserver:nil];
}

@end
