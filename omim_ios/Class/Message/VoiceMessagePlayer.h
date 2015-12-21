//
//  VoiceMessagePlayer.h
//  omim
//
//  Created by coca on 2012/10/28.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@class VoiceMessagePlayer;
@class  Moment;

@protocol VoiceMessagePlayerDelegate <NSObject>
@optional
-(void)didStopPlayingVoice:(VoiceMessagePlayer*)requestor;
-(void)willStartToPlayVoice:(VoiceMessagePlayer*)requestor;
-(void)timeHandler:(VoiceMessagePlayer*)requestor;


@end

@interface VoiceMessagePlayer : NSObject<AVAudioPlayerDelegate>


+(VoiceMessagePlayer*) sharedInstance;

@property BOOL isPlaying;
@property BOOL isLocked;

@property (assign, nonatomic) BOOL openProximityMonitoring;


@property (nonatomic,assign) id <VoiceMessagePlayerDelegate> delegate;
@property (nonatomic,retain) NSString* filepath;

@property (nonatomic,retain) AVAudioPlayer* recordPlayer;

@property (nonatomic,retain)  NSTimer *timer;

// for playing voice in timeline;

@property int playingTime;
@property int totalLength;
@property (nonatomic,retain) Moment* moment;
@property (nonatomic,retain) NSIndexPath* indexpath;

-(void)playVoiceMessage;
-(void)stopPlayingVoiceMessage;




// add by yangbin for new momentcell

@property (retain, nonatomic)UIButton *record_button;

@end
