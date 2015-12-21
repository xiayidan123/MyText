//
//  ChatMessage.h
//  omim
//
//  Created by Coca on 5/29/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//


@interface ChatMessage : NSObject {
    /** insert key of this message in db **/
	NSInteger  primaryKey;
    /** insert key of this message in sender db **/
	NSInteger    remoteKey;
    /** userID / groupID /userName  **/
	NSString   *chatUserName;
    /** user nick name in server **/
	NSString   *displayName;    //user nick name in server
    
    /** message content **/
	NSString   *messageContent;
    
    /** message sent date **/
	NSString   *sentDate;
    
    
	/** message type MSGTYPE_* **/
	NSString	*msgType;
    
    /** io type : IOTYPE_*  **/
	NSString	*ioType;
    
    /** sent status : SENTSTATUS_* **/
	NSString	*sentStatus;
	
    
    /** true when this is a group chat message **/
	BOOL isGroupChatMessage;
	/** Message sender when in group chat, "" when 1:1 chat **/
	NSString* groupChatSenderID;
    
	/** read count of this message **/
	NSInteger readCount;
    
    
	NSString* pathOfThumbNail;
	NSString* pathOfMultimedia;
    NSString* pathOfPicVoice;
    
    
    
	/////////////// properties below shouldn't be stored in DB/////////
	NSString   *compositeName;  //user composite name in address book
	NSInteger chatUserRecordID;
    BOOL	fileTransfering;
    
    NSInteger tag;
}
@property (assign) NSInteger primaryKey;
@property (assign) NSInteger remoteKey;

@property (copy) NSString *chatUserName;
@property (copy) NSString *messageContent;
@property (copy) NSString *sentDate;

@property (copy) NSString *msgType;
@property (copy) NSString *ioType;
@property (copy) NSString *sentStatus;

@property (assign) BOOL isGroupChatMessage;
@property (copy) NSString *groupChatSenderID;
@property (copy) NSString *displayName;
@property (assign) NSInteger readCount;
@property (copy) NSString *pathOfThumbNail;
@property (copy) NSString *pathOfMultimedia;



@property (copy) NSString *compositeName;
@property (assign) NSInteger chatUserRecordID;
@property (assign) BOOL fileTransfering;

@property (assign) NSInteger tag;
- (BOOL) hasPrimaryKey;
- (BOOL) hasRemoteKey;


// start of internal message type, you dont want to use them
+(NSString*) MSGTYPE_SENT_MSG_RECEIPT;
+(NSString*) MSGTYPE_CALLEE_GETBACK_ONLINE;
+(NSString*) MSGTYPE_GET_MISSED_CALL;
+(NSString*) MSGTYPE_FORCE_TO_TEMINATE_CALL;
+(NSString*) MSGTYPE_NORMAL_CALL_REJECTED;
+(NSString*) MSGTYPE_VIDEO_CALL_REQUEST;
+(NSString*) MSGTYPE_VIDEO_CALL_REJECTED;
+(NSString*) MSGTYPE_SENT_MSG_READED_RECEIPT;

+(NSString*) MSGTYPE_BUDDYLIST_INCREASED ;
+(NSString*) MSGTYPE_BUDDYLIST_DECREASED ;
+(NSString*) MSGTYPE_ACTIVE_APP_TYPE_CHANGED;
// End of internal message type



+(NSString*) MSGTYPE_NORMAL_TXT_MESSAGE ;
+(NSString*) MSGTYPE_ENCRIPTED_TXT_MESSAGE;
+(NSString*) MSGTYPE_LOCATION;
+(NSString*) MSGTYPE_MULTIMEDIA_STAMP;
+(NSString*) MSGTYPE_MULTIMEDIA_PHOTO;
+(NSString*) MSGTYPE_MULTIMEDIA_VOICE_NOTE;
+(NSString*) MSGTYPE_MULTIMEDIA_VIDEO_NOTE;
+(NSString*) MSGTYPE_MULTIMEDIA_VCF;

+(NSString*) MSGTYPE_GROUPCHAT_JOIN_REQUEST;
+(NSString*) MSGTYPE_GROUPCHAT_SOMEONE_JOIN_ROOM;
+(NSString*) MSGTYPE_GROUPCHAT_SOMEONE_QUIT_ROOM;

+(NSString*) MSGTYPE_CALL_LOG;
+(NSString*) MSGTYPE_OFFICIAL_ACCOUNT_MSG;
+(NSString*) MSGTYPE_PIC_VOICE;
+(NSString*) MSGTYPE_NOTIFICATION;
+(NSString*) MSGTYPE_NEW_MOMENT;

+(NSString*) MSGTYPE_OUTGOING_MSG;
//support for game or sth else
+(NSString*) MSGTYPE_THIRDPARTY_MSG;


+(NSString*) IOTYPE_OUTPUT;
+(NSString*) IOTYPE_INPUT_READED;
+(NSString*) IOTYPE_INPUT_UNREAD;

+(NSString*) SENTSTATUS_FILE_UPLOADINIT;
+(NSString*) SENTSTATUS_IN_PROCESS; //being sent
+(NSString*) SENTSTATUS_NOTSENT;;
+(NSString*) SENTSTATUS_SENT;
+(NSString*) SENTSTATUS_REACHED_CONTACT;
+(NSString*) SENTSTATUS_READED_BY_CONTACT;



@end
