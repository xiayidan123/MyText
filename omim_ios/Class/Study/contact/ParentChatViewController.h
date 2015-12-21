//
//  ParentChatViewController.h
//  dev01
//
//  Created by Huan on 15/4/1.
//  Copyright (c) 2015年 wowtech. All rights reserved.
//

#import "SchoolViewController.h"
@class ParentChatViewController;

@protocol ParentChatViewControllerDelegate <NSObject>

- (void)didBeginChat:(ParentChatViewController *)parentChatViewController;

@end

@interface ParentChatViewController : SchoolViewController

@property (assign, nonatomic)id<ParentChatViewControllerDelegate>sub_delegate;

@end
