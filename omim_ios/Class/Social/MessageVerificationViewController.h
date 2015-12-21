//
//  MessageVerificationViewController.h
//  dev01
//
//  Created by mac on 14/12/30.
//  Copyright (c) 2014年 wowtech. All rights reserved.
//

#import "OMViewController.h"
#import "Buddy.h"
@class MessageVerificationViewController;

@protocol MessageVerificationViewControllerDelegate <NSObject>

@optional
- (void)didAddBuddyWithUID:(NSString *)uid;


/** 添加请求发送 */
- (void)messageVerificationViewController:(MessageVerificationViewController *)messageVerificationVC didAddBuddy:(Buddy *)buddy;



@end

@interface MessageVerificationViewController : OMViewController

@property (nonatomic,assign) id<MessageVerificationViewControllerDelegate>delegate;
@property (nonatomic,retain) Buddy *buddy;


@end
