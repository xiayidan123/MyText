//
//  Communicator_GetChatHistory.m
//  suzhou
//
//  Created by jianxd on 14-2-17.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetChatHistory.h"
#import "WTUserDefaults.h"

@implementation Communicator_GetChatHistory

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    if (errNo == NO_ERROR) {
        NSMutableDictionary *bodyDic = [result objectForKey:XML_BODY_NAME];
        NSMutableDictionary *infoDic = [bodyDic objectForKey:@"get_chat_history"];
        NSInteger offset = [[infoDic objectForKey:@"offset"] integerValue];
        NSLog(@"offset : %d", offset);
        if ([[infoDic objectForKey:@"chat_record"] isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary *dic = [infoDic objectForKey:@"chat_record"];
            [self storeChatInfoFromDictionary:dic withTag:offset / 6];
        }
        else if ([[infoDic objectForKey:@"chat_record"] isKindOfClass:[NSMutableArray class]]) {
            NSInteger shift = 0;
            for (NSDictionary *dic in [infoDic objectForKey:@"chat_record"]) {
                NSInteger index = offset + shift;
                NSInteger _tag = (int)(index / 6);
                [self storeChatInfoFromDictionary:dic withTag:_tag];
                shift++;
            }
        }
    }
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}

- (void)storeChatInfoFromDictionary:(NSDictionary *)dic withTag:(NSInteger)aTag
{
    NSString *fromId = [dic objectForKey:@"from_uid"];
    NSString *toId = [dic objectForKey:@"to_uid"];
    
    ChatMessage *message = [[ChatMessage alloc] init];
    message.primaryKey = [dic objectForKey:@"id"];
    message.chatUserName = [dic objectForKey:@"from_uid"];
    message.displayName = [dic objectForKey:@"display_name"];
    message.msgType = [dic objectForKey:@"type"];
    message.sentDate = [dic objectForKey:@"sentdate"];
    message.groupChatSenderID = [dic objectForKey:@"groupchat_sender"];
    message.messageContent = [dic objectForKey:@"message"];
    if (message.groupChatSenderID == nil || [message.groupChatSenderID isEqualToString:@""]) {
        message.isGroupChatMessage = NO;
        if ([fromId isEqualToString:[WTUserDefaults getUid]]) {
            message.ioType = [ChatMessage IOTYPE_OUTPUT];
        } else if ([toId isEqualToString:[WTUserDefaults getUid]]) {
            message.ioType = [ChatMessage IOTYPE_INPUT_READED];
        }
    } else {
        message.isGroupChatMessage = YES;
        if ([message.groupChatSenderID isEqualToString:[WTUserDefaults getUid]]) {
            message.ioType = [ChatMessage IOTYPE_OUTPUT];
        } else {
            message.ioType = [ChatMessage IOTYPE_INPUT_READED];
        }
    }
//    if ([message.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] ||
//        [message.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] ||
//        [message.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]) {
//        SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];
//        NSMutableDictionary *dic = (NSMutableDictionary *)[jsonParser fragmentWithString:message.messageContent];
//        message.pathOfThumbNail = [dic objectForKey:@"pathofthumbnailincloud"];
//        message.pathOfMultimedia = [dic objectForKey:@"pathoffileincloud"];
//    } else {
//        message.pathOfThumbNail = @"";
//        message.pathOfMultimedia = @"";
//    }
    message.pathOfThumbNail = @"";
    message.pathOfMultimedia = @"";
    message.readCount = 0;
    message.tag = aTag;
    
    if (self.withStore) {
        if ([[ChatMessage IOTYPE_OUTPUT] isEqualToString:message.ioType]) {
            message.sentStatus=[ChatMessage SENTSTATUS_REACHED_CONTACT];
            message.chatUserName=toId;
        } else {
            message.sentStatus=[ChatMessage IOTYPE_INPUT_READED];
        }
        message.remoteKey = [[dic objectForKey:@"id"] integerValue];
        if (![Database isChatMessageInDB:message]) {
            [Database storeChatMessages:[NSArray arrayWithObject:message]];
            [Database storeMessageIDForHistory:[[NSNumber numberWithInteger:message.remoteKey] stringValue]];
        }
    } else {
        [Database storeChatHistory:[NSArray arrayWithObject:message]];
    }
    
    [message release];
}
@end
