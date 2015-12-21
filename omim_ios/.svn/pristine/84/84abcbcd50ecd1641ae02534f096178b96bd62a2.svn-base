/* UISpeakerButton.m
 *
 *  wowtalk
 *
 *  Created by eki-chin on 11/03/19.
 *  Copyright 2011 WowTech Inc.. All rights reserved.
 * 
 */       

#import "UISpeakerButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WowTalkVoipIF.h"
@implementation UISpeakerButton

static void audioRouteChangeListenerCallback (
                                       void                   *inUserData,                                 // 1
                                       AudioSessionPropertyID inPropertyID,                                // 2
                                       UInt32                 inPropertyValueSize,                         // 3
                                       const void             *inPropertyValue                             // 4
                                       ) {
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return; // 5
    [(UISpeakerButton*)inUserData reset];  
   
}

-(void) initWithOnImage:(UIImage*) onImage offImage:(UIImage*) offImage {
   [super initWithOnImage:onImage offImage:offImage];
   AudioSessionPropertyID routeChangeID = kAudioSessionProperty_AudioRouteChange;
   AudioSessionInitialize(NULL, NULL, NULL, NULL);
   OSStatus lStatus = AudioSessionAddPropertyListener(routeChangeID, audioRouteChangeListenerCallback, self);
   if (lStatus) {
       // NSLog(@"cannot register route change handler [%ld]",lStatus);
   }
}

-(void) initWithOnColor:(UIColor *)onColor offColor:(UIColor *)offColor
{
    [super initWithOnColor:onColor offColor:offColor];
    AudioSessionPropertyID routeChangeID = kAudioSessionProperty_AudioRouteChange;
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus lStatus = AudioSessionAddPropertyListener(routeChangeID, audioRouteChangeListenerCallback, self);
    if (lStatus) {
        // NSLog(@"cannot register route change handler [%ld]",lStatus);
    }
    
}
/*
-(void) onOn {
	//redirect audio to speaker
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
							 , sizeof (audioRouteOverride)
							 , &audioRouteOverride);
	
}

-(void)setOff{
    [self onOff];
}
-(void) onOff {
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;  
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
							 , sizeof (audioRouteOverride)
							 , &audioRouteOverride);
}
*/
-(void)setOff{
    [self onOff];
}



- (void)onOn {
	[WowTalkVoipIF fSetSpeakerEnable:TRUE];
}

- (void)onOff {
	[WowTalkVoipIF fSetSpeakerEnable:FALSE];
}
-(bool) isInitialStateOn {
    CFStringRef lNewRoute=CFSTR("Unknown");
    UInt32 lNewRouteSize = sizeof(lNewRoute);
    OSStatus lStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                                                ,&lNewRouteSize
                                                ,&lNewRoute);
    if (!lStatus && CFStringGetLength(lNewRoute) > 0) {
        char route[64];
        CFStringGetCString(lNewRoute, route,sizeof(route), kCFStringEncodingUTF8);
        // NSLog(@"Current audio route is [%s]",route);
        return (    kCFCompareEqualTo == CFStringCompare (lNewRoute,CFSTR("Speaker"),0) 
                ||  kCFCompareEqualTo == CFStringCompare (lNewRoute,CFSTR("SpeakerAndMicrophone"),0));
    } else 
        return false;
}




- (void)dealloc {
    [super dealloc];
}


@end
