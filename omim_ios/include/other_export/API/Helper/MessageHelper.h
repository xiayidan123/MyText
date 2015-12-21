//
//  MessageHelper.h
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatMessage;

@interface MessageHelper : NSObject

+(NSString*)translateMsgTypeForOfficialUserMsgType:(NSString*)input;

+(NSString*)translateOfficialUserMsgTypeToChatMessageType:(NSString*)input;



+(BOOL)readyToSendMultimediaMessage:(ChatMessage*)msg;
+(NSString*) localThumbnailPathForMessage:(ChatMessage*)msg;
+(NSString*) localOriginalFilePathForMessage:(ChatMessage*)msg;
+(NSString*) localRecordFileForMessage:(ChatMessage*)msg;
@end
