//
//  ChatMessage.m
//  omim
//
//  Created by Coca on 5/29/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "ChatMessage.h"

/*
 [type definition]
 
 
 
 1:tell message sender i have received ur msg
 //messgae payload :   type |  content
 // length         :    "1" |  "$msgId"
 
 2:tell caller i am online now
 //messgae payload :   type |  yyyy/MM/dd HH:mm|
 // length         :    "2" |  <------16------>|
 
 3:tell callee you missed my call
 //messgae payload :   type | yyyy/MM/dd HH:mm|
 // length         :    "3" |  <------16------>|
 
 4:tell callee you must kill your call now.
 //messgae payload :   type |  yyyy/MM/dd HH:mm|
 // length         :    "4" |  <------16------>|
 
 5:tell callee i reject for your normal call
 //messgae payload :   type |  yyyy/MM/dd HH:mm|
 // length         :    "5" |  NULL
 6:tell callee i want to start video call
 //messgae payload :   type |  yyyy/MM/dd HH:mm|
 // length         :    "6" |  <------16------>|
 
 7:tell callee i reject for your video call
 //messgae payload :   type |  yyyy/MM/dd HH:mm|
 // length         :    "7" |  <------16------>|
 
 MSGTYPE_SENT_MSG_READED_RECEIPT
 8:tell message sender i have readed ur msg
 //messgae payload :   type |  content
 // length         :    "8" | "$msgId"
 
 
 
 MSGTYPE_ENCRIPTED_TXT_MESSAGE
 9:encripted text message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content  ($senderID optional)
 // length         :    "9" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" $body
 
 0:text message
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id    |content
 // length         :    "0" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" $body
 
 MSGTYPE_LOCATION
 a:location message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "a" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" <経度,緯度><Others>
 
 MSGTYPE_MULTIMEDIA_STAMP
 b:stamp message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "b" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" <stampID><stampText><Others>
 
 MSGTYPE_MULTIMEDIA_PHOTO
 c:photo message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "c" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" <thumbnail url><content url>
 
 MSGTYPE_MULTIMEDIA_VOICE_NOTE
 d:voice message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "d" | <------16------>|"{"$msgId"}"  |"{"$senderID"}" <content url>
 
 MSGTYPE_MULTIMEDIA_VIDEO_NOTE
 e:video message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "e" | <------16------>|"{"$msgId"}"  |"{"$senderID"}"  <thumbnail url><content url>
 
 MSGTYPE_MULTIMEDIA_VCF
 f:vcf message
 //encripted part           | <------------encripted---------------------------------------------->|
 //messgae payload :   type | yyyy/MM/dd HH:mm| msg id       |content ($senderID optional)
 // length         :    "f" | <------16------>|"{"$msgId"}"  |"{"$senderID"}"  <vcf content>
 
 MSGTYPE_GROUPCHAT_JOIN_REQUEST
 g:invitation for group chat room
 //messgae payload :   type | yyyy/MM/dd HH:mm| groupid        |content ($senderID optional)
 // length         :    "g" | <------16------>|"{"$groupid"}"  |"{"$senderID"}"
 
 
 MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM
 h:someone join the group i am involved
 //messgae payload :   type | yyyy/MM/dd HH:mm| groupid        |content ($senderID optional)
 // length         :    "h" | <------16------>|"{"$groupid"}"  |"{"$senderID"}"
 
 MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM
 i:someone leave the group i am involved
 //messgae payload :   type | yyyy/MM/dd HH:mm| groupid        |content ($senderID optional)
 // length         :    "i" | <------16------>|"{"$groupid"}"  |"{"$senderID"}"
 
 
 
 j-zA-Z: reserved
 
 
 
 */


@implementation ChatMessage


@synthesize primaryKey;
@synthesize remoteKey;
@synthesize chatUserName;
@synthesize messageContent;
@synthesize sentDate;
@synthesize msgType;
@synthesize ioType;
@synthesize sentStatus;
@synthesize isGroupChatMessage;
@synthesize groupChatSenderID;
@synthesize readCount;
@synthesize displayName;
@synthesize compositeName;
@synthesize chatUserRecordID;
@synthesize pathOfThumbNail;
@synthesize pathOfMultimedia;
@synthesize fileTransfering;

@synthesize tag;

- (id) init {
	self = [super init];
	if (self == nil)
		return nil;
	
	primaryKey = -1;
	remoteKey = -1;
	return self;
}


- (BOOL) hasPrimaryKey {
	return primaryKey != -1;
}

- (NSInteger)primaryKey {
	return primaryKey;
}

- (void)setPrimaryKey:(NSInteger)anInteger {
	primaryKey = anInteger;
}

- (BOOL) hasRemoteKey {
	return remoteKey != -1;
}
- (NSInteger)remoteKey {
	return remoteKey;
}

- (void)setRemoteKey:(NSInteger)anInteger {
	remoteKey = anInteger;
}


- (NSInteger)readCount {
	return readCount;
}

- (void)setReadCount:(NSInteger)anInteger {
	readCount = anInteger;
}

- (BOOL)isGroupChatMessage {
	return isGroupChatMessage;
}

- (void)setIsGroupChatMessage:(BOOL)anBool {
	isGroupChatMessage = anBool;
}

- (NSInteger)chatUserRecordID {
	return chatUserRecordID;
}

- (void)setChatUserRecordID:(NSInteger)anInteger {
	chatUserRecordID = anInteger;
}


#pragma mark -
#pragma Class method for Class level value
+(NSString*) MSGTYPE_SENT_MSG_RECEIPT{ return @"1";}
+(NSString*) MSGTYPE_CALLEE_GETBACK_ONLINE{ return @"2";}
+(NSString*) MSGTYPE_GET_MISSED_CALL{ return @"3";}
+(NSString*) MSGTYPE_FORCE_TO_TEMINATE_CALL{ return @"4";}
+(NSString*) MSGTYPE_NORMAL_CALL_REJECTED{ return @"5";}
+(NSString*) MSGTYPE_VIDEO_CALL_REQUEST{ return @"6";}
+(NSString*) MSGTYPE_VIDEO_CALL_REJECTED{ return @"7";}
+(NSString*) MSGTYPE_SENT_MSG_READED_RECEIPT{ return @"8";}


+(NSString*) MSGTYPE_ENCRIPTED_TXT_MESSAGE{ return @"9";}
+(NSString*) MSGTYPE_NORMAL_TXT_MESSAGE { return @"0";}
+(NSString*) MSGTYPE_LOCATION{ return @"a";}
+(NSString*) MSGTYPE_MULTIMEDIA_STAMP{ return @"b";}
+(NSString*) MSGTYPE_MULTIMEDIA_PHOTO{ return @"c";}
+(NSString*) MSGTYPE_MULTIMEDIA_VOICE_NOTE{ return @"d";}
+(NSString*) MSGTYPE_MULTIMEDIA_VIDEO_NOTE{ return @"e";}
+(NSString*) MSGTYPE_MULTIMEDIA_VCF{ return @"f";}

+(NSString*) MSGTYPE_GROUPCHAT_JOIN_REQUEST{ return @"g";}
+(NSString*) MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM{ return @"h";}
+(NSString*) MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM{ return @"i";}

+(NSString*) MSGTYPE_CALL_LOG{return @"j";}

+(NSString*) MSGTYPE_BUDDYLIST_INCREASED {return @"k";}
+(NSString*) MSGTYPE_BUDDYLIST_DECREASED {return @"l";}
+(NSString*) MSGTYPE_ACTIVE_APP_TYPE_CHANGED {return @"m";}
+(NSString*) MSGTYPE_OFFICIAL_ACCOUNT_MSG {return @"n";}

+(NSString*) MSGTYPE_PIC_VOICE{ return @"o";}
+(NSString*) MSGTYPE_NOTIFICATION {return @"p";}

+(NSString*) MSGTYPE_NEW_MOMENT {return @"r";}
+(NSString*) MSGTYPE_OUTGOING_MSG {return @"z";}
+(NSString*) MSGTYPE_THIRDPARTY_MSG {return @"x";}


+(NSString*) IOTYPE_OUTPUT{ return @"0";}
+(NSString*) IOTYPE_INPUT_READED{ return @"1";}
+(NSString*) IOTYPE_INPUT_UNREAD{ return @"2";}

+(NSString*) SENTSTATUS_FILE_UPLOADINIT{ return @"-3";}
+(NSString*) SENTSTATUS_IN_PROCESS{ return @"-1";}
+(NSString*) SENTSTATUS_NOTSENT{ return @"0";}
+(NSString*) SENTSTATUS_SENT{ return @"1";}
+(NSString*) SENTSTATUS_REACHED_CONTACT{ return @"2";}
+(NSString*) SENTSTATUS_READED_BY_CONTACT{ return @"3";}

-(void)dealloc
{
    self.chatUserName = nil;
    self.messageContent = nil;
    self.sentDate = nil;
    
    self.msgType = nil;
    self.ioType = nil;
    self.sentStatus = nil;
    
    self.groupChatSenderID = nil;
    self.displayName = nil;
    self.pathOfThumbNail = nil;
    self.pathOfMultimedia = nil;
    
    self.compositeName = nil;
    
    [super dealloc];
}




@end
