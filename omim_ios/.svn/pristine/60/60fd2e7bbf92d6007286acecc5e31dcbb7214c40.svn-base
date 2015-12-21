//
//  VoiceMessagePlayer.m
//  omim
//
//  Created by coca on 2012/10/28.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "VoiceMessagePlayer.h"
#import "Moment.h"

@implementation VoiceMessagePlayer

@synthesize delegate = _delegate;
@synthesize recordPlayer = _recordPlayer;
@synthesize timer = _timer;
@synthesize filepath =_filepath;
@synthesize isPlaying=_isPlaying;
@synthesize isLocked = _isLocked;

static  VoiceMessagePlayer * voiceMessagePlayer = nil;

+ (VoiceMessagePlayer *)sharedInstance
{
	
    // check to see if an instance already exists
    if (nil == voiceMessagePlayer) {
        voiceMessagePlayer  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return voiceMessagePlayer;
}

-(void)playVoiceMessage
{
    // NSLog(@"play the record");
    // if the voice message is locked , just return. can't play.
    
    // make it work even in the mute mode
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    if (self.isLocked == TRUE)
    {
        return;
    }
    
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying)
    {
        self.isPlaying = FALSE;
        self.playingTime = 0;
        
        [self.recordPlayer stop];
        
        [self.timer invalidate];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didStopPlayingVoice:)])
        {
            [self.delegate didStopPlayingVoice:self];
        }
        return;
    }
    else
    {
        if(!self.filepath) return;
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(willStartToPlayVoice:)])
        {
            [self.delegate willStartToPlayVoice:self];
        }
        
        
        self.recordPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.filepath] error:NULL] autorelease];
        self.recordPlayer.delegate = self;
        [self.recordPlayer setNumberOfLoops:0];
        
        [self.recordPlayer prepareToPlay];

        if(self.timer!=nil && self.timer.isValid) [self.timer invalidate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        
        self.playingTime = 0;
        
        [self.recordPlayer play];
        
        self.isPlaying = TRUE;
        
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
     [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    [self.timer invalidate];
    self.timer = nil;
    self.isPlaying = FALSE;
    self.playingTime = 0;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didStopPlayingVoice:)])
    {
        [self.delegate didStopPlayingVoice:self];
    }
}

-(void)stopPlayingVoiceMessage
{
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    self.playingTime = 0;
    
    [self.timer invalidate];
    self.timer = nil;
    self.isPlaying = FALSE;
    
    if (self.recordPlayer != nil && self.recordPlayer.isPlaying)
    {
        [self.recordPlayer stop];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didStopPlayingVoice:)])
    {
        [self.delegate didStopPlayingVoice:self];
    }
    
    self.record_button = nil;
    
}

-(void)timerHandle
{
    self.playingTime ++;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(timeHandler:)])
    {
        [self.delegate timeHandler:self];
    }
 
}


-(void)setRecord_button:(UIButton *)record_button{
    _record_button.selected = NO;
    [_record_button release],_record_button = nil;
    _record_button = [record_button retain];
}

-(void)setOpenProximityMonitoring:(BOOL)openProximityMonitoring{
    
    _openProximityMonitoring = openProximityMonitoring;
    
    
    if (_openProximityMonitoring){
        
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(sensorStateChange:)
         
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
         
                                                   object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


-(void)sensorStateChange:(NSNotificationCenter *)notification;

{
    
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    
    if ([[UIDevice currentDevice] proximityState] == YES)
        
    {
        
        NSLog(@"Device is close to user");
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        
    }
    
    else
        
    {
        
        NSLog(@"Device is not close to user");
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
    }
    
}



@end
