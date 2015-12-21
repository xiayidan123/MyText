//
//  MessageHelper.m
//  omim
//
//  Created by elvis on 2013/05/02.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "MessageHelper.h"
#import "ChatMessage.h"
#import "JSON.h"
#import "WTConstant.h"
#import "NSFileManager+extension.h"

#define SDK_JPG                                          @"jpg"
#define SDK_MP4                                           @"mp4"
#define SDK_AAC                                          @"aac"
@implementation MessageHelper

+(NSString*)translateMsgTypeForOfficialUserMsgType:(NSString*)input{
    if(input==nil)return nil;
    NSString* rlt=nil;
    
    
    if([input isEqualToString:[ChatMessage MSGTYPE_ENCRIPTED_TXT_MESSAGE]] || [input isEqualToString:[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE]]){
        rlt=@"text";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]){
        rlt=@"voice";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]]){
        rlt=@"video";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]){
        rlt=@"image";
    }
    else if ([input isEqualToString:[ChatMessage MSGTYPE_LOCATION]]){
        rlt=@"location";
    }
    
    return rlt;
    
    
}

+(NSString*)translateOfficialUserMsgTypeToChatMessageType:(NSString*)input{
    if(input==nil)return nil;
    NSString* rlt=nil;
    
    
    if([input isEqualToString:@"text"]){
        rlt=[ChatMessage MSGTYPE_NORMAL_TXT_MESSAGE];
    }
    else if([input isEqualToString:@"voice"]){
        rlt=[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE];
    }
    else if([input isEqualToString:@"video"]){
        rlt=[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE];
    }
    else if([input isEqualToString:@"image"]){
        rlt=[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO];
    }
    
    return rlt;
}


#pragma mark -- helper method
+(BOOL)readyToSendMultimediaMessage:(ChatMessage*)msg
{
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]) {
        return TRUE;
    }
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]] || [msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]]){
        SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: msg.messageContent];
        if([dic valueForKey:WT_PATH_OF_THE_THUMBNAIL_IN_SERVER] !=nil && ![[dic valueForKey:WT_PATH_OF_THE_THUMBNAIL_IN_SERVER] isEqualToString:@""]&&[dic valueForKey:WT_PATH_OF_THE_ORIGINAL_FILE_IN_SERVER] != nil && ![[dic valueForKey:WT_PATH_OF_THE_ORIGINAL_FILE_IN_SERVER] isEqualToString:@""]){
            return TRUE;
        }
    }
    return FALSE;
}

+(NSString*) localThumbnailPathForMessage:(ChatMessage*)msg{
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:WT_PATH_OF_THE_THUMBNAIL_IN_SERVER];
    NSString* dirname = [WT_MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
    return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:SDK_JPG];
    
}


+(NSString*) localRecordFileForMessage:(ChatMessage*)msg{
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:@"audio_pathoffileincloud"];
    NSString* dirname = [WT_MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
    return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:SDK_AAC];
    
}

//TODO: test here.
+(NSString*) localOriginalFilePathForMessage:(ChatMessage*)msg{
    SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
    NSString* filename = [(NSDictionary*)[jp fragmentWithString: msg.messageContent] objectForKey:WT_PATH_OF_THE_ORIGINAL_FILE_IN_SERVER];
    NSString* dirname = [WT_MULTI_MEDIA_FOLDER_NAME stringByAppendingPathComponent:msg.chatUserName];
    
    if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_PHOTO]]) {
        return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:SDK_JPG];
    }
    else if([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VIDEO_NOTE]])
        return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:SDK_MP4];
    else if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_MULTIMEDIA_VOICE_NOTE]]){
        SBJsonParser* jp = [[[SBJsonParser alloc] init] autorelease];
        
        NSDictionary* dic = (NSDictionary*)[jp fragmentWithString: msg.messageContent];
        NSString* extension = [dic valueForKey:WT_VOICE_MESSAGE_EXT];
        return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:extension];
    }
    else  if ([msg.msgType isEqualToString:[ChatMessage MSGTYPE_PIC_VOICE]]) {
        return [NSFileManager relativePathToDocumentFolderForFile:filename WithSubFolder:dirname withExtention:SDK_JPG];
    }
    return nil;
}

@end
