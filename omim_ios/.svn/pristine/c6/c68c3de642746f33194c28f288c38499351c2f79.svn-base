/* WowtalkUIDelegates.h
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */   
#import <UIKit/UIKit.h>
#import "ChatMessage.h"



#pragma mark -
#pragma mark Delegate for Voip Behavior

@protocol WowTalkUIMakeCallDelegate
// UI changes
-(void) displayOutgoingCallForUser:(NSString*) username withDisplayName:(NSString*)displayname withVideo:(BOOL)videoFlag;
-(void) displayIncomingCallForUser:(NSString*) username withDisplayName:(NSString*)displayname withVideo:(BOOL)videoFlag;
@end

@protocol WowTalkUICallProcessDelegate
//calls
-(void) endupCallProcess;
-(void) displayCallConnectedForUser:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayCallRingingWhenCalleeOffline:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayCalleeBusy:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayCalleeRinging:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayCallTimeout:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayPausedByCallee:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayPausedByMe;
-(void) displayResume;
//video
-(void) displayVideoCall:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) displayVideoRequest:(NSString*) username withDisplayName:(NSString*)displayname withVideo:(BOOL)videoFlag;
-(void) displayVideoCallRejected:(NSString*) username withDisplayName:(NSString*)displayname;
//messafge
-(void) getCalleeBackOnlineMessage:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) getMissedCallMessage:(NSString*) username withDisplayName:(NSString*)displayname On:(NSDate*)startDate;
//status reporting
-(void) displayStatus:(NSString*) message; 
//regular call
-(void) displayMakeRegularCall:(NSString*)phoneNumber;


//callee wont accept this call
-(void) displayCallFail:(NSString*)username withDisplayName:(NSString*)displayname forReason:(NSString*)reason;
// Reason can be :  Not Found, Not Allow,
//
//


@end

@protocol WowTalkUIChatMessageDelegate
-(void) getChatMessage:(ChatMessage*) msg;
-(void) getChatMessage_ReachedReceipt:(NSInteger)messageID fromUser:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) getChatMessage_ReadedReceipt:(NSInteger)messageID fromUser:(NSString*) username withDisplayName:(NSString*)displayname;
-(void) sentChatMessage:(ChatMessage*) msg;
@end


@protocol  WowTalkNotificationDelegate
-(void) getBuddyListIncreaseNotification:(NSString*)uid withDisplayName:(NSString*)displayName;
-(void) getBuddyListDecreaseNotification:(NSString*)uid withDisplayName:(NSString*)displayName;
-(void) getActiveAppTypeChangeNotification:(NSString*)app_type;

@end





#pragma mark -
#pragma mark Delegate for Network Interface exit

@protocol NetworkIFDidFinishDelegate<NSObject>


- (void) didFinishNetworkIFCommunicationWithTag:(int)tag withData:(NSObject*) data;
- (void) didFailNetworkIFCommunicationWithTag:(int)tag withData:(NSObject*) data;

@optional
- (void) didFinishNetworkIFCommunicationWithTag:(int)tag withUserData:(NSObject*) userData withData:(NSObject*) data;
- (void) didFailNetworkIFCommunicationWithTag:(int)tag withUserData:(NSObject*) userData withData:(NSObject*) data;


-(void) networkTaskDidFailWithReturningData:(NSObject*)data error:(NSError*)error;
-(void) networkTaskDidFinishWithReturningData:(NSObject*)data error:(NSError*)error;

@end









