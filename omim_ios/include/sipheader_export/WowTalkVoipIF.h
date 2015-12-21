#import <Foundation/Foundation.h>

#import "CallLog.h"
#import "ChatMessage.h"
#import "Database.h"

 enum WTRegistrationState{
	WTRegistrationIdle=0,       /**<Idle state for registrations */
	WTRegistrationInProgress=1, /**<Registration is in progress */
	WTRegistrationSuccess=2,	/**< Registration is successful */
	WTRegistrationCleared=3,    /**< Unregistration succeeded */
	WTRegistrationFailed=4      /**<Registration failed */
};

@interface WowTalkVoipIF : NSObject
#pragma mark -
#pragma Internal Use Methods, You dont want to touch them
/**
 * Internal Use
 * Set whether WowTalk Client is connected to Server 
 * 
 */
+(void) fSetLoginToServer:(BOOL)hasLogin;


#pragma mark -
#pragma UIDelegate Hanlder

/**
 * Set viewController for WowTalkUICallProcessDelegate
 * 
 */
+(void) fSetCallProcessDelegate:(id) oCallProcessDelegate;


/**
 * Set viewController for WowTalkUIMakeCallDelegate
 * 
 */
+(void) fSetMakeCallDelegate:(id) oMakeCallDelegate ;




#pragma mark -
#pragma Global service handler

/**
 * 
 * Check whether WowTalk Client is connected to Server 
 * 
 * @return
 */
+(BOOL) fIsConnectedToNetwork;
+(BOOL) fIsConnectedToServer;

+(BOOL) fIsSetupCompleted;

/**
 * 
 * Check whether WowTalkService is ready: should be called before enter
 * incall mode;
 * 
 * @return
 */
+(BOOL) fIsWowTalkServiceReady;

/**
 * Start WowTalk Service
 *
 */
+(void) fStartWowTalkService;

/**
 * Register to WowTalk Server
 *
 */
+(void) fRegister;

/**
 * Set WowTalk Service enter Background Mode
 * 
 */
+(void) fWowTalkServiceEnterBackgroundMode;

/**
 * Set WowTalk Service enter Front Mode
 * 
 */
+(void) fWowTalkServiceEnterActiveMode;



#pragma mark -
#pragma Call Hanlder

+(NSString*) fTranslatePhoneNumberToGlobalNumber:(NSString*)phoneNumber;
/**
 * Start a new out going call
 * 
 * @param strUID
 * @param displayName
 * @param videoFlag
 * @return false if no connection or phonenumber format failed
 */
+(BOOL) fNewOutgoingCall:(NSString*) strUID withDisplayName:(NSString*) displayName withVideo:(BOOL)videoFlag;
/**
 * Notify callee you have missed a call
 * 
 * @param callLog
 * @return
 */
+(BOOL) fNotifyCalleeForMissedCall:(CallLog*) callLog;


/**
 * Send notification to caller that I have received push notification for your call
 * 
 * 発信者に対し、Push通知受信済み通知を送る
 * 
 * @param callerName
 */
+(BOOL) fNotifyCallerIGetOnline: (NSString*) callerName;


/**
 * Accept Incoming call
 * 
 */
+(void)fAcceptCall;

+(void)fAcceptVideoCall;

/**
 * Terminate calls
 */
+(void) fTerminateCall ;

#pragma mark -
#pragma ChatMessage Handler




/**
 * Send a ChatMessage to specified user/group and store it to database
 * 指定したユーザやグループに送信
 * @param context
 * @param msg
 * 
 *            at least msg.chatUserName ,msg.msgType and  msg.messageContent should be set
 *            before calling this method
 * 
 support type:
 +(NSString*) MSGTYPE_NORMAL_TXT_MESSAGE ;
 +(NSString*) MSGTYPE_ENCRIPTED_TXT_MESSAGE;
 +(NSString*) MSGTYPE_LOCATION;
 +(NSString*) MSGTYPE_MULTIMEDIA_STAMP;
 +(NSString*) MSGTYPE_MULTIMEDIA_PHOTO;
 +(NSString*) MSGTYPE_MULTIMEDIA_VOICE_NOTE;
 +(NSString*) MSGTYPE_MULTIMEDIA_VIDEO_NOTE;
 +(NSString*) MSGTYPE_MULTIMEDIA_VCF;
 +(NSString*) MSGTYPE_THIRDPARTY_MSG;
 * 
 * @return true if message is sent to server
 */
+(BOOL) fSendChatMessage:(ChatMessage*) msg;

+(BOOL) fNotifyMessageReceived: (NSString*) msgID  forUser:(NSString*) userName;
+(BOOL) fNotifyMessageReaded: (NSString*) msgID  forUser:(NSString*) userName;

+(BOOL) fResendUnsentReceipt:(NSString*) messageBody forUser:(NSString*) userName;
#pragma mark -
#pragma Video Call Handler

/**
 * 
 * Invite for video call inside current call
 * 
 * @param addVideo
 */
+(BOOL) fVideoCall_StartInvite:(BOOL)addVideo;


/**
 * 
 * Accept video call request inside current call
 * 
 */
+(BOOL) fVideoCall_AcceptInvitation;


/**
 * Reject video call invitation from mCalleeName
 * 
 * @param uid
 * @return
 */
+(BOOL) fRejectTheVideoCallInvite:(NSString*) uid;

/**
 * Adjust video rotation when in a video call
 * 
 * @param oritentation
 */
+(void) fVideoCall_AutoAdjustVideoRotation:(UIInterfaceOrientation) oritentation;

/**
 * 
 * Set capture preview video window when in a video call
 * 
 * @param UIView
 */
+(void) fVideoCall_SetCapturePreviewVideoWindow:(UIView*) w ;

/**
 * 
 * Set video window when in a video call
 * 
 * @param UIView
 */
+(void) fVideoCall_SetVideoWindow:(UIView*) w;


/**
 * Switch capture camera when in a video call
 * 
 */
+(void) fVideoCall_SwitchCaptureCamera;

#pragma mark -
#pragma Call Control API 

/**
 * Mutes or unmutes the local microphone.
 * 
 * @param isMuted
 */
+(void) fMuteMic:(BOOL) isMuted;

+(BOOL) fIsMicMuted;
/**
 * Pause or resume the current call
 * 
 * @param bIsPausing
 */
+(void) fPauseResumeCall:(BOOL) bIsPausing; 
+(BOOL) fIsCallPaused;

+(float) fGetCurrentCallQuality;

+(int) fGetCurrentCallDuration;

+(void) fPlayDTMF:(char) dtmf;
+(void) fStopDTMP;
+ (void)fSetSpeakerEnable:(BOOL) flag;
#pragma mark -
#pragma mark GroupChat

/**
 * Invite users to a certain group
 * ユーザをグループに招待
 * @return true if invitation is sent
 */
+(BOOL) fGroupChat_InviteUser: (NSString*) userID toGroup:(NSString*) groupID;




+(void)fSetIsLocalRequireVideo:(BOOL)flag;
+(BOOL)fGetIsLocalRequireVideo;


@end
