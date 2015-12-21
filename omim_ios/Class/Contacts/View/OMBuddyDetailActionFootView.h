//
//  OMBuddyDetailActionFootView.h
//  dev01
//
//  Created by Starmoon on 15/7/29.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMBuddyDetailActionFootView;

@protocol OMBuddyDetailActionFootViewDelegate <NSObject>

@optional

/** 点击发送消息按钮 */
- (void)didClickSendMessageButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view;

/** 点击语音聊天按钮 */
- (void)didClickVoiceButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view;

/** 点击视频聊天按钮 */
- (void)didClickVideoButtonWithFootView:(OMBuddyDetailActionFootView *)foot_view;


@end



@interface OMBuddyDetailActionFootView : UIView

@property (assign, nonatomic) id<OMBuddyDetailActionFootViewDelegate> delegate;


+ (instancetype)buddyDetailActionFootView;


@end
