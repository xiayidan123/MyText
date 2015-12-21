//
//  SpeakerHelper.m
//  omimbiz
//
//  Created by elvis on 2013/10/17.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "SpeakerHelper.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation SpeakerHelper
+(void)openSpeaker
{
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
}
+(void)closeSpeaker
{
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
}
@end
