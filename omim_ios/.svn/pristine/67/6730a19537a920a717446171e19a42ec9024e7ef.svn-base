//
//  CallProcssVC.h
//  omim
//
//  Created by Coca on 3/26/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WowtalkUIDelegates.h"

@class NSTimer;
@class CallLog;

@class UIDuration;
@class UIMuteButton;
@class UICallQuality;
@class UISpeakerButton;
@class UIPauseResumeButton;
@class UIAddVideoButton;

//@class AVAudioPlayer;
@class VideoCallVC;

enum CALLSTATE {
	CallEnd=0,//=CallIdle
	OutgoCall_CalleeBusy,
	OutgoCall_CallNoAnswer,
	OutgoCall_CalleeOffline,
	OutgoCall_Init,
	OutgoCall_CalleeRinging,
	Call_Connected,
	OutgoCall_CalleeDisclined,
	IncomeCall_WaitForCallerCallAgain,
	IncomeCall_Init
};

enum VideoCall_POPUP_ACTION_MODE {
    VideoCall_NoPopup = 0,
    VideoCall_PopupToInvite,
    VideoCall_PopupToAccept,
    VideoCall_PopupToConfirm,
    VideoCall_PopupToInformReject
};

@interface CallProcessVC : UIViewController <WowTalkUICallProcessDelegate,UIAlertViewDelegate> {

	BOOL isResetingCall;

    
    BOOL mVideoShown;
	BOOL mVideoIsPending;
	BOOL mIncallViewIsReady;
    
    int alertMode;

    BOOL isRemoteRequireVideo;
    BOOL mInitWithVideo;

}

@property BOOL isVideoCallMode;
//@property BOOL isAccecpytTheCall;

@property(nonatomic,retain)	NSString* mCalleeName; //buddyID
@property(nonatomic,retain) NSString* mDisplayName;// displayname

// set up view of making a connection phase
@property (nonatomic,retain) IBOutlet UIView* uv_connection;
@property(nonatomic,retain) IBOutlet UIImageView* iv_profile;
@property(nonatomic,retain) IBOutlet UILabel* lblDisplayName;
@property(nonatomic,retain) IBOutlet UILabel* lbl_connectionstatus;
@property (nonatomic, retain) IBOutlet UIButton* btnEndCall;
@property (nonatomic,retain) IBOutlet UIButton* btnDeclineCall;
@property (nonatomic,retain) IBOutlet UIButton* btnAnswerCall;


// set up view of talking phase;
@property (nonatomic,retain) IBOutlet UIView* uv_call;
@property(nonatomic,retain) IBOutlet UICallQuality* imgCallQuality;
@property(nonatomic,retain) IBOutlet UIDuration* lblCallDuration;
@property(nonatomic,retain) IBOutlet UILabel* lbl_network;
@property(nonatomic,retain) IBOutlet UILabel* lbl_name;
@property (nonatomic,retain)IBOutlet UIButton* btnEndCall2;
@property(nonatomic,retain) IBOutlet UIMuteButton* btnMute;
@property(nonatomic,retain) IBOutlet UISpeakerButton* btnSpeaker;
@property(nonatomic,retain) IBOutlet UIPauseResumeButton* btnHold;
@property(nonatomic,retain) IBOutlet UIAddVideoButton* btnAddVideo;


@property (nonatomic,retain) IBOutlet UIImageView* iv_profile_in_call;

//@property(nonatomic,retain) IBOutlet UILabel* lblVideoCallMsg;

//set up timer;
@property (nonatomic,retain) NSTimer* mEndCallTimer;
@property (nonatomic,retain) NSTimer* mVibrateTimer;


@property(nonatomic,retain)	AVAudioPlayer* incomeCallRingtonePlayer;
@property(nonatomic,retain)	AVAudioPlayer* outgoCallRingtonePlayer;
@property(nonatomic,retain)	AVAudioPlayer* incomeMsgRingtonePlayer;

@property (assign) SystemSoundID soundCallInitiated;
@property (assign) SystemSoundID soundCallEnd;

@property (nonatomic) enum CALLSTATE  mCallState;


@property (nonatomic,retain)CallLog *callLog;

@property (nonatomic,retain) VideoCallVC* mVideoCallVC;

-(void)fShowCallView;

-(void)fEndCall;
-(void)fEndVideo;
-(IBAction)fBtnAnswerCallPressed;
-(IBAction)fBtnAnswerCallReleased;

-(IBAction)fBtnDeclineCallPressed;
-(IBAction)fBtnDeclineCallReleased;

-(IBAction)fBtnEndCallPressed;
-(IBAction)fBtnEndCallReleased;

-(IBAction)fBtnEndCall2Pressed:(id)sender;
-(IBAction)fBtnEndCall2Released:(id)sender;


-(void) fDisplayCallOutgoingViewforUser:(NSString*) BuddyID WithDisplayname:(NSString*) displayname withVideo:(BOOL)videoFlag;
-(void) fDisplayCallIncomingViewforUser:(NSString*) BuddyID WithDisplayname:(NSString*) displayname withVideo:(BOOL)videoFlag;
-(void) fdisplayIncomeCallWaitForCallerCallAgain:(NSString*) BuddyID WithDisplayname:(NSString*) displayname;
-(BOOL) fIsWaitingForCallerCallAgain;
-(void) fStopEndCallTimer;

@end
