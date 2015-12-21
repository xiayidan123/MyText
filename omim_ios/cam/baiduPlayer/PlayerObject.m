//
//  PlayerObject.m
//  Joyshow
//
//  Created by xiaohuihu on 15/2/10.
//  Copyright (c) 2015年 joyshow. All rights reserved.
//
#define msAK                    @"ZIAgdlC7Vw7syTjeKG9zS4QP"
#define msSK                    @"pavlqfU4mzYQ1dH0NG3b7LyXNBy5SYk6"

#import "PlayerObject.h"


@implementation PlayerObject
+ (instancetype)shareJoyshowPlayer
{
    static PlayerObject *joyshowPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        joyshowPlayer = [[PlayerObject alloc] init];
        
        //添加百度开发者中心应用对应的APIKey和SecretKey。
//        [[LivePlayerController class]setBAEAPIKey:msAK SecretKey:msSK ];
        // init 播放器
        joyshowPlayer.player = [[LivePlayerController alloc] init];
        //注册播放器的通知
        [joyshowPlayer registerNotification];
        
    });
    return joyshowPlayer;
}

- (UIView *)createView:(CGRect)view
{
    //清除残留影像
    if (self.player.view.superview) {
        [self.player.view removeFromSuperview];
    }
//    self.player.shouldAutoClearRender = YES;
    self.player.shouldAutoplay = YES;
    
    [self.player.view setFrame:view];
    return self.player.view;
}

- (void)setFrame:(CGRect)frame
{
//    self.player.shouldAutoClearRender = YES;
    self.player.shouldAutoplay = YES;
    [self.player.view setFrame:frame];
}

- (void)setUrl:(NSString *)url
{
    if (!self.player) {
        self.player = [[LivePlayerController alloc] init];
    }
    self.player.contentURL = url;
    self.player.shouldAutoplay = YES;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[LivePlayerParameterDisableDeinterlacing] = @(YES);
    [self.player prepareToPlayWithParameters:parameters];
}

- (void)registerNotification
{
    //注册监听，播放器完成视频的初始化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onpreparedListener:)
                                                 name: LivePlayerLoadDidPreparedNotification
                                               object:nil];
//    //注册监听，播放器完成视频播放位置调整
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(seekComplete:)
//                                                 name:CyberPlayerSeekingDidFinishNotification
//                                               object:nil];
    //注册监听，播放器播放完视频
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerBackDidFinish:)
                                                 name:LivePlayerPlaybackDidFinishNotification
                                               object:nil];
//    //注册监听，播放器播放失败
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playerBackError:)
//                                                 name:CyberPlayerPlaybackErrorNotification
//                                               object:nil];
    //注册监听，解码错误
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerBackError:)
                                                 name:LivePlayerDecoderErrorNotification
                                               object:nil];
    

    
    //注册监听，当播放器开始缓冲时发送通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(startCaching:)
    //                                                 name:CyberPlayerStartCachingNotification
    //                                               object:nil];
    //播放状态发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateDidChange:)
                                                 name:LivePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    //注册监听，当播放器缓冲视频过程中不断发送该通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GotCachePercent:)
                                                 name:LivePlayerShouldCachedStateChangeNotification
                                               object:nil];
    
    //注册网速监听，在播放器播放过程中，每秒发送实时网速(单位：bps）CyberPlayerGotNetworkBitrateKbNotification通知。
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(showNetworkStatus:)
//                                                 name:CyberPlayerGotNetworkBitrateNotification
//                                               object:nil];
}

- (void)startPlay
{
    switch (self.player.playbackState) {
        case LivePlayerPlaybackStateStopped:
        case LivePlayerPlaybackStateInterrupted: {
            [self.player setContentURL:self.url];
            //初始化完成后直接播放视频，不需要调用play方法
            self.player.shouldAutoplay = YES;
            //初始化视频文件
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[LivePlayerParameterDisableDeinterlacing] = @(YES);
            [self.player prepareToPlayWithParameters:parameters];
            break;
        }
        case LivePlayerPlaybackStatePlaying:
        case LivePlayerPlaybackStatePaused: {
            //如果当前正在播放视频时，暂停播放。
            //如果当前播放视频已经暂停，重新开始播放。
            [self.player play];
            break;
        }
        default:
            break;
    }
}

- (void)prepareToPlay
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[LivePlayerParameterDisableDeinterlacing] = @(YES);
    [self.player prepareToPlayWithParameters:parameters];}
- (void)play
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player play];
//    });
}
- (void)stopPlay
{
    [self.player stop];
    //清除残留影像
//    if (self.player.view.superview) {
//        [self.player.view removeFromSuperview];
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)pausePlay
{
    [self.player pause];
}

//播放位置切换
- (void)seekTo:(int)currentTime
{
//    [self.player seekTo:currentTime];
    [self.player setMoviePosition:currentTime];
}


#pragma mark - Notification
//视频文件完成初始化
- (void)onpreparedListener: (NSNotification*)aNotification
{
    //视频文件完成初始化，开始播放视频。
    //获取视频总时长
    self.duration = self.player.duration;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerOnpreparedListener)]) {
        [self.delegate playerOnpreparedListener];
    }
}
//播放器完成视频播放位置调整
- (void)seekComplete:(NSNotification*)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerSeekComplete)]) {
        [self.delegate playerSeekComplete];
    }
}
//播放完成
- (void)playerBackDidFinish:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerFinish)]) {
        [self.delegate playerFinish];
    }
}
//播放失败
- (void)playerBackError:(NSNotification*)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBackError)]) {
        [self.delegate playerBackError];
    }
}
//缓冲过程
- (void)GotCachePercent:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerGotCachePercent:)]) {
        [self.delegate playerGotCachePercent:[[notification object] intValue]];
    }
}
//播放状态发生改变
- (void)stateDidChange:(NSNotification *)notif
{
    self.playbackState = self.player.playbackState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerStateDidChange:)]) {
        [self.delegate playerStateDidChange:self.player.playbackState];
    }
}

//实时监测网速
- (void)showNetworkStatus:(NSNotification *)notif
{
    [PlayerObject shareJoyshowPlayer].currentDuration = self.player.currentPlaybackTime;
    //    NSLog(@"当前时刻：%f",self.player.currentPlaybackTime);
    if (self.delegate && [self.delegate respondsToSelector:@selector(listenNetworkSpeed:)]) {
        [self.delegate listenNetworkSpeed:[[notif object] intValue]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
