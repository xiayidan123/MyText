//
//  PlayerObject.h
//  Joyshow
//
//  Created by xiaohuihu on 15/2/10.
//  Copyright (c) 2015年 joyshow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePlayerController.h"


//enum {
//    MyCBPMoviePlaybackStateStopped, // 播放器处于停止状态
//    MyCBPMoviePlaybackStatePlaying, // 播放器正在播放视频
//    MyCBPMoviePlaybackStatePaused, // 播放器处于播放暂停状态，需要调用start或play重新回到播放状态
//    MyCBPMoviePlaybackStateInterrupted, // 播放器由于内部原因中断播放
//    MyCBPMoviePlaybackStatePrepared // 播放器完成对视频的初始化
//};
//typedef NSInteger MyCBPMoviePlaybackState;


@class PlayerObject;
@protocol PlayerObjectDelegate <NSObject>
//初始化完成
- (void)playerOnpreparedListener;
//完成播放位置调整
- (void)playerSeekComplete;
//网络下载速度
- (void)listenNetworkSpeed:(int)speed;
//缓冲过程的进度
- (void)playerGotCachePercent:(int)percent;
//播放状态改变
- (void)playerStateDidChange:(LivePlayerPlaybackState)playbackState;
//播放失败
- (void)playerBackError;
//播放完成
- (void)playerFinish;

@end

@interface PlayerObject : NSObject
//视频对象
@property (strong, nonatomic) LivePlayerController *player;
//播放器frame
@property (assign, nonatomic) CGRect frame;
//视频URL
@property (copy, nonatomic) NSString *url;
//视频状态
@property(nonatomic, readwrite)  LivePlayerPlaybackState playbackState;
//视频总时长
@property(nonatomic, readwrite)  NSTimeInterval duration;
//视频当前时长
@property(nonatomic, readwrite)  NSTimeInterval currentDuration;

+ (instancetype)shareJoyshowPlayer;
- (UIView *)createView:(CGRect)view;

- (void)prepareToPlay;
- (void)startPlay;
- (void)play;
- (void)stopPlay;
- (void)pausePlay;
//- (void)playWith:(NSString *)url;
- (void)seekTo:(int)currentTime;

@property (assign, nonatomic) id<PlayerObjectDelegate>delegate;

@end
