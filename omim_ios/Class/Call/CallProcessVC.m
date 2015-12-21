//
//  CallProcessVC.m
//  omim
//
//  Created by Coca on 3/26/11.
//  Copyright 2011 WOW Technology Co.,Ltd. All rights reserved.
//

#import "CallProcessVC.h"
#import "AppDelegate.h"

#import "VideoCallVC.h"
#import "CallUIHeader.h"
#import "MessagesVC.h"

#import "MsgComposerVC.h"
#import "TabBarViewController.h"

#import "WTHeader.h"
#import "PublicFunctions.h"
#import "Constants.h"

#define TAG_ASK_FOR_ACCEPT_VIDEO_CHAT 101

@implementation CallProcessVC

@synthesize mCalleeName;
@synthesize mDisplayName;

@synthesize incomeCallRingtonePlayer;
@synthesize outgoCallRingtonePlayer;
@synthesize incomeMsgRingtonePlayer;

@synthesize uv_call,uv_connection;
@synthesize iv_profile,lblDisplayName,lbl_connectionstatus,lbl_network,lblCallDuration,lbl_name;
@synthesize btnHold,btnMute,btnSpeaker,btnAddVideo,btnEndCall,btnEndCall2,btnAnswerCall,btnDeclineCall;
@synthesize imgCallQuality;

@synthesize mEndCallTimer,mVibrateTimer;

@synthesize isVideoCallMode;



@synthesize soundCallInitiated,soundCallEnd;
@synthesize mCallState,mVideoCallVC;
@synthesize callLog;
@synthesize iv_profile_in_call;
//@synthesize isAccecpytTheCall;

-(IBAction)fBtnAnswerCallPressed{
    
    // self.btnAnswerCall.titleLabel.textColor = [Theme sharedInstance].currentTileColor;
    
}
-(IBAction)fBtnAnswerCallReleased{

    //   [self.btnAnswerCall setTitleColor:[Theme sharedInstance].currentNormalTextColor forState:UIControlStateNormal];
	
    self.lbl_connectionstatus.text= NSLocalizedString(@"Answering",nil);
    
    
    if(isRemoteRequireVideo){
        [WowTalkVoipIF fAcceptVideoCall];
    }
    else{
        [WowTalkVoipIF fAcceptCall];
        
    }

    [self fShowCallView];
}

-(IBAction)fBtnDeclineCallPressed{
    // self.btnDeclineCall.titleLabel.textColor = [Theme sharedInstance].currentTileColor;
    
}
-(IBAction)fBtnDeclineCallReleased{
    
    
    //[self.btnDeclineCall setTitleColor:[Theme sharedInstance].currentNormalTextColor forState:UIControlStateNormal];
    
    self.lbl_connectionstatus.text= NSLocalizedString(@"Declining",nil);
    [WowTalkVoipIF fTerminateCall];
}


-(IBAction)fBtnEndCallPressed{
    
 	
//      self.btnEndCall.titleLabel.textColor =  [Theme sharedInstance].currentTileColor;
    
}



-(IBAction)fBtnEndCallReleased{
    
    
//      [self.btnEndCall setTitleColor:[Theme sharedInstance].currentNormalTextColor forState:UIControlStateNormal];
    
 	self.lbl_connectionstatus.text = NSLocalizedString(@"Ending",nil);
    [self fEndCall];
    
}


-(IBAction)fBtnEndCall2Pressed:(id)sender{
    //  [self.btnEndCall2 setBackgroundColor: [Theme sharedInstance].currentBGColorForButtonInCallView];   // change theme color
    
}



-(IBAction)fBtnEndCall2Released:(id)sender{
    
    //  [self.btnEndCall2 setBackgroundColor:[Theme sharedInstance].currentTileColor];
    
	self.lbl_connectionstatus.text = NSLocalizedString(@"Ending",nil);
    [self fEndCall];
    
}


-(void)fEndCall{
    self.lblCallDuration.text= NSLocalizedString(@"Ending",nil);
	[self fStopEndCallTimer];
    [WowTalkVoipIF fTerminateCall];
    [self.mCalleeName release];
	[self endupCallProcess];
}

-(void)fEndVideo
{
    if(mVideoShown && mVideoCallVC!=nil){
        [mVideoCallVC dismissViewControllerAnimated:YES completion:nil];
        [btnAddVideo setOff];
    }
}

#pragma mark -
#pragma mark Call Log

-(void) fStartCallLogging:(NSString*)direction withContact:(NSString*)username withDisplayname:(NSString*)displayname
{
    /*	if (callLog) {
     [callLog release];
     }
     */
	self.callLog = [[[CallLog alloc]init] autorelease];
	self.callLog.startDate = [Database callLog_dateToUTCString:[NSDate date]];
	self.callLog.direction = direction;
	self.callLog.contact = username;
    self.callLog.displayName = displayname;
}

-(void) fFinalizeCallLogging:(NSInteger)duration{
	self.callLog.duration = duration;
	self.callLog.quality = 5; // we don't store this data yet
    
    
    
    //	// NSLog(@"fFinalizeCallLogging.....mCallState=%d",self.mCallState);
	
	switch (self.mCallState) {
		case OutgoCall_CalleeBusy:
		case OutgoCall_CallNoAnswer:
		case OutgoCall_CalleeOffline:
			self.callLog.status = WTCallSuccess;
            [WowTalkVoipIF fNotifyCalleeForMissedCall:self.callLog];
            
			break;
			
			
		case OutgoCall_Init:
		case OutgoCall_CalleeRinging:
		case OutgoCall_CalleeDisclined:
		case Call_Connected:
			self.callLog.status = WTCallSuccess;
			break;
			
		case IncomeCall_WaitForCallerCallAgain:
		case IncomeCall_Init:
			self.callLog.status = WTCallMissed;
			break;
            
		default:
			break;
	}
	
	[Database storeNewCallLog:self.callLog];
    
    ChatMessage* msgLog = [[[ChatMessage alloc] init] autorelease];
    msgLog.chatUserName = callLog.contact;
    msgLog.msgType = [ChatMessage MSGTYPE_CALL_LOG];
    msgLog.ioType = [callLog.direction isEqualToString:@"in"]? [ChatMessage IOTYPE_INPUT_READED]:[ChatMessage IOTYPE_OUTPUT];
    
    NSString* status = [NSString stringWithFormat:@"%d",callLog.status];
    NSString* strduration = [NSString stringWithFormat:@"%zi",callLog.duration];
    
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];

    NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:status,strduration,callLog.direction, nil] forKeys:[NSArray arrayWithObjects:CALL_RESULT_TYPE,CALL_DURATION,CALL_DIRECTION, nil]];
    
    msgLog.messageContent = [jw stringWithFragment:dictionary];
    msgLog.sentDate = [TimeHelper getCurrentTime];
    [Database storeNewChatMessage:msgLog];
    
    [AppDelegate sharedAppDelegate].needRefreshMsgComposer = TRUE;
    
	
}


#pragma mark -
#pragma mark functions
-(void) fStopEndCallTimer{
	[self performSelectorOnMainThread:@selector(fStopEndCallTimerInMainThread) withObject:nil waitUntilDone:NO];
}

-(void) fStopEndCallTimerInMainThread{
	if (self.mEndCallTimer) {
		[self.mEndCallTimer invalidate];
		self.mEndCallTimer = nil;
	}
}

-(void) fEndupCallByTimer{
	if (self.mCallState == OutgoCall_CalleeOffline || self.mCallState==IncomeCall_WaitForCallerCallAgain ) {
		[self endupCallProcess];
		return;
	}
    [WowTalkVoipIF fTerminateCall];
}

-(void) fStopAllRingtone{
	if (self.incomeCallRingtonePlayer) {
		[self.incomeCallRingtonePlayer stop];
	}
	if (self.outgoCallRingtonePlayer) {
		[self.outgoCallRingtonePlayer stop];
	}
	
}



-(void)fSystemVibrate{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

-(void)fEndVibrateTimer{
	if (self.mVibrateTimer) {
		[self.mVibrateTimer invalidate];
		self.mVibrateTimer = nil;
	}
}


-(void) rejectTheVideoCallInvite {
    [WowTalkVoipIF fRejectTheVideoCallInvite:self.mCalleeName];  //TODO
}


#pragma mark -
#pragma mark Make Call Initialization

-(void) fDisplayCallOutgoingViewforUser:(NSString*) BuddyID WithDisplayname:(NSString*) displayname withVideo:(BOOL)videoFlag
{

    self.mDisplayName = displayname;
    
    mInitWithVideo = videoFlag;
    
    self.uv_call.hidden = YES;
    self.uv_connection.hidden =NO;
    
	UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = YES;
    if (device.proximityMonitoringEnabled == YES) {
        //      NSLog(@"Ok this device support proximity, and I just enabled it");
    }
	
    // show end call button
    self.btnEndCall.hidden = NO;
    self.btnDeclineCall.hidden = YES;
    self.btnAnswerCall.hidden = YES;
	
    [self.lblDisplayName setText:displayname];
    
    NSData* data = [AvatarHelper getThumbnailForUser:BuddyID];
    if (data) {
        [self.iv_profile setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.iv_profile setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }
    
	
	//show calling status
	[self.lbl_connectionstatus setText:NSLocalizedString(@"Calling...",nil)];
    
    
    [self.btnEndCall setTitleColor:[Colors whiteColor] forState:UIControlStateNormal];
	
	self.mCalleeName = BuddyID;  // it is the buddy id; UUID
    self.mDisplayName = displayname; // it is the real number.
    
	if (self.outgoCallRingtonePlayer == nil) {
		NSString *outgoCallRingtone = [[NSBundle mainBundle] pathForResource:@"Ringing" ofType:@"aif"];
		self.outgoCallRingtonePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:outgoCallRingtone] error:NULL] autorelease];
		self.outgoCallRingtonePlayer.delegate = nil;
		[self.outgoCallRingtonePlayer setNumberOfLoops:-1];
	}
	if (![self.outgoCallRingtonePlayer isPlaying]) {
		[self.outgoCallRingtonePlayer prepareToPlay];
		[self.outgoCallRingtonePlayer play];
	}
	self.mCallState = OutgoCall_Init;
	
	[self fStartCallLogging:@"out" withContact:self.mCalleeName withDisplayname:self.mDisplayName];
    
}

-(BOOL) fIsWaitingForCallerCallAgain{
    return (self.mCallState == IncomeCall_WaitForCallerCallAgain);
}


// pass in the caller phonenumber.
-(void) fDisplayCallIncomingViewforUser:(NSString*)BuddyID WithDisplayname:(NSString *)displayname withVideo:(BOOL)videoFlag
{

    /*
    if([[AppDelegate sharedAppDelegate] isCallFromMsgComposer])
    {
        [[[[[AppDelegate sharedAppDelegate] messagesViewController] msgComposer]uv_barcontainer] setHidden:YES];
    }
    */
    
    self.uv_call.hidden = YES;
    self.uv_connection.hidden =NO;
    
	if (self.mCallState != CallEnd && self.mCallState != IncomeCall_WaitForCallerCallAgain) {
		return;
	}
    
    mInitWithVideo = videoFlag;
    
	[self fStopEndCallTimer];
	self.mCalleeName = BuddyID;  // uuid
    self.mDisplayName = displayname; // the real number;
    //    self.mCalleeName = calleebuddy.phoneNumber;
    
    
	if (self.mCallState == CallEnd ) {
        
		UIDevice *device = [UIDevice currentDevice];
		device.proximityMonitoringEnabled = YES;

		
		//show answer and decline button
        self.btnAnswerCall.hidden = NO;
        self.btnDeclineCall.hidden = NO;
        self.btnEndCall.hidden = YES;
        
        [self.btnAnswerCall setTitleColor:[Colors whiteColor] forState: UIControlStateNormal];
        [self.btnDeclineCall setTitleColor:[Colors whiteColor] forState: UIControlStateNormal];
		
        [self.lblDisplayName setText:displayname];
		
        NSData* data = [AvatarHelper getThumbnailForUser:BuddyID];
        if (data) {
            [self.iv_profile setImage:[UIImage imageWithData:data]];
        }
        else{
            [self.iv_profile setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        }
        
        isRemoteRequireVideo= videoFlag;
		//show call status
        if(isRemoteRequireVideo){
            [self.lbl_connectionstatus setText:NSLocalizedString(@"Videocall incoming...",nil)];
        }
        else{
            [self.lbl_connectionstatus setText:NSLocalizedString(@"Call incoming...",nil)];
        }
		
		if (self.incomeCallRingtonePlayer == nil) {
			NSString *incomeCallRingtone = [[NSBundle mainBundle] pathForResource:@"JakeFive" ofType:@"aif"];
			self.incomeCallRingtonePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:incomeCallRingtone] error:NULL] autorelease];
			self.incomeCallRingtonePlayer.delegate = nil;
			[self.incomeCallRingtonePlayer setNumberOfLoops:-1];
		}
		if (![self.incomeCallRingtonePlayer isPlaying]) {
			[self.incomeCallRingtonePlayer prepareToPlay];
			[self.incomeCallRingtonePlayer play];
		}
        [self fSystemVibrate];
		self.mCallState = IncomeCall_Init;
		[self fStartCallLogging:@"in" withContact:BuddyID withDisplayname:self.mDisplayName];
        
		self.mVibrateTimer= [NSTimer scheduledTimerWithTimeInterval:1.5
                                                             target:self
                                                           selector:@selector(fSystemVibrate)
                                                           userInfo:nil
                                                            repeats:YES];
		
	}
    
	else if(self.mCallState == IncomeCall_WaitForCallerCallAgain)
    {
        //[WowTalkVoipIF fAcceptCall];
        [self fBtnAnswerCallReleased];
	}
}

-(void) fdisplayIncomeCallWaitForCallerCallAgain:(NSString*)BuddyID WithDisplayname:(NSString *)displayname
{
    
    self.mDisplayName = displayname;
    
    self.uv_connection.hidden = NO;
    self.uv_call.hidden = YES;
	UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = YES;

	
    // show answer and declien button;
	self.btnAnswerCall.hidden = YES;
    self.btnDeclineCall.hidden = YES;
    self.btnEndCall.hidden = NO;
    
    
    [self.lblDisplayName setText:self.mDisplayName];
    
    
    NSData* data = [AvatarHelper getThumbnailForUser:BuddyID];
    if (data) {
        [self.iv_profile setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.iv_profile setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }
    
    
    self.mCalleeName = BuddyID;
    self.mDisplayName = displayname;
    
    
    
	//show calling status
	[self.lbl_connectionstatus setText:NSLocalizedString(@"Answering",nil)];
    
	//show calling status
	
	self.mCallState = IncomeCall_WaitForCallerCallAgain;
	
	self.mEndCallTimer= [NSTimer scheduledTimerWithTimeInterval:20.0
                                                         target:self
                                                       selector:@selector(fEndupCallByTimer)
                                                       userInfo:nil
                                                        repeats:YES];
	
	[self fStartCallLogging:@"in" withContact:BuddyID withDisplayname:self.mDisplayName];
    
}


#pragma mark -
#pragma mark WowTalkUICallProcessDelegate

-(void) endupCallProcess {
	if (self.mCallState == CallEnd) {
		return;
	}
    //	NSLog(@"CallProcess:endupCallProcess");
    
	if (isResetingCall) {
		isResetingCall = NO;
		return;
	}
    
	[self fEndVibrateTimer];
	[self fStopEndCallTimer];
	[self fStopAllRingtone];
    
	[self fFinalizeCallLogging:[self.lblCallDuration getDuration]];
	
	//cancel local notification, just in case
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]
		&& [UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground ) {
		// cancel local notif if needed
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}
    
	[self.lblCallDuration stop];
	[self.imgCallQuality stop];
    //	[vInCallFuction setHidden:YES];
	[self.lblCallDuration setText:NSLocalizedString(@"Ending",nil)];
    
	UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = NO;
	
	
    
	self.mCallState = CallEnd;
    //	NSLog(@"mCallState-->CallEnd");
	
    [self.btnAddVideo setOff];
    [self.btnAddVideo setEnabled:true];
    if (mVideoShown)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self dismissViewControllerAnimated:NO completion:nil];
        mVideoShown=FALSE;
    }
    
    [self.btnSpeaker setOff];
    
    
	[self performSelector:@selector(fDismissMyself) withObject:nil afterDelay:1.0];
    
    
    
    
}

-(void)fDismissMyself
{
    
	[self.lblDisplayName setText:@""];
	
	[self.lblCallDuration setText:@""];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
    if([[AppDelegate sharedAppDelegate] isCallFromMsgComposer])
    {
        [[[[[AppDelegate sharedAppDelegate] messagesViewController] msgComposer] uv_barcontainer] setHidden:NO];
        
    }
     */
    
}


-(void) displayCallRingingWhenCalleeOffline:(NSString*) username withDisplayName:(NSString *)displayname {
    //	NSLog(@"CallProcess:displayCallRingingWhenCalleeOffline:%@",username);
    
	if(self.mCallState!=OutgoCall_Init || ![username isEqualToString:self.mCalleeName])
    {
		return;
	}
	
	self.mCallState = OutgoCall_CalleeOffline;
	
	self.mEndCallTimer= [NSTimer scheduledTimerWithTimeInterval:30.0
                                                         target:self
                                                       selector:@selector(fEndupCallByTimer)
                                                       userInfo:nil
                                                        repeats:YES];
    
	
}



-(void) displayCallConnectedForUser:(NSString*) BuddyID withDisplayName:(NSString *)displayname{
    NSLog(@"CallProcess:displayCallConnectedForUser:%@",displayname);

	[self fEndVibrateTimer];
	[self fStopEndCallTimer];
	[self fStopAllRingtone];
	
    self.uv_connection.hidden = YES;
    self.uv_call.hidden = NO;
    
	isResetingCall = NO;
	
    
    [self.lblCallDuration start];
	[self.imgCallQuality start];

    
    NSData* data = [AvatarHelper getThumbnailForUser:BuddyID];
    if (data) {
        [self.iv_profile_in_call setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.iv_profile_in_call setImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }
    
    
    [self.lbl_name setText:mDisplayName];
	
    self.lbl_name.textColor = [UIColor whiteColor];
    self.lblCallDuration.textColor = [UIColor whiteColor];
    
    
    [self.btnHold setEnabled:true];
    
	[self.btnSpeaker reset];
	[self.btnMute reset];
    [self.btnHold reset];
    [self.btnAddVideo reset];
    
    
    self.btnAddVideo.mCalleeName = self.mCalleeName;  // TOdo
    
	self.mCallState = Call_Connected;
    [self fShowCallView];
}
//status reporting
-(void) displayStatus:(NSString*) message {
	//[status setText:message];
    //	NSLog(@"---status msg-->%@",message);
}

-(void) displayCalleeBusy:(NSString*) username withDisplayName:(NSString *)displayname{
    //	NSLog(@"CallProcess:displayCalleeBusy:%@",username);
	self.mCallState = OutgoCall_CalleeBusy;
	[self.lblCallDuration setText:NSLocalizedString(@"User is busy.Stop calling...",nil)];
	[self fStopAllRingtone];
	[self performSelector:@selector(endupCallProcess) withObject:nil afterDelay:2.0];
    
	
}

-(void) displayCallTimeout:(NSString*) username withDisplayName:(NSString *)displayname{
    //	NSLog(@"CallProcess:displayCallTimeout:%@",username);
	self.mCallState = OutgoCall_CallNoAnswer;
	[self.lblCallDuration setText:NSLocalizedString(@"Nobody answer.Stop calling...",nil)];
	[self fStopAllRingtone];
	[self performSelector:@selector(endupCallProcess) withObject:nil afterDelay:2.0];
}


-(void) displayCalleeRinging:(NSString*) username withDisplayName:(NSString *)displayname{
	
    //	NSLog(@"CallProcess:displayCalleeRinging:%@",username);
	self.mCallState = OutgoCall_CalleeRinging;
	[self.lbl_connectionstatus setText:NSLocalizedString(@"Remote Ringing...",nil)];
    
}

-(void) displayPausedByCallee:(NSString*) username withDisplayName:(NSString *)displayname{
    // // // NSLog(@"CallProcess:displayPausedByCallee:%@",username);
	[self.lblCallDuration pause:2];
    [self.btnHold setEnabled:false];
    [self.btnAddVideo setEnabled:false];
}
-(void) displayPausedByMe{
    //    // NSLog(@"CallProcess:displayPausedByMe");
    [self.lblCallDuration pause:1];
    [self.btnAddVideo setEnabled:false];
}

-(void) displayResume{
    [self.lblCallDuration resume];
    [self.btnHold setEnabled:true];
    [self.btnAddVideo setEnabled:true];
    
}

-(void) displayVideoRequest:(NSString*) username withDisplayName:(NSString *)displayname withVideo:(BOOL)videoFlag{

    
    if(![self.mCalleeName isEqualToString:username]){
        return;
    }
    
    if(videoFlag){
        if(mInitWithVideo){
            [btnAddVideo acceptVideo];
            
        }
        else{
            // change to a simple alertview
            // [self fShowPopupWithMode:VideoCall_PopupToConfirm];
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Do you accept the videochat invitaion", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Reject", nil) otherButtonTitles:NSLocalizedString(@"Accecpt", nil), nil];
            
            [alertview show];
            alertMode = 1;
            
            [alertview release];
            
            if (self.incomeMsgRingtonePlayer == nil) {
                NSString *incomeCallRingtone = [[NSBundle mainBundle] pathForResource:@"Msg" ofType:@"caf"];
                self.incomeMsgRingtonePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:incomeCallRingtone] error:NULL] autorelease];
                self.incomeMsgRingtonePlayer.delegate = nil;
                [self.incomeMsgRingtonePlayer setNumberOfLoops:0];
            }
            if (![self.incomeMsgRingtonePlayer isPlaying]) {
                [self.incomeMsgRingtonePlayer prepareToPlay];
                [self.incomeMsgRingtonePlayer play];
            }
            
            [self fSystemVibrate];
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        }
    }
    else{
        [self fEndVideo];
    }
}

-(void) displayVideoCallRejected:(NSString*) username withDisplayName:(NSString *)displayname{
    
    if(![self.mCalleeName isEqualToString:username])
    {
        return;
    }
    [self.btnAddVideo setOff];
    
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your invitation is rejected", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alertview show];
    alertMode = 2;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertMode == 1) {
        if (buttonIndex == 1) {
            [self.btnAddVideo acceptVideo];
        }
        else{
            [self rejectTheVideoCallInvite];
            [self.btnAddVideo setOff];
        }
    }
}



-(void) getCalleeBackOnlineMessage:(NSString*) username withDisplayName:(NSString *)displayname{
//	NSLog(@"CallProcess:getCalleeBackOnlineMessage:%@",username);
	
	if (self.mCallState==OutgoCall_CalleeOffline && [self.mCalleeName isEqualToString:username]) {
        
        
        [WowTalkVoipIF fNewOutgoingCall:username withDisplayName:self.mDisplayName withVideo:NO];
		[self fStopEndCallTimer];
		return;
	}
	
	//in case we dont get "Not Online" response from server but the callee was offline and send a notification after it get back online
	if (self.mCallState==OutgoCall_Init) {
		isResetingCall = YES;
		self.mCallState = OutgoCall_CalleeOffline;
		
		self.mEndCallTimer= [NSTimer scheduledTimerWithTimeInterval:30.0
                                                             target:self
                                                           selector:@selector(fEndupCallByTimer)
                                                           userInfo:nil
                                                            repeats:YES];

        [WowTalkVoipIF fTerminateCall];
        [WowTalkVoipIF fNewOutgoingCall:username withDisplayName:displayname withVideo:NO];
        //		[self.mCalleeName release];
		return;
	}
}


-(void) getMissedCallMessage:(NSString*) username withDisplayName:(NSString *)displayname On:(NSDate *)startDate{
	// NSLog(@"you missed a call from %@ on %@",displayname,[startDate description]);
	
    CallLog* missedCallLog = [[[CallLog alloc]init] autorelease];
	missedCallLog.startDate = [Database callLog_dateToUTCString:startDate];
	missedCallLog.direction = @"in";
	missedCallLog.contact = username;
    missedCallLog.displayName = displayname;
	missedCallLog.status = WTCallMissed;
	missedCallLog.duration = 0;
	missedCallLog.quality = 5;
	[Database storeNewCallLog:missedCallLog];
    //	[missedCallLog release];
	
	//TODO ELVIS
	if ([AppDelegate sharedAppDelegate].tabbarVC.selectedIndex != 0)
    {
		int badgeValue = ++[AppDelegate sharedAppDelegate].unread_message_count;
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		[defaults setInteger:badgeValue forKey:UNREAD_MESSAGE_NUMBER];
		[defaults synchronize];
		
        [[[AppDelegate sharedAppDelegate] tabbarVC] refreshCustomBarUnreadNum];
	}
	else {
        
        //	[[[wowtalkAppDelegate sharedAppDelegate] myRecentCall] fRefreshTableData];
	}
    
    ChatMessage* msgLog =[[ChatMessage alloc]init];
    msgLog.chatUserName = missedCallLog.contact;
    msgLog.msgType = [ChatMessage MSGTYPE_CALL_LOG];
    msgLog.ioType = [ChatMessage IOTYPE_INPUT_UNREAD];
    SBJsonWriter* jw = [[[SBJsonWriter alloc] init] autorelease];
    
    NSString* status = [NSString stringWithFormat:@"%d",missedCallLog.status];
    NSString* strduration = [NSString stringWithFormat:@"%zi",missedCallLog.duration];
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:status,strduration,missedCallLog.direction, nil] forKeys:[NSArray arrayWithObjects:CALL_RESULT_TYPE,CALL_DURATION,CALL_DIRECTION, nil]];
    
    msgLog.messageContent = [jw stringWithFragment:dictionary];
    msgLog.sentDate = [TimeHelper getCurrentTime];
    [Database storeNewChatMessage:msgLog];
    
    [msgLog release];
    [AppDelegate sharedAppDelegate].needRefreshMsgComposer = TRUE;
    
}

-(void)displayCallFail:(NSString *)username withDisplayName:(NSString *)displayname forReason:(NSString *)reason
{
    /*
     if ([[AppDelegate sharedAppDelegate] isCallFromDialPad])
     {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[ABUtil fTranslatePhoneNumberToUserName:displayname]]]];
     }
     */
    
}

//TODO ,NO NEED to exsit  // Call a normal phonenumber
-(void) displayMakeRegularCall:(NSString*)phonenumber{
	[self fStopAllRingtone];
	[self endupCallProcess];
	self.mCalleeName = phonenumber;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:@"MAKE_REGULAR_CALL_FOR_NONUSER"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mCalleeName]]];
		//TODO:add call log here
	}
	else{
		UIAlertView* error = [[UIAlertView alloc]	initWithTitle:nil
														message:NSLocalizedString(@"User you are calling doesn't have WowTalk account.\n\nDo you want to place a regular call instead?",nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
											  otherButtonTitles:NSLocalizedString(@"Yes",nil),NSLocalizedString(@"Yes and don't ask me again",nil),nil];
		
        //temp		error.tag = TAG_ASK_FOR_REGULAR_CALL;
		[error show];
		[error release];
	}
	
}


-(void) displayVideoCall:(NSString*) username withDisplayName:(NSString *)displayname{
    
    //TODO: remove the old alertview
    
    // we will only get here when both accept video call
    if (mVideoShown) {
        return;
    }
   	if (mIncallViewIsReady) {
        
        //     [lblVideoCallMsg setText:NSLocalizedString(@"Establishing the video call...", nil)];
        
        // TODO Elvis;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        mVideoShown=TRUE;
        if(self.mVideoCallVC ==nil){
            self.mVideoCallVC =  [[[VideoCallVC alloc]  initWithNibName:@"VideoCallVC"
                                                                 bundle:[NSBundle mainBundle]] autorelease];
        }
        
        //       [lblVideoCallMsg setText:NSLocalizedString(@"Video call has been set up", nil)];
        
        //    [self.view setFrame:CGRectMake(0, 0, 320, 480)];
       // [self.mVideoCallVC setWantsFullScreenLayout:YES];
      //  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            [self.mVideoCallVC setWantsFullScreenLayout:YES];
      
        
        [self presentViewController:self.mVideoCallVC animated:YES completion:nil];
        
        
        // NSLog(@"call view frame:x: %f ,y:%f , w: %f , h: %f ", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
        [self fSystemVibrate];
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
	}
    else {
		//postepone presentation
		mVideoIsPending=TRUE;
	}
    
    
}

#pragma  mark - Show Views

-(void) fShowCallView
{
    
    // NSLog(@"CallProcess:: fshowCallView");
    self.uv_connection.hidden = YES;
    self.uv_call.hidden = NO;
    
    self.uv_call.backgroundColor = [UIColor clearColor];
    
    self.btnAddVideo.enabled = TRUE; // temp do this.
    
    [self.btnEndCall2 setBackgroundImage:[UIImage imageNamed:@"btn_endcall.png"] forState:UIControlStateNormal];
    [self.btnEndCall2 setBackgroundImage:[UIImage imageNamed:@"btn_endcall_p.png"] forState:UIControlStateNormal];
    
    [self.btnEndCall2 setTitle:NSLocalizedString(@"End Call", nil) forState:UIControlStateNormal];
    [self.btnEndCall2 setTitleColor:[Colors whiteColor] forState:UIControlStateNormal];
    
    [self.btnMute initWithOnImage:[UIImage imageNamed:@"call_mute_a.png"] offImage:[UIImage imageNamed:@"call_mute.png"]];
    [self.btnHold initWithOnImage:[UIImage imageNamed:@"call_hold_a.png"] offImage:[UIImage imageNamed:@"call_hold.png"]];
    [self.btnSpeaker initWithOnImage:[UIImage imageNamed:@"call_speaker_a.png"] offImage:[UIImage imageNamed:@"call_speaker.png"]];
    [self.btnAddVideo initWithOnImage:[UIImage imageNamed:@"call_videocall_a.png"] offImage:[UIImage imageNamed:@"call_videocall.png"] displayInVC:self];
    
    self.lblCallDuration.textColor = [UIColor whiteColor];
    //   self.lbl_network.text = NSLocalizedString(@"Network", nil);
    //   self.lbl_network.textColor = [Theme sharedInstance].currentNormalTextColor;
    self.lbl_name.textColor = [UIColor whiteColor];
    //  // NSLog(@"aaaaa");
    
    
}


#pragma mark -
#pragma mark View Delagate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.mCallState = CallEnd;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.uv_connection.hidden = NO;
    self.uv_call.hidden = YES;
    
    self.lblDisplayName.text = @"Sekki";
    self.lbl_connectionstatus.text = @"incoming";
    
    [self.btnAnswerCall setBackgroundImage:[UIImage imageNamed:@"btn_answer.png"] forState:UIControlStateNormal];
    [self.btnAnswerCall setBackgroundImage:[UIImage imageNamed:@"btn_answer_p.png"] forState:UIControlStateSelected];
    [self.btnDeclineCall setBackgroundImage:[UIImage imageNamed:@"btn_decline.png"] forState:UIControlStateNormal];
    [self.btnDeclineCall setBackgroundImage:[UIImage imageNamed:@"btn_decline_p.png"] forState:UIControlStateNormal];
    
    [self.btnEndCall setBackgroundImage:[UIImage imageNamed:@"btn_endcall.png"] forState:UIControlStateNormal];
    [self.btnEndCall setBackgroundImage:[UIImage imageNamed:@"btn_endcall_p.png"] forState:UIControlStateNormal];
    
    self.btnEndCall.hidden = YES;
    self.btnAnswerCall.hidden = YES;
    self.btnDeclineCall.hidden = YES;
    
    // set up button title
	[self.btnEndCall setTitle:NSLocalizedString(@"End",nil) forState:UIControlStateNormal];
	[self.btnAnswerCall setTitle:NSLocalizedString(@"Answer",nil) forState:UIControlStateNormal];
	[self.btnDeclineCall setTitle:NSLocalizedString(@"Decline",nil) forState:UIControlStateNormal];
    
    [self.btnEndCall setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAnswerCall setTitleColor:[UIColor whiteColor]forState: UIControlStateNormal];
    [self.btnDeclineCall setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];

    self.lblDisplayName.textColor = [UIColor whiteColor];
    self.lbl_connectionstatus.textColor = [UIColor whiteColor];

    
    mVideoShown=FALSE;
	mIncallViewIsReady=FALSE;
	mVideoIsPending=FALSE;
   /*
    if (IS_IOS7) {
        [self.view setAutoresizesSubviews:FALSE];
        [self.view setAutoresizingMask:UIViewAutoresizingNone];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }*/
    
    
    // 加入是否插入耳机监听 by yangbin
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    
}

- (void)outputDeviceChanged:(NSNotification *)notif{
    NSDictionary *dict = notif.userInfo;
    
    NSInteger reasonKey = [dict[AVAudioSessionRouteChangeReasonKey] integerValue];
    UInt32 audioRouteOverride;
    switch (reasonKey) {
        case kAudioSessionRouteChangeReason_NewDeviceAvailable:{
         // 有新设备插入
            NSLog(@"有新设备插入");
            audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        }break;
        case kAudioSessionRouteChangeReason_OldDeviceUnavailable:{
            // 原有设备拔出
            NSLog(@"原有设备拔出");
            audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        }break;
        case kAudioSessionRouteChangeReason_NoSuitableRouteForCategory:{
            // 没有合适的设备
            NSLog(@"没有合适的设备");
            audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        }break;
            
        default:
            break;
    }
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}




- (void)viewDidAppear:(BOOL)animated {
    
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [AppDelegate sharedAppDelegate].isMyCallProcessVCShown = YES;
    
	[self.btnMute reset];
	[self.btnSpeaker reset];
    [self.btnHold reset];
    [self.btnAddVideo reset];
    mIncallViewIsReady=TRUE;
    if (mVideoIsPending) {
        mVideoIsPending=FALSE;
    }

}


- (void)viewDidDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [AppDelegate sharedAppDelegate].isMyCallProcessVCShown = NO;
}


-(void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    //    if (!self.isViewLoaded && !self.view.window)
    {
        //add some release operation here
        //   self.popup = nil;
        //   self.popup_title = nil;
        
    }
}

- (void)dealloc {
    
    self.uv_connection =nil;
    self.iv_profile = nil;
    self.lblDisplayName = nil;
    self.lbl_connectionstatus = nil;
    self.btnEndCall = nil;
    self.btnDeclineCall = nil;
    self.btnAnswerCall = nil;
    
    self.uv_call =nil;
    self.imgCallQuality = nil;
    self.lblCallDuration = nil;
    self.lbl_network = nil;
    self.lbl_name = nil;
    self.btnEndCall2 = Nil;
    self.btnMute = nil;
    self.btnSpeaker = nil;
    self.btnHold = nil;
    self.btnAddVideo = nil;
    
    
    self.callLog = nil;
    
    self.mCalleeName = nil;
    self.mDisplayName = nil;
    
    self.incomeCallRingtonePlayer = nil;
	self.outgoCallRingtonePlayer =nil;
    self.incomeMsgRingtonePlayer =nil;
    
    self.mEndCallTimer = nil;
    self.mVibrateTimer = nil;
    
    self.mVideoCallVC = nil;
    
    [super dealloc];
}

@end
