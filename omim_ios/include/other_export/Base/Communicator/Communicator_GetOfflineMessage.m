//
//  Communicator_GetOfflineMessage.m
//  dev01
//
//  Created by coca on 14-8-8.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "Communicator_GetOfflineMessage.h"
#import "WTUserDefaults.h"

@implementation Communicator_GetOfflineMessage

/*

- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil) {
        errNo = ERROR_CODE_NOT_RETURNED;
    } else {
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    }
    if (errNo == NO_ERROR) {
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        
        NSMutableDictionary *bodyDic = [result objectForKey:XML_BODY_NAME];
        NSMutableDictionary *infoDic = [bodyDic objectForKey:@"get_offline_message"];
      
        if ([[infoDic objectForKey:@"chat_record"] isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary *dic = [infoDic objectForKey:@"chat_record"];
            
            [arr addObject:[self getChatMessageFromDictionary:dic]];
        }
        else if ([[infoDic objectForKey:@"chat_record"] isKindOfClass:[NSMutableArray class]]) {

            for (NSDictionary *dic in [infoDic objectForKey:@"chat_record"]) {
                ChatMessage* tmpMsg =[self getChatMessageFromDictionary:dic];
                if(tmpMsg!=nil)[arr addObject:tmpMsg];
            }
        }
        
        if([arr count]>0){
            NSMutableArray* newMsgs = [[[NSMutableArray alloc]init] autorelease];
            for (ChatMessage  *msg in arr) {
                if(![Database isChatMessageInDB:msg]){
                    [newMsgs addObject:msg];
                }
            }

            if (newMsgs!=nil && [newMsgs count]>0) {
                if([Database storeChatMessages:newMsgs]){
                    [Database storeLatestContactByChatMessageList:newMsgs];
                    
                    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
                    [dict setObject:[NSError errorWithDomain:ERROR_DOMAIN code:NO_ERROR userInfo:nil] forKey:WT_ERROR];
                    [dict setObject:newMsgs forKey:@"data"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:WT_GET_OFFLINE_MESSAGE object:nil userInfo:dict];
                    
                }

            }
            
            [self storeTimestampByChatMessageList:arr];

            
            
        }
        
    }
    
    
    

    
    [WTUserDefaults setOfflineMsgLastSyncStatus:(errNo==NO_ERROR)];
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}


-(void)storeTimestampByChatMessageList:(NSArray*)list{
    if(list==nil)return;
    
    UInt64 maxTimestamp = 0;
    for (ChatMessage  *msg in list) {
        UInt64 tmpTimestamp  =[msg timestampOfSentdate];
        if(tmpTimestamp>maxTimestamp){
            maxTimestamp= tmpTimestamp;
        }
    }

    if(maxTimestamp>0){
        [WTUserDefaults setOfflineMsgTimestamp_alreadySync:[NSString stringWithFormat:@"%llu",maxTimestamp]];
        
        if([WTUserDefaults getOfflineMsgTimestamp_toSync]){
            UInt64 time_to_sync = [[WTUserDefaults getOfflineMsgTimestamp_toSync] longLongValue];
            if (time_to_sync < maxTimestamp) {
                [WTUserDefaults setOfflineMsgTimestamp_toSync:[NSString stringWithFormat:@"%llu",maxTimestamp]];
            }
        }
        else{
            [WTUserDefaults setOfflineMsgTimestamp_toSync:[NSString stringWithFormat:@"%llu",maxTimestamp]];
        }
    }
}


- (ChatMessage*)getChatMessageFromDictionary:(NSDictionary *)dic
{
    if(dic==nil)return nil;
    
    
    NSString *fromId = [dic objectForKey:@"from_uid"];
    NSString *toId = [dic objectForKey:@"to_uid"];
    
    ChatMessage *message = [[ChatMessage alloc] init];
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
            message.ioType = [ChatMessage IOTYPE_INPUT_UNREAD];
        }
    }
    else {
        message.isGroupChatMessage = YES;
        if ([message.groupChatSenderID isEqualToString:[WTUserDefaults getUid]]) {
            message.ioType = [ChatMessage IOTYPE_OUTPUT];
        } else {
            message.ioType = [ChatMessage IOTYPE_INPUT_UNREAD];
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
    message.remoteKey=[[dic objectForKey:@"id"] integerValue];
    message.sentStatus = [ChatMessage SENTSTATUS_REACHED_CONTACT];
    return [message autorelease];
}
 */
@end
