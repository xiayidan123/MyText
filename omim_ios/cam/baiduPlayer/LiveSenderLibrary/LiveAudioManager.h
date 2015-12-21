#import <CoreFoundation/CoreFoundation.h>
extern NSString * const LivePlayerInterruptedStateChangeNotification;
typedef void (^LiveAudioManagerOutputBlock)(float *data, UInt32 numFrames, UInt32 numChannels);

@protocol LiveAudioManager <NSObject>

@property (readonly) UInt32             numOutputChannels;
@property (readonly) Float64            samplingRate;
@property (readonly) UInt32             numBytesPerSample;
@property (readonly) Float32            outputVolume;
@property (readonly) BOOL               playing;
@property (readonly, strong) NSString   *audioRoute;
/**
 @abstract 当前视频是否被外界因素打断（只读）。
 @discussion isInterrupted值的更改逻辑：
 
 * 当音频队列被外界因素如电话，等打断后，如果播放器被打断，则会发送LivePlayerInterruptedStateChangeNotification通知，并将isInterrupted置为YES。
 * 当打断结束后，此时isInterrupted值为NO。
 @since Available in LivePlayerController 1.0 and later.
 @see prepareToPlayWithParameters:
 */

@property(nonatomic, readonly)  BOOL    isInterrupted;
@property (readwrite, copy) LiveAudioManagerOutputBlock outputBlock;
- (BOOL) activateAudioSession;
- (void) deactivateAudioSession;
- (BOOL) play;
- (void) pause;

@end

@interface LiveAudioManager : NSObject
+ (id<LiveAudioManager>) audioManager;
@end
