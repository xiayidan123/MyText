//
//  ViewController.h
//  LivePlayerapp


#import <UIKit/UIKit.h>

//@class LivePlayerDecoder;

extern NSString * const LivePlayerParameterMinBufferedDuration;    // Float
extern NSString * const LivePlayerParameterMaxBufferedDuration;    // Float
extern NSString * const LivePlayerParameterDisableDeinterlacing;   // BOOL

extern NSString * const LivePlayerLoadDidPreparedNotification;
extern NSString * const LivePlayerPlaybackStateDidChangeNotification;
extern NSString * const LivePlayerShouldCachedStateChangeNotification;
extern NSString * const LivePlayerDecoderErrorNotification;
extern NSString * const LivePlayerPlaybackDidFinishNotification;

@interface LivePlayerController : UIViewController<UIGestureRecognizerDelegate>
//#ifdef DEBUG
//<UITableViewDataSource, UITableViewDelegate>
//#endif

enum {
    LivePlayerPlaybackStateStopped, // 播放器处于停止状态
    LivePlayerPlaybackStatePlaying, // 播放器正在播放视频
    LivePlayerPlaybackStatePaused, // 播放器处于播放暂停状态，需要调用start或play重新回到播放状态
    LivePlayerPlaybackStateInterrupted, // 播放器由于内部原因中断播放
    LivePlayerPlaybackStatePrepared // 播放器完成对视频的初始化
};
typedef NSInteger LivePlayerPlaybackState;

/**
 @abstract 当前播放器的播放状态（只读）。
 @discussion 播放状态共5种状态，请见数据类型LivePlayerPlaybackState。
 
 枚举数据类型，视频播放状态。
 enum {
 LivePlayerPlaybackStateStopped,
 LivePlayerPlaybackStatePlaying,
 LivePlayerPlaybackStatePaused,
 LivePlayerPlaybackStateInterrupted,
 LivePlayerPlaybackStatePrepared
 };
 typedef NSInteger LivePlayerPlaybackState;
 
 播放器状态说明：
 
 * LivePlayerPlaybackStateStopped，播放器处于停止状态。
 * LivePlayerPlaybackStatePlaying，播放器正在播放视频。
 * LivePlayerPlaybackStatePaused，播放器处于播放暂停状态，需要调用start或play重新回到播放状态。
 * LivePlayerPlaybackStateInterrupte，播放器由于内部原因中断播放。
 * LivePlayerPlaybackStatePrepared，播放器完成对视频的初始化。
 
 @discussion 播放状态变换逻辑：
 
 * 播放器初始化完成后处于LivePlayerPlaybackStateStopped状态，调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法，如果完成对视频文件的初始化则进入LivePlayerPlaybackStatePrepared状态，如果对视频文件的初始化失败则进入LivePlayerPlaybackStateStopped状态。
 * 当播放器处于LivePlayerPlaybackStatePrepared状态，调用[start]([LivePlayerController start])或[play]([LivePlayerController play])方法进入LivePlayerPlaybackStatePlaying状态；调用[stop]([LivePlayerController stop])方法回到LivePlayerPlaybackStateStopped状态。
 
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic, readonly)  LivePlayerPlaybackState playbackState;
//+ (id) movieViewControllerWithContentPath: (NSString *) path
//                               parameters: (NSDictionary *) parameters;


@property (readonly) BOOL playing;
/**
 @abstract 播放视频时是否需要自动播放，默认值为YES。
 @discussion 如果shouldAutoplay值为YES，则调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法后，播放器完成初始化后将自动调用[play]([LivePlayerController play])方法播放视频。如果shouldAutoplay值为NO，则播放器完成初始化后将等待外部调用[play]([LivePlayerController play])方法或者[start]([LivePlayerController start])方法。
 开发者可以监听播放器发送的LivePlayerLoadDidPreparedNotification通知。在收到该通知后进行其他操作并主动调用[play]([LivePlayerController play])或[start]([LivePlayerController start])方法开启播放。
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic)            BOOL shouldAutoplay;

/**
 @abstract 当前视频是否完成初始化（只读）。
 @discussion isPreparedToPlay值的更改逻辑：
 
 * 当调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法后，如果播放器完成该视频的初始化，则会发送LivePlayerLoadDidPreparedNotification通知，并将isPreparedToPlay置为YES。
 * 当调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法后，如果播放器初始化失败，则发送LivePlayerPlaybackErrorNotification，此时isPreparedToPlay值为NO。
 @since Available in LivePlayerController 1.0 and later.
 @see prepareToPlayWithParameters:
 */
@property(nonatomic, readonly)  BOOL isPreparedToPlay;

/**
 @abstract 当前视频是否需要缓冲（只读）。
 @discussion shouldCached值的更改逻辑：
 
 * 当缓冲区的数据不满的情况下shouldCached值为YES，数据满的情况下shouldCached值为NO。
 * 当shouldCached值的变化的时候播放器内部会发送LivePlayerShouldCachedStateChangeNotification。
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic, readonly)  BOOL shouldCached;

/**
 @abstract 视频文件的URL地址，该地址可以是本地地址或者服务器地址。
 @discussion 当播放器正在播放视频时，设置contenURL将不会导致播放新视频。如果希望播放新视频，需要调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters])方法.
 @since Available in LivePlayerController 1.0 and later.
 @warning LivePlayerController当前并不支持播放百度影音资源（bdhd://开头的视频资源）.
 @see contentString
 */
@property(nonatomic, copy)      NSString *contentURL;

/**
 @abstract 读取视频文件的已经播放过的长度，开发者可监听slidervalue值的改变来改变自己界面滑动条的值。
 @since Available in LivePlayerController 1.0 and later.
 */

@property(nonatomic,readonly) float slidervalue;

/**
 @abstract 视频播放启动时的播放时刻，单位为秒。
 @discussion 当视频未开始播放时（此时[isPreparedToPlay]([LivePlayerController isPreparedToPlay])属性为NO），为了实现改变视频播放的初始时刻，三种方式都可以达到相同效果：
 
 * 设置[moviePosition]([LivePlayerController moviePosition])属性;
 * 调用[setMoviePosition]([LivePlayerController setMoviePosition:])方法。
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic)            CGFloat moviePosition;



- (void) prepareToPlayWithParameters: (NSDictionary *) parameters;
/**
 @abstract 播放当前视频，功能和[play]([LivePlayerController play])一致。
 @discussion play的使用逻辑：
 
 * 如果调用play方法前已经调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])完成播放器对视频文件的初始化，且[shouldAutoplay]([LivePlayerController shouldAutoplay])属性为NO，则调用play方法将开始播放当前视频。此时播放器状态为CBPMoviePlaybackStatePlaying。
 * 如果调用play方法前已经调用[prepareToPlayWithParameters]([LivePlayerController prepareToPlayWithParameters])完成播放器对视频文件的初始化，且[shouldAutoplay]([LivePlayerController shouldAutoplay])属性为YES，则调用play方法将暂停播放当前视频，实现效果和pause一致。
 * 如果调用play方法前未调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])完成播放器对视频文件的初始化，则播放器自动调用[prepareToPlayWithParameters]([LivePlayerController prepareToPlayWithParameters:])进行视频文件的初始化工作。
 * 如果调用play方法前已经调用pause暂停了正在播放的视频，则重新开始启动播放视频。
 @see start
 */

/**
 @abstract 播放视频的当前时刻，格式是 1：30：20（h,m,s）
 @discussion currentPlaybackTime的使用逻辑：
 开发者监听该属性的值，如果改变进行相应的处理，如：_leftLabel.text=[LivePlayerController currentPlaybackTime]
 @since Available in LivePlayerController 1.0 and later.
 @see seekTo:
 @see initialPlaybackTime
 */
@property(nonatomic,readonly)             NSTimeInterval currentPlaybackTime;

/**
 @abstract 视频的总时长，单位为秒。
 @discussion duraton的获取时机：
 
 * 当调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法后，并不能立即获得duration的值（默认视频时长为0）。只有播放器发送LivePlayerLoadDidPreparedNotification通知后，duration值才有效，你可以监听LivePlayerLoadDidPreparedNotification来获取duration的值。这也意味着[isPreparedToPlay]([LivePlayerController isPreparedToPlay])值为YES时，duration值才有效。
 * 当播放网络视频时，视频时长duration的值可能会变化。
 * 如果播放直播视频，duration值恒定为0。
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic, readonly)   float duration;

/**
 @abstract 当前可播放视频的长度（只读），格式是 1：50：30（h,m,s）。
 @discussion 开发者监听该属性的值，如果改变进行相应的处理，如：_rightLabel.text=[LivePlayerController playableDuration]。
 @since Available in LivePlayerController 1.0 and later.
 */
@property(nonatomic, readonly)  NSTimeInterval playableDuration;

- (void) play;
/**
 @abstract 暂停播放当前视频。
 @discussion pause调用逻辑：
 
 * 如果当前视频播放已经暂停，调用该方法将不产生任何效果。
 * 重新回到播放状态，需要调用[play]([LivePlayerController play])方法。
 * 如果调用pause方法后视频暂停播放，此时播放器状态处于CBPMoviePlaybackStatePaused。
 * 播放器内部监听了UIApplicationWillEnterForegroundNotification通知，该通知发生时如果视频仍然在播放，将自动调用pause暂停当前视频播放。
 */

- (void) pause;

/**
 @abstract 暂停播放当前视频。
 @discussion stop调用逻辑：
 
 * 如果当前视频播放已经暂停，调用该方法将不产生任何效果。
 * 重新回到播放状态，需要调用[prepareToPlayWithParameters:]([LivePlayerController prepareToPlayWithParameters:])方法。
 * 如果调用pause方法后视频暂停播放，此时播放器状态处于LivePlayerPlaybackStatePaused。
 *
 */

- (void) stop;

/**
 @abstract 改变当前视频的播放位置，单位为秒。
 @param newPos 指定新的播放位置。
 @discussion setMoviePosition:调用逻辑,
 
 * 当isPreparedToPlay属性值为NO时，调用setMoviePosition方法将改变position属性值。当播放器完成视频的初始化工作后（此时isPreparedToPlay属性为YES），将从setMoviePosition:方法指定的位置开始播放视频。
 * 当播放视频过程中调用setMoviePosition:，将导致从指定位置开始播放。
 @since Available in LivePlayerController 1.0 and later.
 @see currentPlaybackTime
 */


- (void) setMoviePosition: (CGFloat) position;

/**
 @abstract 当前视频是否开启音频。
 @discussion validAudio值的更改逻辑：
 
 * 开发者可以根据自己的需求是否去打开音频，默认是打开的。
 @since Available in LivePlayerController 1.0 and later.
 */

@property (assign, nonatomic) BOOL validAudio;


@end

